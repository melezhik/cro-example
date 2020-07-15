use Cro::HTTP::Router;
use Cro::HTTP::Server;
use DBIish;

my $dbh = DBIish.connect(
  "mysql",
  host      => %*ENV<DBHOST>,
  port      => 3306,
  database  => %*ENV<DBNAME>,
  user      => %*ENV<DBUSER>,
);

my $application = route {

    get -> "todo" {

        my @list;

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT id, data, action from todo
        STATEMENT
    
        $sth.execute();
    
        my @rows = $sth.allrows();
    
        content 'text/plain', @rows.perl;
 
    }

    post ->  "todo", :%params {

        my $sth = $dbh.prepare(q:to/STATEMENT/);
          INSERT INTO todo (action)
          VALUES ( ? )
        STATEMENT
    
    
        request-body -> (:$name, :$action) {
          $sth.execute($action);
          $sth.finish;
          content 'text/plain', "$action saved!";
        }
    }
}

my Cro::Service $hello = Cro::HTTP::Server.new:
    :host<localhost>, :port<8080>, :$application;
$hello.start;
react whenever signal(SIGINT) { $hello.stop; exit; }


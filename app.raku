use Cro::HTTP::Router;
use Cro::HTTP::Server;

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
        content 'text/plain', @list.join("\n");
    }

    post ->  "todo", :%params {
        request-body -> (:$name, :$action) {
          content 'text/plain', "$action saved!";
        }
    }
}

my Cro::Service $hello = Cro::HTTP::Server.new:
    :host<localhost>, :port<8080>, :$application;
$hello.start;
react whenever signal(SIGINT) { $hello.stop; exit; }


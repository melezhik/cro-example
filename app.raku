use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Red:api<2>;

my $*RED-DEBUG = True;

model Todo is rw {
    has Int  $.id            is serial;
    has Str  $.action        is column;
    has DateTime    $.created   is column .= now;
    
}

#Todo.^create-table;

my $application = route {


    
    get -> "todo" {
        my $*RED-DB = database "SQLite", :database<todo.db>;
        my @list;
        for Todo.^all -> $i {
          push @list, $i.action;
        }
          
        content 'text/plain', @list.join("\n");
    }

    post ->  "todo", :%params {
        my $*RED-DB = database "SQLite", :database<todo.db>;
        request-body -> (:$name, :$action ) {
          Todo.^create( action => $action );
          content 'text/plain', "$action saved!";
        }
    }
}
my Cro::Service $hello = Cro::HTTP::Server.new:
    :host<localhost>, :port<8080>, :$application;
$hello.start;
react whenever signal(SIGINT) { $hello.stop; exit; }


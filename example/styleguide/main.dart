library wsk_angular.example.styleguide;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

//import 'package:webapp_base_ui_angular/angular/decorators/flexbox_navi_handler.dart';
//import 'package:webapp_base_ui_angular/angular/decorators/navbaractivator.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

// Components
import 'package:wsk_angular/wsk_button/wsk_button.dart';

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.styleguide.AppController');

    final Router _router;
    final String _classToChange = "active";

    @NgOneWay('name') // only for demonstration!!!
    String get name => _router.activePath[0].name;

    AppController(this._router) {
        _logger.fine("AppController");
    }

    bool isActive(final String link) {
        //_logger.fine("Location: ${_router.activePath[0].name} : Link: $link");
        return link != null && _router.activePath[0].name == link;
    }
}

void myRouteInitializer(Router router, RouteViewFactory view) {
    // @formatter:off
    router.root
        ..addRoute(

            name: "home",
            path: "/home",
            //enter: view("views/first.html"),
            defaultRoute: true,

            mount: (Route route) => route
                ..addRoute(
                    defaultRoute: true,
                    name: 'home',
                    path: '/home',
                    enter: view('views/home.html'))
                ..addRoute(
                    name: 'firstsub',
                    path: '/sub',
                    enter: view('views/firstsub.html'))
        )
        ..addRoute(
            name: "button",
            path: "/button",
            enter: view("views/button.html")
        )
        ..addRoute(
           name: "typography",
            path: "/typography",
            enter: view("views/typography.html")
    );
    // @formatter:on
}

class SampleModule extends Module {
    SampleModule() {
        bind(RouteInitializerFn, toValue: myRouteInitializer);

        bind(AppController);

        // Components
        install(new WskButtonModule());


        bind(NgRoutingUsePushState, toFactory: () => new NgRoutingUsePushState.value(false));
    }
}

void main() {
    configLogger();
    applicationFactory().addModule(new SampleModule()).rootContextType(AppController).run();
    //applicationFactory().addModule(new SampleModule()).run();
}

//// Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference
void configLogger() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
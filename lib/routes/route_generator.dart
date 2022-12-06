import 'package:flutter/material.dart';
import 'package:playstation_game/routes/route_name.dart';
import 'package:playstation_game/ui/detail/detail_game_screen.dart';
import 'package:playstation_game/utils/common/screen_arguments.dart';

import '../ui/home_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch(settings.name){
      case AppRoutes.homeScreen:
        return _GeneratePageRoute(widget:  HomeScreen(), routeName: settings.name);
        case AppRoutes.gameDetail:
          ScreenArguments screenArguments = settings.arguments as ScreenArguments;
          return _GeneratePageRoute(widget:  DetailGameScreen(
            screenArguments.games
          ), routeName: settings.name );

    }
    return null;


  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget? widget;
  final String? routeName;

  _GeneratePageRoute({this.widget, this.routeName})
      : super(
    settings: RouteSettings(name: routeName),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget!;
    },
  );
}

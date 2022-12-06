import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/bloc/detailGames/detail_game_bloc.dart';
import 'package:playstation_game/routes/route_generator.dart';
import 'package:playstation_game/routes/route_name.dart';
import 'core/bloc/games/games_bloc.dart';
import 'core/network/repository/games_repository.dart';


GlobalKey currentGlobalKey=GlobalKey();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(

      providers: [
        RepositoryProvider<GamesRepository>(create: (context) => GamesRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GamesBloc(repository: GamesRepository()),
          ),
          BlocProvider<DetailGameBloc>(
            create: (context) => DetailGameBloc(repository: GamesRepository()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: ThemeData.dark(),
          initialRoute: AppRoutes.homeScreen,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}

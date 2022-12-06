//Widget testing
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/bloc/games/bloc.dart';
import 'package:playstation_game/core/network/repository/games_repository.dart';
import 'package:playstation_game/main.dart';
import 'package:playstation_game/routes/route_generator.dart';
import 'package:playstation_game/routes/route_name.dart';

void main() {
  testWidgets("Material app testing", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });



  testWidgets("Home screen text testing", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MultiRepositoryProvider(
          providers: [
            RepositoryProvider<GamesRepository>(create: (context) => GamesRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => GamesBloc(repository: GamesRepository()),
              ),
            ],
            child: MaterialApp(
              initialRoute: AppRoutes.homeScreen,
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          )));
      final gameText = find.text(AppStrings.headerTitle);
      expect(gameText, findsWidgets);
    });
  });


  testWidgets("Home screen Icon testing", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MultiRepositoryProvider(
          providers: [
            RepositoryProvider<GamesRepository>(create: (context) => GamesRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => GamesBloc(repository: GamesRepository()),
              ),
            ],
            child: MaterialApp(
              initialRoute: AppRoutes.homeScreen,
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          )));
      final globalKey = find.byKey(currentGlobalKey, skipOffstage: false);
      expect(globalKey, findsWidgets);
      var row = find.byType(Row);
      expect(row, findsWidgets);
      var icon = find.byIcon(Icons.list);
      await tester.tap(icon);
      await tester.pump();

    });
  });
}

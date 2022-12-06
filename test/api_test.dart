import 'package:flutter_test/flutter_test.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/bloc/detailGames/bloc.dart';
import 'package:playstation_game/core/bloc/games/games_bloc.dart';
import 'package:playstation_game/core/network/api/api_constant.dart';
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/results.dart';
import 'package:playstation_game/core/network/repository/games_repository.dart';

void main() {
  Result? results;
  group("API calls testing", () {
    test(
      "Testing the get game api call",
      () async {
        GamesRepository gamesRepository = GamesRepository();
        GamesBloc gamesBloc = GamesBloc(repository: gamesRepository);
        Result? result = await gamesRepository.getGames(
            "1", "20", GamesBloc.getDate(), ApiConstant.apiKey, AppStrings.platform, AppStrings.releasingOrder);
        results = result;
        expect(results!.results!.length > 0, true);
      },
    );
  });
  test("Testing game detail api call", () async {
    GamesRepository gamesRepository = GamesRepository();
    DetailGameBloc gamesDetailBloc = DetailGameBloc(repository: gamesRepository);
    Games? games = await gamesRepository.getDetailGames(447808,
        ApiConstant.apiKey);
    expect(games!=null,true);


  });
}

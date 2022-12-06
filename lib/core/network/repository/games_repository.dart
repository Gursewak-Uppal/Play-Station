import 'package:flutter/cupertino.dart';
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/results.dart';
import 'package:playstation_game/core/network/repository/remote/api_repository.dart';
import 'package:playstation_game/core/network/repository/repository.dart';


class GamesRepository implements Repository {
  final ApiRepository? apiRepository;

  static final GamesRepository _singleton =
      GamesRepository._internal(apiRepository: ApiRepository());

  factory GamesRepository() {
    return _singleton;
  }

  GamesRepository._internal({@required this.apiRepository});

  @override
  Future<Result> getGames(String page,String pageSize,String dates,String apiKey,String platform,String releasingOrder) async {
    return await apiRepository!.getGames(page,pageSize,dates,apiKey,platform,releasingOrder);
  }

  @override
  Future<Games> getDetailGames(int id,String apiKey) async {
    return await apiRepository!.getDetailGames(id, apiKey);
  }
}

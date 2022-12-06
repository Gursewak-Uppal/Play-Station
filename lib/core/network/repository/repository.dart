
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/results.dart';

abstract class Repository {
  Future<Result> getGames(String page,String pageSize,String dates,String apiKey,String platform,String releasingOrder);
  Future<Games> getDetailGames(int id,String apiKey);
}

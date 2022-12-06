import 'package:dio/dio.dart';
import 'package:playstation_game/core/network/api/rest_client.dart';
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/results.dart';

import '../repository.dart';

class ApiRepository implements Repository {
  Dio? _dio;
  RestClient? _restClient;

  ApiRepository() {
    _dio = Dio();
    _restClient = RestClient(_dio!);
  }

  @override
  Future<Result> getGames(String page, String pageSize, String dates,String apiKey,String platform,String releasingOrder) {
    return _restClient!.getGames(page, pageSize, dates,apiKey,platform,releasingOrder);
  }

  @override
  Future<Games> getDetailGames(int id,String apiKey) {
    return _restClient!.getDetailGame(id, apiKey);
  }

}

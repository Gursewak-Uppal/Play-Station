import 'package:dio/dio.dart' hide Headers;
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/results.dart';
import 'package:retrofit/retrofit.dart';

import 'api_constant.dart';
part 'rest_client.g.dart';


@RestApi(baseUrl: ApiConstant.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("games?page={page}&page_size={page_size}&dates={dates}&key={key}&platforms={platforms}&ordering={ordering}")
  Future<Result> getGames(@Path("page")String page,@Path("page_size")String pageSize,@Path("dates")String date,@Path("key")String apiKey,@Path("platforms")String platform,@Path("ordering")String releasingOrder);

  @GET("games/{id}?key={key}")
  Future<Games> getDetailGame(@Path("id") int id,@Path("key")String apiKey);

}
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/network/api/api_constant.dart';
import 'package:playstation_game/core/network/repository/repository.dart';

import 'bloc.dart';

class DetailGameBloc extends Bloc<DetailGameEvent, DetailGameState> {
  final Repository? repository;

  DetailGameBloc({this.repository}) : super(InitialDetailGame()) {
    on<LoadDetailGame>(loadDetailGame);
  }

  FutureOr<void> loadDetailGame(LoadDetailGame event, Emitter<DetailGameState> emit) async {
    try {
      emit(DetailGameLoading());
      var game = await repository!.getDetailGames(event.id,ApiConstant.apiKey);
      if (game == null) {
        emit(DetailGameNoData(AppStrings.detailGameNotFound));
      } else {
        emit(DetailGameHasData(game));
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.response) {
        emit(DetailGameNoInternetConnection());
      } else {
        emit(DetailGameError(e.message));
      }
    }
  }
}

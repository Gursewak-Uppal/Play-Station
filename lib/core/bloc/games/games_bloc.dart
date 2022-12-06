import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/network/api/api_constant.dart';
import 'package:playstation_game/core/network/model/results.dart';
import 'package:playstation_game/core/network/repository/repository.dart';

import 'bloc.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final Repository repository;

  GamesBloc({required this.repository})
      : super(
          GamesLoading(),
        ) {
    on<LoadGames>((_loadGames));
    on<FetchMoreGames>((_changeFetchValue));
    on<ListViewSelected>(_changeDisplayView);
    on<ResetValue>(_resetValue);
  }

  Future<FutureOr<void>> _loadGames(LoadGames event, Emitter<GamesState> emit) async {
    try {
      if (event.page == null) emit(GamesLoading());
      Result? games = await repository.getGames(event.page ?? "1", state.pageSize, getDate(), ApiConstant.apiKey,
          AppStrings.platform, AppStrings.releasingOrder);
      if (games.results!.isEmpty) {
        emit(GamesNoData(AppStrings.noGameFound));
      } else {
        emit(state.copyWith(result: games.results));
        if (games.results!.length == 0) {
          emit(state.copyWith(hasMoreData: false));
        }
        int currentPage = state.currentPage!;
        currentPage++;
        emit(state.copyWith(currentPage: currentPage));
        emit(state.copyWith(isLoading: false));
        emit(state.copyWith(isFetchingMore: false));
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout || e.type==DioErrorType.other) {
        emit(GamesNoInternetConnection());
      } else if (e.type == DioErrorType.response) {
        emit(GamesNoInternetConnection());
      }
      else {
        emit(GamesError(e.toString()));
      }
    }
  }

  static String getDate() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);
    String returnDate = "${dateFormat.format(startDate)},${dateFormat.format(endDate)}";
    return returnDate;
  }

  Future<FutureOr<void>> _changeFetchValue(FetchMoreGames event, Emitter<GamesState> emit) async {
    emit(state.copyWith(isFetchingMore: event.fetchingMore));
  }

  FutureOr<void> _changeDisplayView(ListViewSelected event, Emitter<GamesState> emit) {
    emit(state.copyWith(isListViewSelected: event.listView));
  }

  FutureOr<void> _resetValue(ResetValue event, Emitter<GamesState> emit) {
    emit(state.copyWith(hasMoreData: false));
  }
}

import 'package:equatable/equatable.dart';
import 'package:playstation_game/core/network/model/games.dart';

class GamesState extends Equatable {
 final String pageSize = "20";
 final int? currentPage;
 final bool? hasMoreData;

 final bool? isLoading;
 final  bool? isFetchingMore;
 final List<Games>? result;
 final bool isListViewSelected;

  GamesState(
      {this.currentPage = 1, this.hasMoreData = true, this.isLoading = true, this.isFetchingMore = false, this.result,this.isListViewSelected=true});

  GamesState copyWith(
          {int? currentPage, bool? hasMoreData, bool? isLoading, bool? isFetchingMore, final  List<Games>? result,bool? isListViewSelected}) =>
      GamesState(
          currentPage: currentPage ?? this.currentPage,
          hasMoreData: hasMoreData ?? this.hasMoreData,
          isLoading: isLoading ?? this.isLoading,
          isFetchingMore: isFetchingMore ?? this.isFetchingMore,
          result: result??this.result,
          isListViewSelected:isListViewSelected??this.isListViewSelected
      );

  @override
  List<Object> get props => [currentPage!, hasMoreData!, isLoading!, isFetchingMore!, result ?? [],isListViewSelected];
}


class GamesLoading extends GamesState {}


class GamesNoData extends GamesState {
  final String message;

  GamesNoData(this.message);

  @override
  List<Object> get props => [message];
}

class GamesNoInternetConnection extends GamesState {}

class GamesError extends GamesState {
  final String errorMessage;

  GamesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}


import 'package:equatable/equatable.dart';

class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object> get props => [];
}

class LoadGames extends GamesEvent {
  final String? page;

  LoadGames({this.page});
}

class FetchMoreGames extends GamesEvent {
  final bool? fetchingMore;

  FetchMoreGames({this.fetchingMore});
}

class ListViewSelected extends GamesEvent {
  final bool? listView;

  ListViewSelected({this.listView});
}
class ResetValue extends GamesEvent {
}

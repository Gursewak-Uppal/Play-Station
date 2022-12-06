import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/bloc/games/games_bloc.dart';
import 'package:playstation_game/core/bloc/games/games_event.dart';
import 'package:playstation_game/core/bloc/games/games_state.dart';
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/genres.dart';
import 'package:playstation_game/core/network/model/parent_platform.dart';
import 'package:playstation_game/routes/route_name.dart';
import 'package:playstation_game/utils/common/screen_arguments.dart';
import 'package:playstation_game/utils/common/widget/loading_indicator.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Games>? finalResultList = [];

  @override
  void initState() {
    // TODO: implement initState
    getFuture();
    BlocProvider.of<GamesBloc>(context).add(LoadGames());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          key: currentGlobalKey,
          title: Text(
            AppStrings.headerTitle,
            style: TextStyle(fontFamily: 'Roboto-Bold'),
          ),
          actions: [
            BlocListener<GamesBloc, GamesState>(
              listener: (context, state) {
              },
              child: BlocBuilder<GamesBloc, GamesState>(builder: (context, state) {
                return Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (state.isListViewSelected) {
                            BlocProvider.of<GamesBloc>(context).add(ListViewSelected(listView: false));
                          } else {
                            BlocProvider.of<GamesBloc>(context).add(ListViewSelected(listView: true));
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: state.isListViewSelected
                                ? Icon(Icons.list)
                                : Icon(
                                    Icons.grid_view,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
        body: BlocBuilder<GamesBloc, GamesState>(builder: (context, state) {
          if (state is GamesNoInternetConnection) {
            return Container(
              child: Center(
                child: Text(AppStrings.noInternetText),
              ),
            );
          } else if (state is GamesLoading) {
            return Center(child: LoadingIndicator());
          } else {
            if (state.result != null && state.result!.length > 0) {
              finalResultList!.addAll(state.result ?? []);
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if (!state.isFetchingMore! && state.hasMoreData! && !state.isLoading!) {
                    BlocProvider.of<GamesBloc>(context).add(FetchMoreGames(fetchingMore: true));
                    BlocProvider.of<GamesBloc>(context).add(LoadGames(page: state.currentPage!.toString()));
                  }
                }
                return false;
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        state.isListViewSelected
                            ? ListView.builder(
                                itemCount: finalResultList!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  Games games = finalResultList![index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, AppRoutes.gameDetail,
                                          arguments: ScreenArguments(games));
                                    },
                                    child: Card(
                                      color: Colors.grey.withOpacity(0.2),
                                      margin: EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          games.backgroundImage != null
                                              ? Container(
                                                  child: ClipRRect(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: games.backgroundImage!,
                                                  ),
                                                ))
                                              : SizedBox.shrink(),
                                          Container(
                                              height: 40,
                                              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount: games.parentPlatform!.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          ParentPlatform parentPlatform = games.parentPlatform![index];
                                                          return Container(
                                                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                                                              child: Image.asset(
                                                                parentPlatform.platform!.getImage(),
                                                                width: 15,
                                                              ));
                                                        }),
                                                  ),
                                                  Spacer(),
                                                  games.metacritic != null
                                                      ? Container(
                                                          padding: EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(color: Colors.green)),
                                                          child: Text(
                                                            games.metacritic.toString(),
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto-Bold',
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.green),
                                                          ),
                                                        )
                                                      : SizedBox.shrink()
                                                ],
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 4, left: 16, right: 16),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      games.name!,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto-Bold',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Release Date : ',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(games.getDate(),
                                                    style: TextStyle(fontSize: 13, fontFamily: 'Roboto-Black'))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                            child: Divider(color: Colors.grey),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Genres : ',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Spacer(),
                                                Expanded(
                                                  child: Wrap(
                                                    alignment: WrapAlignment.end,
                                                    children: List.generate(games.genres!.length, (index) {
                                                      Genres genres = games.genres![index];
                                                      String name = genres.name! + ",";
                                                      if (index == games.genres!.length - 1) {
                                                        name = genres.name!;
                                                      }
                                                      return name == ""
                                                          ? SizedBox.shrink()
                                                          : Container(
                                                              margin: EdgeInsets.all(1),
                                                              child: Text(
                                                                name,
                                                                softWrap: true,
                                                                style:
                                                                    TextStyle(fontSize: 13, fontFamily: 'Roboto-Black'),
                                                              ),
                                                            );
                                                    }),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                                            child: Divider(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : GridView.builder(
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 267,
                                ),
                                itemCount: finalResultList!.length,
                                padding: EdgeInsets.only(
                                  top: 20,
                                  left: 12,
                                  right: 12,
                                ),
                                // childAspectRatio: 0.59,
                                physics: ScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  Games games = finalResultList![index];
                                  return getGridViewCard(games);
                                }),
                        if (state.isLoading!) Container(child: Center(child: LoadingIndicator()))
                      ],
                    ),
                  ),
                  if (state.isFetchingMore!)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          }
        }));
  }

  Widget getGridViewCard(Games games) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.gameDetail, arguments: ScreenArguments(games));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Wrap(
          children: <Widget>[
            games.backgroundImage != null
                ? Container(
                    child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      imageUrl: games.backgroundImage!,
                      fit: BoxFit.cover,
                    ),
                  ))
                : SizedBox.shrink(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 25.0,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: games.parentPlatform!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ParentPlatform parentPlatform = games.parentPlatform![index];
                                  return Container(
                                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                                      child: Image.asset(
                                        parentPlatform.platform!.getImage(),
                                        width: 15,
                                      ));
                                }),
                          ),
                          Spacer(),
                          games.metacritic != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.green)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      games.metacritic.toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Bold',
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.only(bottom: 4, left: 4, right: 4, top: 2.0),
                    child: Text(
                      games.name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 4, right: 4, top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Release Date : ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(games.getDate(),
                              softWrap: true,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 12, fontFamily: 'Roboto-Black')),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    child: Divider(color: Colors.grey),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 4, right: 4, top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Genres : ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: List.generate(games.genres!.length, (index) {
                              Genres genres = games.genres![index];
                              String name = genres.name! + ",";
                              if (index == games.genres!.length - 1) {
                                name = genres.name!;
                              }
                              return name == ""
                                  ? SizedBox.shrink()
                                  : Container(
                                      margin: EdgeInsets.all(1),
                                      child: Text(
                                        name,
                                        softWrap: true,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 12, fontFamily: 'Roboto-Black'),
                                      ),
                                    );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFuture() async {
    await Future.delayed(Duration(milliseconds: 100));
  }
}

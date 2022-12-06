import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_game/core/app_assets/app_strings.dart';
import 'package:playstation_game/core/bloc/detailGames/detail_game_bloc.dart';
import 'package:playstation_game/core/bloc/detailGames/detail_game_event.dart';
import 'package:playstation_game/core/bloc/detailGames/detail_game_state.dart';
import 'package:playstation_game/core/bloc/games/bloc.dart';
import 'package:playstation_game/core/network/model/games.dart';
import 'package:playstation_game/core/network/model/parent_platform.dart';
import 'package:playstation_game/core/network/model/short_screenshots.dart';
import 'package:playstation_game/utils/common/widget/expandable_text.dart';
import 'package:playstation_game/utils/common/widget/linear_progress.dart';
import 'package:playstation_game/utils/common/widget/loading_indicator.dart';

class DetailGameScreen extends StatelessWidget {
  final Games? args;

  DetailGameScreen(this.args, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailGameBloc>(context).add(LoadDetailGame(args!.id!));
    double getTotalPercent() {
      double total = 0;
      for (int i = 0; i < args!.ratings!.length; i++) {
        total += args!.ratings![i].percent!;
      }
      return total;
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: BlocBuilder<DetailGameBloc, DetailGameState>(builder: (context, state) {
                  if (state is DetailGameHasData) {
                    Games? games = state.games;
                    return SingleChildScrollView(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(args!.backgroundImage!))),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.8)],
                                    stops: [0.0, 1.0])),
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.topLeft,
                                child: SafeArea(
                                    child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<GamesBloc>(context).add(ResetValue());
                                    Navigator.pop(context);
                                  },
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                      child: Text(
                                        args!.getDate(),
                                        style: TextStyle(fontFamily: 'Roboto-Thin', color: Colors.black),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: args!.parentPlatform!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            ParentPlatform parentPlatform = args!.parentPlatform![index];
                                            return Container(
                                                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                                                child: Image.asset(
                                                  parentPlatform.platform!.getImage(),
                                                  width: 15,
                                                ));
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(args!.name!,
                                    style: TextStyle(
                                      fontFamily: 'Roboto-Bold',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.2,
                                margin: EdgeInsets.all(8),
                                child: ListView.builder(
                                    itemCount: args!.shortScreenshots!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      ShortScreenShots shortScreenshots = args!.shortScreenshots![index];
                                      return shortScreenshots.getImageView() == ""
                                          ? SizedBox.shrink()
                                          : Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(imageUrl: shortScreenshots.getImageView()),
                                              ));
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                alignment: Alignment.topLeft,
                                child: Text(AppStrings.ratingBar,
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Bold',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Container(
                                height: 40,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: ListView.builder(
                                    itemCount: 1,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              child: MyAssetsBar(
                                                width: MediaQuery.of(context).size.width * .9,
                                                background: Colors.red,
                                                assetsLimit: getTotalPercent(),
                                                assets: args!.ratings,
                                              )));
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.adjust_sharp,
                                      color: Colors.green,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4, right: 16, left: 4),
                                      child: Text(AppStrings.exceptional,
                                          style: TextStyle(fontFamily: 'Roboto-Bold', fontWeight: FontWeight.bold)),
                                    ),
                                    Icon(
                                      Icons.adjust_sharp,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4, right: 16, left: 4),
                                      child: Text(AppStrings.recommended,
                                          style: TextStyle(fontFamily: 'Roboto-Bold', fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.adjust_sharp,
                                      color: Colors.orange,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4, right: 16, left: 4),
                                      child: Text(AppStrings.meh,
                                          style: TextStyle(fontFamily: 'Roboto-Bold', fontWeight: FontWeight.bold)),
                                    ),
                                    Icon(
                                      Icons.adjust_sharp,
                                      color: Colors.red,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 4, right: 16, left: 4),
                                      child: Text(AppStrings.skip,
                                          style: TextStyle(fontFamily: 'Roboto-Bold', fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                                alignment: Alignment.topLeft,
                                child: Text(AppStrings.about,
                                    style: TextStyle(
                                        fontFamily: 'Roboto-Bold',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: ExpandableText(
                                    games!.descriptionRaw!,
                                    trimLines: 8,
                                  ))
                            ],
                          )
                        ],
                      ),
                    );
                  } else if (state is DetailGameNoData) {
                    return SafeArea(
                        child: Container(height: MediaQuery.of(context).size.height, child: Text(state.message!)));
                  } else if (state is DetailGameLoading) {
                    return SafeArea(
                        child: Container(
                            height: MediaQuery.of(context).size.height, child: Center(child: LoadingIndicator())));
                  } else if (state is DetailGameNoInternetConnection) {
                    return SafeArea(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: Text(AppStrings.noInternetText))));
                  } else if (state is DetailGameError) {
                    return SafeArea(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: Text(state.errorMessage!))));
                  } else {
                    return SafeArea(
                        child: Container(
                            height: MediaQuery.of(context).size.height, child: Center(child: LoadingIndicator())));
                  }
                }),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
              ),
            ],
          ),
        ));
  }
}

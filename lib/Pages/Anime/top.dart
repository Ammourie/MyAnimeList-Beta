import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:malbeta/Widgets/Anime/anime_card.dart';

import '../../models/Anime/AnimeDetailsModel.dart';

class TopAnimes extends StatefulWidget {
  @override
  _TopAnimesState createState() => _TopAnimesState();
}

class _TopAnimesState extends State<TopAnimes> {
  List<AnimeDetailsModel> randomAnimestaff = [];
  int animePage = 1;
  bool gettingAnimesFlag = false;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(
        'Top Animes',
        style:
            TextStyle(fontFamily: "Gibson", fontSize: 22, color: Colors.black),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  void loadMore() async {
    setState(() {
      gettingAnimesFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/top/anime/$animePage",
    );
    for (var s in res.data['top']) {
      AnimeDetailsModel tmp = new AnimeDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomAnimestaff.add(tmp);
    }
    setState(() {
      gettingAnimesFlag = false;
    });
  }

  void fetch() async {
    setState(() {
      gettingAnimesFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/top/anime/$animePage",
    );

    for (var tmp in res.data['top']) {
      AnimeDetailsModel t = new AnimeDetailsModel();
      t.setFromMap(tmp);
      randomAnimestaff.add(t);
    }
    setState(() {
      gettingAnimesFlag = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: gettingAnimesFlag && randomAnimestaff.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LazyLoadScrollView(
              child: ListView.builder(
                itemCount: randomAnimestaff.length + 1,
                itemBuilder: (context, index) {
                  return index == randomAnimestaff.length
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : AnimeCard(
                          anime: randomAnimestaff[index],
                        );
                },
              ),
              onEndOfPage: () {
                if (!gettingAnimesFlag) {
                  ++animePage;
                  print(
                      "anime page :$animePage\n---------------------------\n");
                  loadMore();
                }
              },
            ),
    );
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:malbeta/Widgets/Anime/anime_card.dart';

import '../../models/Anime/AnimeDetailsModel.dart';
import '../../models/Anime/genre_anime.dart';

class AnimeGenrePage extends StatefulWidget {
  final GenreAnimeModel genre;

  const AnimeGenrePage({Key key, this.genre}) : super(key: key);

  @override
  _AnimeGenrePageState createState() => _AnimeGenrePageState();
}

class _AnimeGenrePageState extends State<AnimeGenrePage> {
  List<AnimeDetailsModel> randomAnimestaff = [];

  int genrePage = 2;
  bool gettingAnimesFlag = false;
  @override
  void initState() {
    super.initState();
    randomAnimestaff.addAll(widget.genre.anime);
  }

  void loadMore() async {
    setState(() {
      gettingAnimesFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/genre/anime/$genrePage",
    );
    for (var s in res.data['anime']) {
      AnimeDetailsModel tmp = new AnimeDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomAnimestaff.add(tmp);
    }
    setState(() {
      gettingAnimesFlag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var si = MediaQuery.of(context).size;
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
                  ++genrePage;
                  print(
                      "anime page :$genrePage\n---------------------------\n");
                  loadMore();
                }
              },
            ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      title: new Text(
        widget.genre.name,
        style: TextStyle(
            fontFamily: "Gibson",
            fontSize: MediaQuery.of(context).size.width / 18,
            color: Colors.black),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../Widgets/Manga%20widgets/manga_card.dart';
import '../../models/Manga/MangaDetailsModel.dart';
import '../../models/Manga/genre_manga.dart';

class MangaGenresPage extends StatefulWidget {
  final GenreMangaModel genre;

  const MangaGenresPage({Key key, this.genre}) : super(key: key);
  @override
  _MangaGenresPageState createState() => _MangaGenresPageState();
}

class _MangaGenresPageState extends State<MangaGenresPage> {
  List<MangaDetailsModel> randomMangaStuff = [];

  int genrePage = 2;

  bool gettingMangaFlag = false;

  @override
  void initState() {
    super.initState();
    randomMangaStuff.addAll(widget.genre.manga);
  }

  void loadMore() async {
    setState(() {
      gettingMangaFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/genre/manga/$genrePage",
    );
    for (var s in res.data['manga']) {
      MangaDetailsModel tmp = new MangaDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomMangaStuff.add(tmp);
    }
    setState(() {
      gettingMangaFlag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var si = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: gettingMangaFlag && randomMangaStuff.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LazyLoadScrollView(
              child: ListView.builder(
                itemCount: randomMangaStuff.length + 1,
                itemBuilder: (context, index) {
                  return index == randomMangaStuff.length
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MangaCard(
                          manga: randomMangaStuff[index],
                        );
                },
              ),
              onEndOfPage: () {
                if (!gettingMangaFlag) {
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

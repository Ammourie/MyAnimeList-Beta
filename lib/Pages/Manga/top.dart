import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../Widgets/Manga%20widgets/manga_card.dart';
import '../../models/Manga/MangaDetailsModel.dart';

class TopMangas extends StatefulWidget {
  @override
  _TopMangasState createState() => _TopMangasState();
}

class _TopMangasState extends State<TopMangas> {
  List<MangaDetailsModel> randomMangastaff = [];
  int mangaPage = 1;
  bool gettingMangasFlag = false;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(
        'Top Mangas',
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
      gettingMangasFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/top/manga/$mangaPage",
    );
    for (var s in res.data['top']) {
      MangaDetailsModel tmp = new MangaDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomMangastaff.add(tmp);
    }
    setState(() {
      gettingMangasFlag = false;
    });
  }

  void fetch() async {
    setState(() {
      gettingMangasFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/top/manga/$mangaPage",
    );

    for (var tmp in res.data['top']) {
      MangaDetailsModel t = new MangaDetailsModel();
      t.setFromMap(tmp);
      randomMangastaff.add(t);
    }
    setState(() {
      gettingMangasFlag = false;
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
      body: gettingMangasFlag && randomMangastaff.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LazyLoadScrollView(
              child: ListView.builder(
                itemCount: randomMangastaff.length + 1,
                itemBuilder: (context, index) {
                  return index == randomMangastaff.length
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MangaCard(
                          manga: randomMangastaff[index],
                        );
                },
              ),
              onEndOfPage: () {
                if (!gettingMangasFlag) {
                  ++mangaPage;
                  print(
                      "manga page :$mangaPage\n---------------------------\n");
                  loadMore();
                }
              },
            ),
    );
  }
}

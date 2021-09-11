import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:dio/dio.dart';
import '../../models/Anime/AnimeDetailsModel.dart';

class AnimesGetter extends StatefulWidget {
  @override
  _AnimesGetterState createState() => _AnimesGetterState();
}

class _AnimesGetterState extends State<AnimesGetter> {
  List<AnimeDetailsModel> randomAnimestaff = [];
  List<String> randomAnimesForSearch = [
    "Fullmetal%20Alchemist:%20Brotherhood",
    "Steins;Gate",
    "Gintama°",
    "Hunter%20x%20Hunter%20(2011)",
    "Shingeki%20no%20Kyojin",
    "3-gatsu%20no%20Lion",
    "Love%20lab",
    "Love%20live",
    "Yahari",
    "One%20punch%20man",
    "Clannad",
    "Asobi%20Asobase",
    "Koe%20no%20Katachi",
    "Death%20Note",
    "Fate",
    "Demon%20slayer",
    "Naruto",
    "One%20Piece",
    "Detictive%20Conan",
    "Hyouka",
    "Monogatari",
    "Nisekoi",
    "Kaguya-sama%20wa%20Kokurasetai",
    "Skip%20Beat!",
    "Burn%20the%20Witch",
  ];
  int animePage = 1;
  bool searchingFlag = true;
  SearchBar searchBar;
  bool randomAnimeFlag = true;
  String searchText;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(
        'Animes',
        style: TextStyle(
            fontFamily: "Gibson",
            fontSize: MediaQuery.of(context).size.width / 18,
            color: Colors.black),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      backgroundColor: Theme.of(context).canvasColor,
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  void onSubmitted(String value, BuildContext conext) async {
    if (value.length < 4) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
                color: Colors.red[800], fontSize: 22, fontFamily: "Gibson"),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "You must type 4 letters or above.",
            style: TextStyle(fontSize: 17, fontFamily: "Gibson"),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      setState(() {
        searchingFlag = true;
        randomAnimeFlag = false;
        searchText = value;
        animePage = 1;
      });
      randomAnimestaff.clear();
      var res = await Dio().get(
        "https://api.jikan.moe/v3/search/anime?q=${value.replaceAll(" ", "%20")}&page=$animePage",
      );
      for (var s in res.data['results']) {
        AnimeDetailsModel tmp = new AnimeDetailsModel();
        tmp.setFromMap(Map.from(s));
        randomAnimestaff.add(tmp);
      }
      setState(() {
        searchingFlag = false;
      });
    }
  }

  void loadMore() async {
    setState(() {
      searchingFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/search/anime?q=$searchText&page=$animePage",
    );
    for (var s in res.data['results']) {
      AnimeDetailsModel tmp = new AnimeDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomAnimestaff.add(tmp);
    }
    setState(() {
      searchingFlag = false;
    });
  }

  _AnimesState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: (String value) => onSubmitted(value, context),
        hintText: "Anime Search ... ",
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  void fetch(String randomStaff) async {
    setState(() {
      searchingFlag = true;
    });
    var res = await Dio().get(
      "https://api.jikan.moe/v3/search/anime?q=$randomStaff&page=$animePage",
    );

    for (var tmp in res.data['results']) {
      AnimeDetailsModel t = new AnimeDetailsModel();
      t.setFromMap(tmp);
      randomAnimestaff.add(t);
    }
    setState(() {
      searchingFlag = false;
    });
  }

  @override
  void initState() {
    int c = Random().nextInt(randomAnimesForSearch.length);
    fetch(randomAnimesForSearch[c]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

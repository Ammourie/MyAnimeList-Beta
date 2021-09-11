import 'dart:convert';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:dio/dio.dart';
import 'package:malbeta/API/api.dart';
import 'package:malbeta/Pages/Anime/seasonalPage.dart';
import 'package:malbeta/Pages/Anime/top.dart';

import '../../Widgets/Manga%20widgets/manga_card.dart';
import '../../models/Manga/MangaDetailsModel.dart';
import '../Anime/animes.dart';
import '../favourated.dart';
import '../genres_page.dart';
import 'top.dart';

class Mangas extends StatefulWidget {
  @override
  _MangasState createState() => _MangasState();
}

class _MangasState extends State<Mangas> {
  List<MangaDetailsModel> randomMangastaff = [];
  List<String> randomMangasForSearch = [
    "Shingeki no Kyojin",
    "Berserk",
    "One Piece",
    "Tokyo Ghoul",
    "Naruto",
    "One Punch-Man",
    "Boku no Hero Academia",
    "Death Note",
    "Bleach",
    "Horimiya",
    "Kimetsu no Yaiba",
    "Solo Leveling",
    "Nisekoi",
    "Vinland Saga",
    "Monogatari Series",
    "Re:Zero kara Hajimeru Isekai Seikatsu"
  ];
  int mangaPage = 1;
  bool searchingFlag = true;
  SearchBar searchBar;
  bool randommangaFlag = true;
  String searchText;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(
        'Mangas',
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
        randommangaFlag = false;
        searchText = value;
        mangaPage = 1;
      });

      randomMangastaff =
          await API().searchForMangas(value: value, mangaPage: mangaPage);
      setState(() {
        searchingFlag = false;
      });
    }
  }

  void loadMore() async {
    setState(() {
      searchingFlag = true;
    });
    randomMangastaff =
        await API().loadMoreMangas(randomMangastaff, searchText, mangaPage);
    setState(() {
      searchingFlag = false;
    });
  }

  _MangasState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: (String value) => onSubmitted(value, context),
        hintText: "Manga Search ... ",
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
    randomMangastaff =
        await API().fetchAllMangas(randomStaff, mangaPage, context);
    setState(() {
      searchingFlag = false;
    });
  }

  @override
  void initState() {
    super.initState();
    int c = Random().nextInt(randomMangasForSearch.length);
    fetch(randomMangasForSearch[c]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      backgroundColor: Colors.white,
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: searchingFlag
          ? Center(
              child: CircularProgressIndicator(),
            )
          : randomMangastaff == null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Network Error",
                      style:
                          TextStyle(fontSize: 25, color: Colors.grey.shade800),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Mangas(),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Retry",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Icon(Icons.refresh,
                                size: 25, color: Colors.grey.shade700)
                          ],
                        ))
                  ],
                ))
              : randomMangastaff.length == 0
                  ? Center(
                      child: Text(
                        "No Mangas Found !!",
                        style: TextStyle(fontFamily: "Gibson", fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: randomMangastaff.length,
                      itemBuilder: (context, index) {
                        return MangaCard(
                          manga: randomMangastaff[index],
                        );
                      },
                    ),
      // ),
    );
  }

  Container buildDrawer(BuildContext context) {
    return Container(
      width: 3 * MediaQuery.of(context).size.width / 4,
      child: Drawer(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Theme.of(context).canvasColor,
            title: Text(
              "malb Beta",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Gibson",
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(children: [
                      Text(
                        "MAL",
                        style: TextStyle(
                          fontSize: 60,
                          fontFamily: "Mal",
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        "Beta",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: "Mal",
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ]),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  buildAnimeListTile(context),
                  buildMangaListTile(context),
                  buildGenresTile(context),
                  Divider(
                    thickness: 0.25,
                  ),
                  buildFavouratedTile(context),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                    padding: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    width: 3 * MediaQuery.of(context).size.width / 4,
                    child: Center(
                        child: Text(
                      "Version:1.0",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGenresTile(BuildContext context) {
    return GFListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenresPage(),
            ));
      },
      avatar: Icon(
        Icons.art_track_outlined,
        size: MediaQuery.of(context).size.width / 10,
      ),
      title: Text(
        "Genres",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 20,
          color: Colors.black,
          fontFamily: "Gibson",
        ),
      ),
    );
  }

  GFListTile buildFavouratedTile(BuildContext context) {
    return GFListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavouratedStuff(),
            ));
      },
      avatar: Icon(
        Icons.favorite_border_rounded,
        size: MediaQuery.of(context).size.width / 10,
      ),
      title: Text(
        "Favourites",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 20,
          color: Colors.black,
          fontFamily: "Gibson",
        ),
      ),
    );
  }

  Widget buildMangaListTile(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 0.25))),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
            iconColor: Colors.black,
            iconSize: 30,
            headerAlignment: ExpandablePanelHeaderAlignment.center),
        collapsed: null,
        header: GFListTile(
          enabled: false,
          avatar: Image(
            image: AssetImage("assets/images/manga.png"),
            height: MediaQuery.of(context).size.width / 8,
          ),
          title: Text(
            "Manga",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 18,
              color: Colors.black,
              fontFamily: "Gibson",
            ),
          ),
        ),
        expanded: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GFListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mangas(),
                      ));
                },
                avatar: Icon(
                  Icons.arrow_forward,
                  color: Colors.black54,
                ),
                title: Text(
                  "Random",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 23,
                    color: Colors.black54,
                    fontFamily: "Gibson",
                  ),
                ),
              ),
              GFListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopMangas(),
                      ));
                },
                avatar: Icon(
                  Icons.arrow_forward,
                  color: Colors.black54,
                ),
                title: Text(
                  "Top",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 23,
                    color: Colors.black54,
                    fontFamily: "Gibson",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnimeListTile(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 0.25))),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
            iconColor: Colors.black,
            iconSize: 30,
            headerAlignment: ExpandablePanelHeaderAlignment.center),
        collapsed: null,
        header: GFListTile(
          enabled: false,
          avatar: Image(
            image: AssetImage("assets/images/anime.png"),
            height: MediaQuery.of(context).size.width / 8,
          ),
          title: Text(
            "Anime",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 18,
              color: Colors.black,
              fontFamily: "Gibson",
            ),
          ),
        ),
        expanded: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GFListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Animes(),
                      ));
                },
                avatar: Icon(
                  Icons.arrow_forward,
                  color: Colors.black54,
                ),
                title: Text(
                  "Random",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 23,
                    color: Colors.black54,
                    fontFamily: "Gibson",
                  ),
                ),
              ),
              GFListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopAnimes(),
                      ));
                },
                avatar: Icon(
                  Icons.arrow_forward,
                  color: Colors.black54,
                ),
                title: Text(
                  "Top",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 23,
                    color: Colors.black54,
                    fontFamily: "Gibson",
                  ),
                ),
              ),
              GFListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeasonalAnimesPage(),
                    )),
                avatar: Icon(
                  Icons.arrow_forward,
                  color: Colors.black54,
                ),
                title: Text(
                  "Seasonal",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 23,
                    color: Colors.black54,
                    fontFamily: "Gibson",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

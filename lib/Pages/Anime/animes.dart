import 'dart:math';
import 'package:malbeta/Pages/Anime/seasonalPage.dart';
import 'package:malbeta/Pages/Manga/top.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:malbeta/Pages/Manga/mangas.dart';

import '../../API/api.dart';
import '../../Widgets/Anime/anime_card.dart';
import '../../models/Anime/AnimeDetailsModel.dart';
import '../favourated.dart';
import '../genres_page.dart';
import 'top.dart';

class Animes extends StatefulWidget {
  @override
  _AnimesState createState() => _AnimesState();
}

class _AnimesState extends State<Animes> {
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
      randomAnimestaff =
          await API().searchForAnimes(value: value, animePage: animePage);
      setState(() {
        searchingFlag = false;
      });
    }
  }

  void loadMore() async {
    setState(() {
      searchingFlag = true;
    });
    randomAnimestaff =
        await API().loadMoreAnimes(randomAnimestaff, searchText, animePage);
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

  void fetch() async {
    setState(() {
      setState(() {
        searchingFlag = true;
      });
    });
    int c = Random().nextInt(randomAnimesForSearch.length);

    randomAnimestaff = await API()
        .fetchAllAnimes(randomAnimesForSearch[c], animePage, context);
    setState(() {
      searchingFlag = false;
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
      drawer: buildDrawer(context),
      backgroundColor: Colors.white,
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: searchingFlag
          ? Center(
              child: CircularProgressIndicator(),
            )
          : randomAnimestaff == null
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
                              builder: (context) => Animes(),
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
              :
              // NotificationListener<ScrollNotification>(
              //     // ignore: missing_return
              //     onNotification: (ScrollNotification scrollInfo) {
              //       if (scrollInfo.metrics.pixels ==
              //           scrollInfo.metrics.maxScrollExtent) {
              //         setState(() {
              //           animePage++;
              //         });
              //         if (randomAnimeFlag) {
              //           API().fetchAllAnimes(
              //               randomAnimesForSearch[Random()
              //                   .nextInt(randomAnimesForSearch.length)],
              //               animePage,
              //               context);
              //         } else {
              //           print("asda");
              //           loadMore();
              //         }
              //       }
              //     },
              randomAnimestaff.length == 0
                  ? Center(
                      child: Text(
                        "No Animes Found !!",
                        style: TextStyle(fontFamily: "Gibson", fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: randomAnimestaff.length,
                      itemBuilder: (context, index) {
                        return AnimeCard(
                          anime: randomAnimestaff[index],
                        );
                      },
                    ),
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
                primary: false,
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

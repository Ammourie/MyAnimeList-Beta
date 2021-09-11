import 'package:flutter/material.dart';
import 'package:malbeta/Pages/Anime/favourated_animes.dart';
import 'package:malbeta/Pages/Manga/favourated_mangas.dart';

class FavouratedStuff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: new Text(
            'Favourated',
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 18,
                color: Colors.black),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).accentColor,
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  'Anime',
                  style: TextStyle(
                      fontFamily: "Gibson",
                      fontSize: MediaQuery.of(context).size.width / 20,
                      color: Colors.black),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  'Manga',
                  style: TextStyle(
                      fontFamily: "Gibson",
                      fontSize: MediaQuery.of(context).size.width / 20,
                      color: Colors.black),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: TabBarView(
          children: [
            FavouratedAnimes(),
            FavouratedMangas(),
          ],
        ),
      ),
    );
  }
}

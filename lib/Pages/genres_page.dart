import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:malbeta/Widgets/Anime/genre_card.dart';
import 'package:malbeta/Widgets/Manga%20widgets/genre_card.dart';
import 'package:malbeta/genres.dart';

class GenresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var si = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        primary: false,
        children: [
          Text(
            "Anime",
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 17),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 40,
          ),
          CarouselSlider.builder(
            options: CarouselOptions(
                height: si.height / 1.8,
                enableInfiniteScroll: false,
                enlargeCenterPage: true),
            itemBuilder: (BuildContext context, int index, _) {
              return AnimeGenreCard(
                index: index + 1,
              );
            },
            itemCount: animeGenres.length,
          ),
          Text(
            "Manga",
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 17),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 40,
          ),
          CarouselSlider.builder(
            options: CarouselOptions(
                height: si.height / 1.8,
                enableInfiniteScroll: false,
                enlargeCenterPage: true),
            itemBuilder: (BuildContext context, int index, _) {
              return MangaGenereCard(
                index: index + 1,
              );
            },
            itemCount: mangaGenres.length,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      title: new Text(
        'Genres',
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

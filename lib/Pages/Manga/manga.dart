import 'dart:convert';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../Widgets/Manga%20widgets/character_getter.dart';
import '../../models/Anime/AnimeDetailsModel.dart';
import '../../models/Anime/AnimeSubModel/AnimeInfo.dart';
import '../../models/Manga/MangaDetailsModel.dart';
import '../../models/Manga/MangaSubModel/MangaInfo.dart';
import '../../models/Manga/genre_manga.dart';
import '../../notifires/all_provider.dart';
import '../Anime/anime.dart';
import 'manga_genres_page.dart';

class MangaDetailsPage extends StatelessWidget {
  final MangaDetailsModel manga;
  const MangaDetailsPage({Key key, this.manga}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          buildTopRow(context),
          Expanded(
              child: ListView(
            children: [
              buildImageRow(context),
              buildTitleRow(context),
              buildStatusRow(context),
              buildRatingColumn(context),
              buildDetailsColumn(context),
              buildSynopsisContainer(context),
              buildRecommendationsContainer(context),
              buildCharactersContainer(context),
              buildGenersContainer(context),
              // buildThemesContainer(context),
              // buildStudiosContainer(context),
              buildAdaptationTile(context),
            ],
          )),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Container buildRecommendationsContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
      ),
      child: ExpandablePanel(
        collapsed: null,
        header: Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Recommendations",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 16,
              color: Colors.black,
            ),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
        expanded: manga.recommendations.imageUrl.length == 0
            ? Center(
                child: Text(
                  "No Recommendations!!",
                  style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 25,
                    color: Colors.black,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: manga.recommendations.imageUrl.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          var res = await Dio().get(
                            "https://api.jikan.moe/v3/manga/${manga.recommendations.malId[index]}",
                          );
                          var recommendationsRes = await Dio().get(
                            "https://api.jikan.moe/v3/manga/${manga.recommendations.malId[index]}/recommendations",
                          );
                          List<Map> recommendationsParsed = new List<Map>.from(
                              recommendationsRes.data["recommendations"]);
                          MangaInfo rec = new MangaInfo(recommendationsParsed);

                          MangaDetailsModel x =
                              new MangaDetailsModel(recommendations: rec);
                          x.setFromMap(res.data);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MangaDetailsPage(
                                manga: x,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Image.network(
                              manga.recommendations.imageUrl[index],
                              fit: BoxFit.cover,
                              width: 150,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 150,
                                  margin: EdgeInsets.all(0),
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    firstXChar(
                                        manga.recommendations.title[index], 15),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Gibson"),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Container buildCharactersContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
      ),
      child: ExpandablePanel(
          collapsed: null,
          header: Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Characters ",
              style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 16,
                color: Colors.black,
              ),
              softWrap: true,
              textAlign: TextAlign.left,
            ),
          ),
          expanded: Container(
            height: 200,
            child: MangaCharachterGetter(
              malId: manga.malId.toString(),
            ),
          )),
    );
  }

  Container buildSynopsisContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
      ),
      child: ExpandablePanel(
        collapsed: null,
        header: Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Synopsis",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 16,
              color: Colors.black,
            ),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
        expanded: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            manga.synopsis == null ? "No Information" : manga.synopsis,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 25,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Container buildGenersContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
      ),
      child: ExpandablePanel(
        collapsed: null,
        header: Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Generes",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 16,
              color: Colors.black,
            ),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
        expanded: manga.genres.malId.length == 0
            ? Center(
                child: Text(
                  "No Geners!!",
                  style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 22,
                    color: Colors.black,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 47,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: manga.genres.name.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          GenreMangaModel tmp;

                          var res = await Dio().get(
                            "https://api.jikan.moe/v3/genre/manga/${manga.genres.malId[index]}",
                          );

                          tmp = GenreMangaModel(res.data);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaGenresPage(
                                  genre: tmp,
                                ),
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            manga.genres.name[index],
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Gibson"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Container buildDetailsColumn(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Rank: #${manga.rank == -1 ? "N/A" : manga.rank.toString()}",
                style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Theme.of(context).primaryColor),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              Text(
                "Type: ${manga.type == null || manga.type == "Unknown" ? "N/A" : manga.type.toString()}",
                style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Colors.black),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            width: 2,
            height: MediaQuery.of(context).size.width / 6,
            color: Colors.grey,
          ),
          Column(
            children: [
              Text(
                manga.chapters == -1
                    ? "Chapters: N/A"
                    : manga.chapters == 1
                        ? "Chapter:${manga.chapters.toString()}"
                        : "Chapters:${manga.chapters.toString()}",
                style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Colors.black),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 20,
              ),
              Text(
                manga.volumes == -1
                    ? "Volumes: N/A"
                    : manga.volumes == 1
                        ? "Volume:${manga.volumes.toString()}"
                        : "Volumes:${manga.volumes.toString()}",
                style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Colors.black),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }

  Column buildRatingColumn(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmoothStarRating(
              size: MediaQuery.of(context).size.width / 15,
              color: Colors.yellow,
              borderColor: Colors.yellow,
              rating: manga.score / 2,
              isReadOnly: true,
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              manga.score == 0 || manga.score == -1
                  ? "N/A"
                  : manga.score.toString(),
              style: TextStyle(
                  fontFamily: "Gibson",
                  fontSize: MediaQuery.of(context).size.width / 20,
                  color: Colors.black),
              softWrap: true,
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    );
  }

  Row buildStatusRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 0.0, bottom: 10),
          child: Text(
            manga.status.toString(),
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 22,
                color: Colors.black54),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Row buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.only(top: 12.0, bottom: 10),
          child: Text(
            manga.title,
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 17),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Row buildImageRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1.5 * MediaQuery.of(context).size.width / 2.25,
          width: MediaQuery.of(context).size.width / 2.25,
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            image: DecorationImage(
              image: NetworkImage(
                manga.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Container buildAdaptationTile(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
      ),
      child: ExpandablePanel(
        header: Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Adaptation",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 16,
              color: Colors.black,
            ),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
        expanded: Column(
          children: [
            manga.adaptation == null
                ? Center(
                    child: Text(
                      "No Adaptation Found!",
                      style: TextStyle(
                        fontFamily: "Gibson",
                        fontSize: MediaQuery.of(context).size.width / 22,
                        color: Colors.black,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: manga.adaptation.name.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          var res = await Dio().get(
                            "https://api.jikan.moe/v3/anime/${manga.adaptation.malId[index]}",
                          );
                          var recommendationsRes = await Dio().get(
                            "https://api.jikan.moe/v3/anime/${manga.adaptation.malId[index]}/recommendations",
                          );
                          List<Map> recommendationsParsed = new List<Map>.from(
                              recommendationsRes.data["recommendations"]);
                          AnimeInfo rec = new AnimeInfo(recommendationsParsed);

                          AnimeDetailsModel x =
                              new AnimeDetailsModel(recommendations: rec);
                          x.setFromMap(res.data);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeDetailsPage(
                                anime: x,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          manga.adaptation.name[index],
                          style: TextStyle(
                            fontFamily: "Gibson",
                            fontSize: MediaQuery.of(context).size.width / 22,
                            color: Theme.of(context).primaryColor,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      );
                    },
                  ),
          ],
        ),
        collapsed: null,
      ),
    );
  }

  Row buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10.0),
            child: IconButton(
              icon: Consumer<AllProvider>(
                builder: (context, value, _) {
                  print(value.checkForManga(manga.title));

                  return Icon(
                      context.read<AllProvider>().checkForManga(manga.title)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 40,
                      color: Colors.red);
                },
              ),
              onPressed: () {
                !context.read<AllProvider>().checkForManga(manga.title)
                    ? context.read<AllProvider>().addManga(manga, manga.title)
                    : context.read<AllProvider>().removeManga(manga.title);
                context.read<AllProvider>().printMangas();
                //  notifire.addAnime(anime);
              },
            )),
      ],
    );
  }
}

String firstXChar(String text, int charsCount) {
  String res = "";
  for (int i = 0; i < min(charsCount, text.length); i++) res = res + text[i];
  res.length == text.length ? res = res : res = res + "...";
  return res;
}

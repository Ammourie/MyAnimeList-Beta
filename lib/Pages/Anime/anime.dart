import 'dart:math';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:malbeta/API/api.dart';
import 'package:malbeta/Widgets/Anime/character_getter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../models/Anime/AnimeDetailsModel.dart';
import '../../models/Anime/AnimeSubModel/AnimeInfo.dart';
import '../../models/Anime/genre_anime.dart';
import '../../models/Manga/MangaDetailsModel.dart';
import '../../models/Manga/MangaSubModel/MangaInfo.dart';
import '../../notifires/all_provider.dart';
import 'anime_genres_page.dart';

class AnimeDetailsPage extends StatelessWidget {
  final AnimeDetailsModel anime;
  const AnimeDetailsPage({Key key, this.anime}) : super(key: key);
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
              buildDetailsRow(context),
              buildSynopsisContainer(context),
              buildRecommendationsContainer(context),
              buildCharactersContainer(context),
              buildGenersContainer(context),
              buildThemesContainer(context),
              buildStudiosContainer(context),
              buildRelatedContainer(context),
            ],
          )),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Container buildRelatedContainer(BuildContext context) {
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
            "Related",
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
            ListTile(
              title: Text(
                "Sequal:",
                style: TextStyle(
                  fontFamily: "Gibson",
                  fontSize: MediaQuery.of(context).size.width / 18,
                  color: Colors.black,
                ),
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            anime.sequals == null
                ? Center(
                    child: Text(
                      "No Sequal Found!",
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
                    itemCount: anime.sequals.name.length,
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
                            "https://api.jikan.moe/v3/anime/${anime.sequals.malId[index]}",
                          );
                          var recommendationsRes = await Dio().get(
                            "https://api.jikan.moe/v3/anime/${anime.sequals.malId[index]}/recommendations",
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
                          anime.sequals.name[index],
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
            ListTile(
              title: Text(
                "Prequal:",
                style: TextStyle(
                  fontFamily: "Gibson",
                  fontSize: MediaQuery.of(context).size.width / 18,
                  color: Colors.black,
                ),
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            anime.prequals == null
                ? Center(
                    child: Text(
                      "No Prequal Found!",
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
                    itemCount: anime.prequals.name.length,
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
                            "https://api.jikan.moe/v3/anime/${anime.prequals.malId[index]}",
                          );
                          var recommendationsRes = await Dio().get(
                            "https://api.jikan.moe/v3/anime/${anime.prequals.malId[index]}/recommendations",
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
                          anime.prequals.name[index],
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
            ListTile(
              title: Text(
                "Adaptation:",
                style: TextStyle(
                  fontFamily: "Gibson",
                  fontSize: MediaQuery.of(context).size.width / 18,
                  color: Colors.black,
                ),
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            anime.adaptation == null
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
                    itemCount: anime.adaptation.name.length,
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
                            "https://api.jikan.moe/v3/manga/${anime.adaptation.malId[index]}",
                          );
                          var recommendationsRes = await Dio().get(
                            "https://api.jikan.moe/v3/manga/${anime.adaptation.malId[index]}/recommendations",
                          );
                          List<Map> recommendationsParsed = new List<Map>.from(
                              recommendationsRes.data["recommendations"]);
                          MangaInfo rec = new MangaInfo(recommendationsParsed);

                          MangaDetailsModel x =
                              new MangaDetailsModel(recommendations: rec);
                          x.setFromMap(res.data);
                          Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MangaDetailsPage(
                          //       manga: x,
                          //     ),
                          //   ),
                          // );
                        },
                        title: Text(
                          anime.adaptation.name[index],
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

  Container buildThemesContainer(BuildContext context) {
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
            "Theme Songs",
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
            ListTile(
              title: Text(
                "Openings",
                style: TextStyle(
                  fontFamily: "Gibson",
                  fontSize: MediaQuery.of(context).size.width / 18,
                  color: Colors.black,
                ),
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            anime.openningThemes.length == 0
                ? Center(
                    child: Text(
                      "No Openings Found!",
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
                    itemCount: anime.openningThemes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          anime.openningThemes[index],
                          style: TextStyle(
                            fontFamily: "Gibson",
                            fontSize: MediaQuery.of(context).size.width / 22,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      );
                    },
                  ),
            ListTile(
              title: Text(
                "Endings",
                style: TextStyle(
                  fontFamily: "Gibson",
                  fontSize: MediaQuery.of(context).size.width / 18,
                  color: Colors.black,
                ),
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            anime.endingThemes.length == 0
                ? Center(
                    child: Text(
                      "No Endings Found!",
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
                    itemCount: anime.endingThemes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                        anime.endingThemes[index],
                        style: TextStyle(
                          fontFamily: "Gibson",
                          fontSize: MediaQuery.of(context).size.width / 22,
                          color: Colors.black87,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ));
                    },
                  ),
          ],
        ),
        collapsed: null,
      ),
    );
  }

  Container buildStudiosContainer(BuildContext context) {
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
            "Studios",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 16,
              color: Colors.black,
            ),
            softWrap: true,
            textAlign: TextAlign.left,
          ),
        ),
        expanded: anime.studios.length == 0
            ? Center(
                child: Text(
                  "No Studios Found!",
                  style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 22,
                    color: Colors.black,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.left,
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: anime.studios.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        anime.studios[index],
                        style: TextStyle(
                          fontFamily: "Gibson",
                          fontSize: MediaQuery.of(context).size.width / 22,
                          color: Colors.black,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                },
              ),
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
        expanded: anime.recommendations.imageUrl.length == 0
            ? Center(
                child: Text(
                  "No Recommendations!!",
                  style: TextStyle(
                    fontFamily: "Gibson",
                    fontSize: MediaQuery.of(context).size.width / 22,
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
                  itemCount: anime.recommendations.imageUrl.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          await API().fetchAnime(
                              id: anime.recommendations.malId[index],
                              context: context);
                        },
                        child: Stack(
                          children: [
                            Image.network(
                              anime.recommendations.imageUrl[index],
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
                                        anime.recommendations.title[index], 15),
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
            child: AnimeCharacterGetter(
              malId: anime.malId.toString(),
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
            anime.synopsis == null ? "No Information" : anime.synopsis,
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
        expanded: anime.genres.malId.length == 0
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
                    itemCount: anime.genres.name.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          GenreAnimeModel tmp;

                          var res = await Dio().get(
                            "https://api.jikan.moe/v3/genre/anime/${anime.genres.malId[index]}",
                          );

                          tmp = GenreAnimeModel(res.data);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeGenrePage(
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
                            anime.genres.name[index],
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

  Container buildDetailsRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Rank: #${anime.rank == -1 ? "N/A" : anime.rank.toString()}",
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Theme.of(context).primaryColor),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Container(
            width: 2,
            height: MediaQuery.of(context).size.width / 12,
            color: Colors.grey,
          ),
          Text(
            "Type: ${anime.type == null || anime.type == "Unknown" ? "N/A" : anime.type.toString()}",
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.black),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Container(
            width: 2,
            height: MediaQuery.of(context).size.width / 12,
            color: Colors.grey,
          ),
          Text(
            anime.episodes == -1
                ? "Episodes: N/A"
                : anime.episodes == 1
                    ? "Episode:${anime.episodes.toString()}"
                    : "Episodes:${anime.episodes.toString()}",
            style: TextStyle(
                fontFamily: "Gibson",
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.black),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
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
              rating: anime.score / 2,
              isReadOnly: true,
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              anime.score == 0 || anime.score == -1
                  ? "N/A"
                  : anime.score.toString(),
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
            anime.status == "Not yet aired"
                ? anime.from_to.toString()
                : anime.status.toString(),
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
            anime.title,
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
                anime.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Container buildTopRow(BuildContext context) {
    return Container(
      child: Row(
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
                    value.printAnimes();
                    print(value.checkForAnime(anime.title));

                    return Icon(
                        context.read<AllProvider>().checkForAnime(anime.title)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        size: 40,
                        color: Colors.red);
                  },
                ),
                onPressed: () {
                  !context.read<AllProvider>().checkForAnime(anime.title)
                      ? context.read<AllProvider>().addAnime(anime, anime.title)
                      : context.read<AllProvider>().removeAnime(anime.title);
                  // context.read<AllProvider>().printAnimes();
                  //  notifire.addAnime(anime);
                },
              )),
        ],
      ),
    );
  }
}

String firstXChar(String text, int charsCount) {
  String res = "";
  for (int i = 0; i < min(charsCount, text.length); i++) res = res + text[i];
  res.length == text.length ? res = res : res = res + "...";
  return res;
}

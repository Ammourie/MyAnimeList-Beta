import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../Pages/Manga/manga.dart';
import '../../models/Manga/MangaDetailsModel.dart';
import '../../models/Manga/MangaSubModel/MangaInfo.dart';

class MangaCard extends StatelessWidget {
  final MangaDetailsModel manga;

  const MangaCard({Key key, this.manga}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
          print(manga.malId);
          var res = await Dio().get(
            "https://api.jikan.moe/v3/manga/${manga.malId}",
          );
          var recommendationsRes = await Dio().get(
            "https://api.jikan.moe/v3/manga/${manga.malId}/recommendations",
          );
          List<Map> recommendationsParsed =
              new List<Map>.from(recommendationsRes.data["recommendations"]);
          MangaInfo rec = new MangaInfo(recommendationsParsed);

          MangaDetailsModel x = new MangaDetailsModel(recommendations: rec);
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.3,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE9E7E7),
                            spreadRadius: 10,
                            blurRadius: 15,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ],
                        // border: Border.all(
                        //   width: 1,
                        //   color: Theme.of(context).primaryColor,
                        // ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.60,
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firstXChar(manga.title, 20),
                                    style: TextStyle(
                                      fontFamily: "Gibson",
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              19,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50),
                                  SmoothStarRating(
                                    isReadOnly: true,
                                    starCount: 5,
                                    rating: manga.score / 2,
                                    color: Colors.orange[800],
                                    borderColor: Colors.orange[800],
                                    size:
                                        MediaQuery.of(context).size.width / 15,
                                    spacing:
                                        MediaQuery.of(context).size.width / 50,
                                    defaultIconData: Icons.star_outline_rounded,
                                    filledIconData: Icons.star_rounded,
                                    halfFilledIconData: Icons.star_half_rounded,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50),
                                  buildStatusTypeRow(context),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50),
                                  buildReleaseDate(context),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50),
                                  buildChaptersVolumesRow(context)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2.80,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17.0),
                  child: FadeInImage(
                    image: NetworkImage(manga.imageUrl),
                    placeholder: AssetImage("assets/images/placeholder.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        )
        // child: Container(
        //   margin: EdgeInsets.all(10),
        //   child: Row(
        //     children: [
        //       buildHeroImage(context),
        //       Expanded(
        //         child: Container(
        //           width: double.infinity,
        //           height: 200,
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Center(
        //                 child: SizedBox(
        //                   width: 170,
        //                   child: Text(
        //                     anime.title.length < 30
        //                         ? firstXWord(anime.title, 3)
        //                         : firstXWord(anime.title, 5),
        //                     style: TextStyle(
        //                       fontFamily: "Gibson",
        //                       color: Theme.of(context).primaryColor,
        //                       fontSize: 17,
        //                     ),
        //                     textAlign: TextAlign.center,
        //                     softWrap: true,
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: MediaQuery.of(context).size.width - 150,
        //                 child: Divider(
        //                   thickness: 1,
        //                 ),
        //               ),
        //               Expanded(
        //                 child: Container(
        //                   margin: EdgeInsets.only(left: 6, bottom: 10),
        //                   width: double.infinity,
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       buildScoreRow(context),
        //                       buildStatusRow(context),
        //                       // buildFromToRow(context),
        //                       buildTypeAndEpisodesRow(context),
        //                     ],
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        );
  }

  Container buildReleaseDate(BuildContext context) {
    return Container(
      child: Text(
        "Release Date: ${manga.startDate == null ? "N/A" : manga.startDate.contains("T") ? manga.startDate.split("T")[0] : manga.startDate}",
        style: TextStyle(
          fontFamily: "Gibson",
          fontSize: MediaQuery.of(context).size.width / 23,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Row buildStatusTypeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Status: ${manga.publishing ? "publishing" : "Finished"}",
          style: TextStyle(
            fontFamily: "Gibson",
            fontSize: MediaQuery.of(context).size.width / 23,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 25,
        ),
        Text(
          "#${manga.type == null || manga.type == "Unknown" ? "N/A" : manga.type}",
          style: TextStyle(
            fontFamily: "Gibson",
            fontSize: MediaQuery.of(context).size.width / 23,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Container buildChaptersVolumesRow(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            "Chapters: ${manga.chapters == -1 || manga.chapters == 0 || manga.chapters == null ? "N/A" : manga.chapters}",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 23,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 25,
          ),
          Text(
            "Volumes: ${manga.volumes == -1 || manga.volumes == 0 ? "N/A" : manga.volumes}",
            style: TextStyle(
              fontFamily: "Gibson",
              fontSize: MediaQuery.of(context).size.width / 23,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Container buildImageImage(BuildContext context) {
    return Container(
      width: 120,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        image: DecorationImage(
            image: NetworkImage(manga.imageUrl), fit: BoxFit.cover),
      ),
    );
  }
}

String firstXWord(String text, int wordsCount) {
  var words = text.split(" ");
  return words.sublist(0, min(wordsCount, words.length)).join(" ") +
      (words.length > wordsCount ? "..." : "");
}

String firstXChar(String text, int charsCount) {
  String res = "";
  for (int i = 0; i < min(charsCount, text.length); i++) res = res + text[i];
  res.length == text.length ? res = res : res = res + "...";
  return res;
}

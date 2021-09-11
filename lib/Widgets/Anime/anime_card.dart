import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:malbeta/API/api.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../Pages/Anime/anime.dart';
import '../../models/Anime/AnimeDetailsModel.dart';
import '../../models/Anime/AnimeSubModel/AnimeInfo.dart';

class AnimeCard extends StatelessWidget {
  final AnimeDetailsModel anime;

  const AnimeCard({Key key, this.anime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await API().fetchAnime(id: anime.malId, context: context);
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
                                    firstXChar(anime.title, 20),
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
                                    rating: anime.score / 2,
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
                                  buildEpisodesRow(context)
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
                    image: NetworkImage(anime.imageUrl),
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
        "Release Date: ${anime.startDate == null ? "N/A" : anime.startDate.contains("T") ? anime.startDate.split("T")[0] : anime.startDate}",
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
          "Status: ${anime.airing ? "Airing" : "Finished"}",
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
          "Type: ${anime.type == null || anime.type == "Unknown" ? "N/A" : anime.type}",
          style: TextStyle(
            fontFamily: "Gibson",
            fontSize: MediaQuery.of(context).size.width / 22,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Container buildEpisodesRow(BuildContext context) {
    return Container(
      child: Text(
        "Episodes: ${anime.episodes == -1 || anime.episodes == 0 ? "N/A" : anime.episodes}",
        style: TextStyle(
          fontFamily: "Gibson",
          fontSize: MediaQuery.of(context).size.width / 23,
          color: Theme.of(context).primaryColor,
        ),
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
            image: NetworkImage(anime.imageUrl), fit: BoxFit.cover),
      ),
    );
  }
}

String firstXWord(String text, int wordsCount) {
  var words = text.split(" ");
  return words.sublist(0, min(wordsCount, words.length)).join(" ") +
      (words.length > wordsCount ? "..." : "");
}

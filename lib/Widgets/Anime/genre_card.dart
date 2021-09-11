import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../Pages/Anime/anime_genres_page.dart';
import '../../models/Anime/genre_anime.dart';
import 'package:sizer/sizer.dart';

class AnimeGenreCard extends StatefulWidget {
  final int index;

  const AnimeGenreCard({Key key, this.index}) : super(key: key);
  @override
  _AnimeGenreCardState createState() => _AnimeGenreCardState();
}

class _AnimeGenreCardState extends State<AnimeGenreCard>
    with AutomaticKeepAliveClientMixin {
  GenreAnimeModel genre;
  bool fetching = false;
  Future<void> fetch() async {
    setState(() {
      fetching = true;
    });
    var res;
    try {
      res = await Dio().get(
        "https://api.jikan.moe/v3/genre/anime/${widget.index}",
      );
    } on DioError catch (e) {
      if (e.response.statusCode == 429) {
        await Future.delayed(const Duration(seconds: 2), () {});

        res = await Dio().get(
          "https://api.jikan.moe/v3/genre/anime/${widget.index}",
        );
      }
    }

    GenreAnimeModel tmp = GenreAnimeModel(res.data);
    genre = tmp;
    setState(() {
      fetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    var si = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeGenrePage(
                genre: genre,
              ),
            ));
      },
      child: fetching
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                      width: 3 * si.width / 4,
                      height: si.height / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 4),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(genre.anime[1].imageUrl)))),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 40,
                  ),
                  Text(
                    firstXChar(genre.name, 20),
                    style: TextStyle(
                        fontFamily: "Gibson",
                        fontSize: MediaQuery.of(context).size.width / 17),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  )
                ],
              )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

String firstXChar(String text, int charsCount) {
  String res = "";
  for (int i = 0; i < min(charsCount, text.length); i++) res = res + text[i];
  res.length == text.length ? res = res : res = res + "...";
  return res;
}

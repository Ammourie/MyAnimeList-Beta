import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../Pages/Manga/manga_genres_page.dart';
import '../../models/Manga/genre_manga.dart';

class MangaGenereCard extends StatefulWidget {
  final int index;

  const MangaGenereCard({Key key, this.index}) : super(key: key);
  @override
  _MangaGenereCardState createState() => _MangaGenereCardState();
}

class _MangaGenereCardState extends State<MangaGenereCard>
    with AutomaticKeepAliveClientMixin {
  GenreMangaModel genre;
  bool fetching = false;
  Future<void> fetch() async {
    setState(() {
      fetching = true;
    });
    var res;
    try {
      res = await Dio().get(
        "https://api.jikan.moe/v3/genre/manga/${widget.index}",
      );
    } on DioError catch (e) {
      if (e.response.statusCode == 429) {
        await Future.delayed(const Duration(seconds: 2), () {});
        res = await Dio().get(
          "https://api.jikan.moe/v3/genre/manga/${widget.index}",
        );
      }
    }

    GenreMangaModel tmp = GenreMangaModel(res.data);
    genre = tmp;
    setState(() {
      fetching = false;
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var si = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaGenresPage(
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
                              image: NetworkImage(genre.manga[1].imageUrl)))),
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

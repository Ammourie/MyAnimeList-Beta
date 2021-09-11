import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../models/Manga/MangaSubModel/MangaInfo.dart';

class MangaCharachterGetter extends StatefulWidget {
  final String malId;

  const MangaCharachterGetter({Key key, this.malId}) : super(key: key);
  @override
  _MangaCharachterGetterState createState() => _MangaCharachterGetterState();
}

class _MangaCharachterGetterState extends State<MangaCharachterGetter> {
  MangaInfo mangaCharacter;
  bool fetchingFlag = true;

  void fetch() async {
    setState(() {
      fetchingFlag = true;
    });
    var res = await Dio()
        .get("https://api.jikan.moe/v3/manga/${widget.malId}/characters");
    var data = res.data['characters']
        .map<Map<String, dynamic>>((mp) => Map<String, dynamic>.of(mp))
        .toList();
    mangaCharacter = MangaInfo(data);
    setState(() {
      fetchingFlag = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: fetchingFlag
          ? Center(child: Text("coming soon..."))
          : mangaCharacter.name.length == 0
              ? Center(
                  child: Text("No Characters Found!!",
                      style: TextStyle(fontFamily: "Gibson", fontSize: 17),
                      textAlign: TextAlign.center))
              : ListView.builder(
                  itemCount: mangaCharacter.name.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      title: Text(
                        "${mangaCharacter.name[index]}",
                        style: TextStyle(fontFamily: "Gibson"),
                      ),
                      leading: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        width: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(mangaCharacter.imageUrl[index])),
                        ),
                      ),
                      trailing: Text(mangaCharacter.role[index]),
                    ),
                  ),
                ),
    );
  }
}

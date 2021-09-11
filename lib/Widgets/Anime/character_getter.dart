import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/Anime/AnimeCharacters.dart';

class AnimeCharacterGetter extends StatefulWidget {
  final String malId;

  const AnimeCharacterGetter({Key key, this.malId}) : super(key: key);
  @override
  _AnimeCharacterGetterState createState() => _AnimeCharacterGetterState();
}

class _AnimeCharacterGetterState extends State<AnimeCharacterGetter> {
  AnimeCharacters animeCharacters;
  bool fetchingFlag = true;

  void fetch() async {
    setState(() {
      fetchingFlag = true;
    });
    var res = await Dio()
        .get("https://api.jikan.moe/v3/anime/${widget.malId}/characters_staff");
    print("character getter result");
    animeCharacters = AnimeCharacters(res.data['characters']);
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
          : animeCharacters.name.length == 0
              ? Center(
                  child: Text("No Characters Found!!",
                      style: TextStyle(fontFamily: "Gibson", fontSize: 17),
                      textAlign: TextAlign.center))
              : ListView.builder(
                  itemCount: animeCharacters.name.length,
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
                        "${animeCharacters.name[index]}",
                        style: TextStyle(fontFamily: "Gibson"),
                      ),
                      subtitle: Text(
                        "${animeCharacters.voiceActorName[index]}",
                        style: TextStyle(fontFamily: "Gibson"),
                        textAlign: TextAlign.right,
                      ),
                      leading: Image(
                        image: NetworkImage(animeCharacters.imageUrl[index]),
                      ),
                      trailing: animeCharacters.voiceActorImageUrl[index] ==
                              "Unknown"
                          ? Icon(
                              Icons.not_interested_outlined,
                              size: 30,
                            )
                          : Image(
                              image: NetworkImage(
                                  animeCharacters.voiceActorImageUrl[index]),
                            ),
                    ),
                  ),
                ),
    );
  }
}

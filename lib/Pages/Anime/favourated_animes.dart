import 'package:flutter/material.dart';
import 'package:malbeta/Widgets/Anime/anime_card.dart';
import 'package:provider/provider.dart';

import '../../models/Anime/AnimeDetailsModel.dart';
import '../../notifires/all_provider.dart';

class FavouratedAnimes extends StatelessWidget {
  List<AnimeDetailsModel> animeFavouratedList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AllProvider>(
      builder: (BuildContext context, value, Widget _) {
        animeFavouratedList = value.animeFavouratedList;
        return Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: animeFavouratedList.length == 0
              ? Center(
                  child: Text(
                  "No Favourated Animes Yet !!",
                  style: TextStyle(
                      fontFamily: "Gibson", fontSize: 22, color: Colors.black),
                ))
              : ListView.builder(
                  itemCount: animeFavouratedList.length,
                  itemBuilder: (context, index) => AnimeCard(
                    anime: animeFavouratedList[index],
                  ),
                ),
        );
      },
    );
  }
}

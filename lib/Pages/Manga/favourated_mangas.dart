import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/Manga%20widgets/manga_card.dart';
import '../../models/Manga/MangaDetailsModel.dart';
import '../../notifires/all_provider.dart';

class FavouratedMangas extends StatelessWidget {
  List<MangaDetailsModel> mangaFavouratedList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AllProvider>(
      builder: (BuildContext context, value, Widget _) {
        mangaFavouratedList = value.mangaFavouratedList;
        return Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: mangaFavouratedList.length == 0
              ? Center(
                  child: Text(
                  "No Favourated Mangas Yet !!",
                  style: TextStyle(
                      fontFamily: "Gibson", fontSize: 22, color: Colors.black),
                ))
              : ListView.builder(
                  itemCount: mangaFavouratedList.length,
                  itemBuilder: (context, index) => MangaCard(
                    manga: mangaFavouratedList[index],
                  ),
                ),
        );
      },
    );
  }
}

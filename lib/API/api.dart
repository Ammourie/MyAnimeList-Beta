import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:malbeta/Pages/Anime/anime.dart';
import 'package:malbeta/main.dart';
import 'package:malbeta/models/Anime/AnimeDetailsModel.dart';
import 'package:malbeta/models/Anime/AnimeSubModel/AnimeInfo.dart';
import 'package:malbeta/models/Manga/MangaDetailsModel.dart';

class API {
  Future<void> fetchAnime({int id, BuildContext context}) async {
    try {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      var res = await Dio().get(
        "https://api.jikan.moe/v3/anime/${id}",
      );
      var recommendationsRes = await Dio().get(
        "https://api.jikan.moe/v3/anime/${id}/recommendations",
      );
      List<Map> recommendationsParsed =
          new List<Map>.from(recommendationsRes.data["recommendations"]);
      AnimeInfo rec = new AnimeInfo(recommendationsParsed);

      AnimeDetailsModel x = new AnimeDetailsModel(recommendations: rec);
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
    } on DioError catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
                color: Colors.red[800], fontSize: 22, fontFamily: "Gibson"),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "something is wrong try again",
            style: TextStyle(fontSize: 20, fontFamily: "Gibson"),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "ok",
                  style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 22,
                      fontFamily: "Gibson"),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      );
    }
  }

  Future<List<MangaDetailsModel>> searchForMangas(
      {String value, int mangaPage}) async {
    List<MangaDetailsModel> randomMangaStaff = [];
    try {
      var res = await Dio().get(
        "https://api.jikan.moe/v3/search/manga?q=${value.replaceAll(" ", "%20")}&page=$mangaPage",
      );
      for (var s in res.data['results']) {
        MangaDetailsModel tmp = new MangaDetailsModel();
        tmp.setFromMap(Map.from(s));
        randomMangaStaff.add(tmp);
      }
    } on DioError catch (e) {
      return null;
    }

    return randomMangaStaff;
  }

  Future<List<AnimeDetailsModel>> searchForAnimes(
      {String value, int animePage}) async {
    List<AnimeDetailsModel> randomAnimestaff = [];
    try {
      var res = await Dio().get(
        "https://api.jikan.moe/v3/search/anime?q=${value.replaceAll(" ", "%20")}&page=$animePage",
      );
      for (var s in res.data['results']) {
        AnimeDetailsModel tmp = new AnimeDetailsModel();
        tmp.setFromMap(Map.from(s));
        randomAnimestaff.add(tmp);
      }
    } on DioError catch (e) {
      return null;
    }

    return randomAnimestaff;
  }

  Future<List<AnimeDetailsModel>> fetchSeasonalAnimes(
      {String year, String season}) async {
    List<AnimeDetailsModel> l = [];
    try {
      var res;
      if (year != "later")
        res = await Dio().get(
          "https://api.jikan.moe/v3/season/$year/$season",
        );
      else
        res = await Dio().get(
          "https://api.jikan.moe/v3/season/$year",
        );
      for (var tmp in res.data['anime']) {
        AnimeDetailsModel t = new AnimeDetailsModel();
        t.setFromMap(tmp);
        l.add(t);
      }
    } catch (e) {
      showDialog(
        context: navigatorKey.currentContext,
        builder: (context) => AlertDialog(
          title: Text(
            "Warning",
            style: TextStyle(
                color: Colors.red[800], fontSize: 22, fontFamily: "Gibson"),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "something is wrong try again",
            style: TextStyle(fontSize: 20, fontFamily: "Gibson"),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "ok",
                  style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 22,
                      fontFamily: "Gibson"),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      );
    }
    return l;
  }

//  Future<void> fetchManga({int id, BuildContext context}) async {
//     try {
//       showDialog(
//         context: context,
//         builder: (context) => Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//       var res = await Dio().get(
//         "https://api.jikan.moe/v3/manga/$id",
//       );
//       var recommendationsRes = await Dio().get(
//         "https://api.jikan.moe/v3/manga/$id/recommendations",
//       );
//       List<Map> recommendationsParsed =
//           new List<Map>.from(recommendationsRes.data["recommendations"]);
//       AnimeInfo rec = new AnimeInfo(recommendationsParsed);

//       AnimeDetailsModel x = new AnimeDetailsModel(recommendations: rec);
//       x.setFromMap(res.data);
//       Navigator.pop(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AnimeDetailsPage(
//             anime: x,
//           ),
//         ),
//       );
//     } on DioError catch (e) {
//       Navigator.pop(context);
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(
//             "Warning",
//             style: TextStyle(
//                 color: Colors.red[800], fontSize: 22, fontFamily: "Gibson"),
//             textAlign: TextAlign.center,
//           ),
//           content: Text(
//             "something is wrong try again",
//             style: TextStyle(fontSize: 20, fontFamily: "Gibson"),
//             textAlign: TextAlign.center,
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   "ok",
//                   style: TextStyle(
//                       color: Colors.red[800],
//                       fontSize: 22,
//                       fontFamily: "Gibson"),
//                   textAlign: TextAlign.center,
//                 ))
//           ],
//         ),
//       );
//     }
//   }
  Future<List<AnimeDetailsModel>> fetchAllAnimes(
      String randomStaff, int animePage, BuildContext context) async {
    List<AnimeDetailsModel> randomAnimestaff = [];
    try {
      var res = await Dio().get(
        "https://api.jikan.moe/v3/search/anime?q=$randomStaff&page=$animePage",
      );

      for (var tmp in res.data['results']) {
        AnimeDetailsModel t = new AnimeDetailsModel();
        t.setFromMap(tmp);
        randomAnimestaff.add(t);
      }
    } on DioError catch (e) {
      return null;
    }
    return randomAnimestaff;
  }

  Future<List<MangaDetailsModel>> fetchAllMangas(
      String randomStaff, int mangaPage, BuildContext context) async {
    List<MangaDetailsModel> randomMangaStaff = [];
    try {
      var res = await Dio().get(
        "https://api.jikan.moe/v3/search/manga?q=$randomStaff&page=$mangaPage",
      );

      for (var tmp in res.data['results']) {
        MangaDetailsModel t = new MangaDetailsModel();
        t.setFromMap(tmp);
        randomMangaStaff.add(t);
      }
    } on DioError catch (e) {
      return null;
    }
    return randomMangaStaff;
  }

  Future<List<AnimeDetailsModel>> loadMoreAnimes(
      List<AnimeDetailsModel> randomAnimestaff,
      String searchText,
      int animePage) async {
    var res = await Dio().get(
      "https://api.jikan.moe/v3/search/anime?q=$searchText&page=$animePage",
    );
    for (var s in res.data['results']) {
      AnimeDetailsModel tmp = new AnimeDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomAnimestaff.add(tmp);
    }
    return randomAnimestaff;
  }

  Future<List<MangaDetailsModel>> loadMoreMangas(
      List<MangaDetailsModel> randomMangaStaff,
      String searchText,
      int mangaPage) async {
    var res = await Dio().get(
      "https://api.jikan.moe/v3/search/manga?q=$searchText&page=$mangaPage",
    );
    for (var s in res.data['results']) {
      MangaDetailsModel tmp = new MangaDetailsModel();
      tmp.setFromMap(Map.from(s));
      randomMangaStaff.add(tmp);
    }
    return randomMangaStaff;
  }
}

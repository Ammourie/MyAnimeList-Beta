import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/Anime/AnimeDetailsModel.dart';
import '../models/Manga/MangaDetailsModel.dart';

class AllProvider extends ChangeNotifier {
  List<AnimeDetailsModel> _animeFavouritesList = [];
  List<MangaDetailsModel> _mangaFavouritesList = [];
  Database db;

//init
  Future<void> init() async {
    db = await openDatabase(
      "saved.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE savedAnimes (mal_id INTEGER, title TEXT, score REAL ,status TEXT ,type TEXT , start_date TEXT , episodes INTEGER , image_url TEXT)');
        await db.execute(
            'CREATE TABLE savedMangas (mal_id INTEGER, title TEXT, score REAL ,status TEXT ,type TEXT , start_date TEXT , chapters INTEGER , volumes INTEGER , image_url TEXT)');
      },
    );
    List<Map> animeList = await db.rawQuery('SELECT * FROM savedAnimes');
    List<Map> mangaList = await db.rawQuery('SELECT * FROM savedMangas');
    animeList.forEach((element) {
      print(element);
      AnimeDetailsModel tmp = new AnimeDetailsModel();
      tmp.setFromMap(element);
      addAnime(tmp, tmp.title);
    });
    mangaList.forEach((element) {
      print(element);
      MangaDetailsModel tmp = new MangaDetailsModel();
      tmp.setFromMap(element);
      addManga(tmp, tmp.title);
    });
  }

  Future<void> addManga(MangaDetailsModel manga, String title) async {
    if (!checkForManga(title)) {
      _mangaFavouritesList.add(manga);
      await db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO savedMangas(mal_id , title , score  ,status  ,type  , start_date  , chapters  , volumes  , image_url ) VALUES(?,?,?,?,?,?,?,?,?)',
            [
              manga.malId,
              manga.title,
              manga.score,
              manga.status,
              manga.type,
              manga.startDate,
              manga.chapters,
              manga.volumes,
              manga.imageUrl
            ]);
        print('inserted1: $id1');
      });
    }

    notifyListeners();
  }

//add anime
  Future<void> addAnime(AnimeDetailsModel anime, String title) async {
    if (!checkForAnime(title)) {
      _animeFavouritesList.add(anime);
      await db.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO savedAnimes(mal_id , title , score , status , type , start_date  , episodes  , image_url) VALUES(?,?,?,?,?,?,?,?)',
            [
              anime.malId,
              anime.title,
              anime.score,
              anime.status,
              anime.type,
              anime.startDate,
              anime.episodes,
              anime.imageUrl
            ]);
        print('inserted1: $id1');
      });
    }

    notifyListeners();
  }

//get anime favourated list
  List<AnimeDetailsModel> get animeFavouratedList => _animeFavouritesList;
  List<MangaDetailsModel> get mangaFavouratedList => _mangaFavouritesList;
//remove anime
  Future<void> removeAnime(String title) async {
    _animeFavouritesList.removeWhere((element) => element.title == title);
    var count =
        await db.rawDelete('DELETE FROM savedAnimes WHERE title = ?', [title]);
    notifyListeners();
  }

  Future<void> removeManga(String title) async {
    _mangaFavouritesList.removeWhere((element) => element.title == title);
    var count =
        await db.rawDelete('DELETE FROM savedMangas WHERE title = ?', [title]);
    notifyListeners();
  }

//check if anime is saved
  bool checkForAnime(String title) =>
      _animeFavouritesList.any((element) => element.title == title);

  bool checkForManga(String title) =>
      _mangaFavouritesList.any((element) => element.title == title);

//print animes
  void printAnimes() {
    _animeFavouritesList.forEach((list) {
      print("test${Random().nextInt(20)}()\t" + list.title);
    });
  }

  void printMangas() {
    _mangaFavouritesList.forEach((list) {
      print("test${Random().nextInt(20)}()\t" + list.title);
    });
  }
}

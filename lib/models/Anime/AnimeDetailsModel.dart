import 'AnimeSubModel/AnimeInfo.dart';

class AnimeDetailsModel {
  int malId;
  String url;
  String imageUrl;
  String title;
  bool airing;
  String synopsis;
  String type;
  int episodes;
  double score;
  String startDate;
  String endDate;
  // ignore: non_constant_identifier_names
  String from_to;
  String status;
  int members;
  String rated;
  int rank;
  List<String> openningThemes = [];
  List<String> endingThemes = [];
  AnimeInfo genres;
  List<String> studios = [];
  AnimeInfo sequals;
  AnimeInfo adaptation;
  AnimeInfo prequals;

  final AnimeInfo recommendations;

  AnimeDetailsModel({this.recommendations});

  void setFromMap(Map results) {
    this.malId = results['mal_id'] ?? -1;
    this.url = results['url'] ?? "N/A";
    this.imageUrl = results['image_url'] ?? "N/A";
    this.title = results['title'] ?? "N/A";
    this.airing = results['airing'] ?? true;

    this.synopsis = results['synopsis'] ?? "N/A";
    this.status = results['status'] ?? "N/A";
    this.type = results['type'] ?? "N/A";
    this.episodes = results['episodes'] ?? -1;
    this.score = double.parse((results['score'] ?? -1).toString());
    this.rank = results['rank'] ?? -1;
    this.members = results['members'] ?? -1;
    this.rated = results['rated'] ?? "N/A";
    if (results['start_date'] != null) {
      this.startDate = results['start_date'];
    } else if (results['aired'] != null) {
      this.startDate = results['aired']["from"];
      this.from_to = results['aired']['string'];
    } else if (results['airing_start'] != null) {
      this.startDate = results['airing_start'].toString();
    }
    if (results['end_date'] != null) {
      this.endDate = results['end_date'];
    } else if (results['aired'] != null) {
      this.endDate = results['aired']["to"];
      this.from_to = results['aired']['string'];
    }
    if (results['genres'] != null) {
      this.genres = AnimeInfo(List<Map>.from(results['genres']));
    }
    if (results['related'] != null) {
      if (results['related']['Prequel'] != null) {
        this.prequals =
            AnimeInfo(List<Map>.from(results['related']['Prequel']));
      }
      if (results['related'] != null) {
        if (results['related']['Adaptation'] != null) {
          this.adaptation =
              AnimeInfo(List<Map>.from(results['related']['Adaptation']));
        }
      }
      if (results['related']['Sequel'] != null) {
        this.sequals = AnimeInfo(List<Map>.from(results['related']['Sequel']));
      }
    }
    if (results['opening_themes'] != null)
      for (var i in results['opening_themes']) {
        this.openningThemes.add(i);
      }
    if (results['ending_themes'] != null)
      for (var i in results['ending_themes']) {
        this.endingThemes.add(i);
      }
    if (results['studios'] != null)
      for (var i in results['studios']) {
        this.studios.add(i['name'].toString());
      }
  }
}

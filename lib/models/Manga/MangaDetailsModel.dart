import 'MangaSubModel/MangaInfo.dart';

class MangaDetailsModel {
  int malId;
  String url;
  String imageUrl;
  String title;
  bool publishing;
  String synopsis;
  String type;
  int chapters;
  int volumes;
  double score;
  String startDate;
  String endDate;
  String fromto;
  int rank;
  MangaInfo genres;
  MangaInfo authors;
  MangaInfo adaptation;

  String status;

  int members;
  String rated;

  final MangaInfo recommendations;

  MangaDetailsModel({this.recommendations});
  void setFromMap(Map results) {
    this.malId = results['mal_id'] ?? -1;
    this.rank = results['rank'] ?? -1;
    this.status = results['status'] ?? "N/A";
    this.url = results['url'] ?? "N/A";
    this.imageUrl = results['image_url'] ?? "N/A";
    this.title = results['title'] ?? "N/A";
    this.publishing = results['publishing'] ?? false;
    this.synopsis = results['synopsis'] ?? "N/A";
    this.type = results['type'] ?? "N/A";
    this.chapters = results['chapters'] ?? -1;
    this.volumes = results['volumes'] ?? -1;
    this.score = double.parse((results['score'] ?? -1).toString());
    this.members = results['members'] ?? -1;
    this.rated = results['rated'] ?? "N/A";
    if (results['start_date'] != null) {
      this.startDate = results['start_date'];
    } else if (results['published'] != null) {
      this.startDate = results['published']["from"];
      this.fromto = results['published']['string'];
    } else if (results['publishing_start'] != null) {
      this.startDate = results['publishing_start'].toString();
    }
    if (results['related'] != null) {
      if (results['related']['Adaptation'] != null) {
        this.adaptation =
            MangaInfo(List<Map>.from(results['related']['Adaptation']));
      }
    }
    if (results['end_date'] != null) {
      this.endDate = results['end_date'];
    } else if (results['published'] != null) {
      this.endDate = results['published']["to"];
      this.fromto = results['published']['string'];
    }
    if (results['genres'] != null) {
      this.genres = MangaInfo(List<Map>.from(results['genres']));
    }
  }
}

import 'AnimeDetailsModel.dart';

class GenreAnimeModel {
  int item_count;
  List<AnimeDetailsModel> anime = [];
  String name;
  GenreAnimeModel(Map res) {
    this.item_count = res['item_count'] ?? -1;
    this.name = res['mal_url']['name'] ?? "N/A";
    List tmp = res['anime'];
    if (tmp != null) {
      tmp.forEach((element) {
        // print(element['title']);
        AnimeDetailsModel tmp = AnimeDetailsModel();
        tmp.setFromMap(element);
        anime.add(tmp);
      });
    }
  }
}

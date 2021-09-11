import 'MangaDetailsModel.dart';

class GenreMangaModel {
  int item_count;
  List<MangaDetailsModel> manga = [];
  String name;
  GenreMangaModel(Map res) {
    this.item_count = res['item_count'] ?? -1;
    this.name = res['mal_url']['name'] ?? "N/A";
    List tmp = res['manga'];
    if (tmp != null) {
      tmp.forEach((element) {
        // print(element['title']);
        MangaDetailsModel tmp = MangaDetailsModel();
        tmp.setFromMap(element);
        manga.add(tmp);
      });
    }
  }
}

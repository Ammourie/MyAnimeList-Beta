class AnimeInfo {
  List<int> malId = [];
  List<String> url = [];
  List<String> imageUrl = [];
  List<String> name = [];
  List<String> title = [];
  final List<Map> info;

  AnimeInfo(this.info) {
    for (int i = 0; i < info.length; i++) {
      malId.add(info[i]['mal_id']);
      url.add(info[i]['url']);
      imageUrl.add(info[i]['image_url']);
      name.add(info[i]['name']);
      if (info[i]['title'] != null) title.add(info[i]['title']);
    }
  }
}

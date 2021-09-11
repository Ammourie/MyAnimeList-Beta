class MangaInfo {
  List<int> malId = [];
  List<String> url = [];
  List<String> imageUrl = [];
  List<String> name = [];
  List<String> title = [];
  List<String> role = [];
  final List<Map> info;
  MangaInfo(this.info) {
    for (int i = 0; i < info.length; i++) {
      malId.add(info[i]['mal_id']);
      url.add(info[i]['url']);
      imageUrl.add(info[i]['image_url']);
      name.add(info[i]['name']);
      if (info[i]['title'] != null) title.add(info[i]['title']);
      if (info[i]['role'] != null) role.add(info[i]['role']);
    }
  }
}

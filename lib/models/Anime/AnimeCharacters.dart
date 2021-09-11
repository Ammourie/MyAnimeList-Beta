class AnimeCharacters {
  List<int> malId = [];
  List<String> url = [];
  List<String> imageUrl = [];
  List<String> name = [];
  List<int> voiceActorsMalId = [];
  List<String> voiceActorUrl = [];
  List<String> voiceActorImageUrl = [];
  List<String> voiceActorName = [];

  final List characters;

  AnimeCharacters(this.characters) {
    for (var i in this.characters) {
      bool tmp = true;
      this.malId.add(i['mal_id']);
      this.url.add(i['url']);
      this.imageUrl.add(i['image_url']);
      this.name.add(i['name']);
      for (var j in i['voice_actors']) {
        if (j["language"] == "Japanese") {
          tmp = false;
          this.voiceActorsMalId.add(j['mal_id']);
          this.voiceActorUrl.add(j['url']);
          this.voiceActorImageUrl.add(j['image_url']);
          this.voiceActorName.add(j['name']);
          break;
        }
      }
      if (tmp) {
        this.voiceActorsMalId.add(-1);
        this.voiceActorUrl.add("Unknown");
        this.voiceActorImageUrl.add("Unknown");
        this.voiceActorName.add("Unknown");
      }
    }
  }
}



class Recipe {
  Recipe({this.title, this.saved, this.tags, this.images, this.url});

  String title;
  String url;
  bool saved = false;
  List<String> tags = [];
  List<String> images = [];
}


class Recipe {
  Recipe({
    this.title,
    this.slug,
    this.saved,
    this.tags,
    this.images,
    this.url,
    this.kcal,
    this.protein,
    this.carbs,
    this.fat,
    this.notes,
  }) : super() {
    this.title = this.title?.replaceAll('\n', '');
  }

  String title;
  String slug;
  String url;
  bool saved = false;
  List<String> tags = [];
  List<String> images = [];

  int kcal;
  int protein;
  int carbs;
  int fat;

  String notes;

}

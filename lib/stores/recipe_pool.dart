import 'package:flutter/foundation.dart';

class Recipe {
  Recipe({this.title});

  String title;
  bool saved;
}


class RecipePool extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  void addRecipe(String title){
    _recipes.add(Recipe(title: title));
    notifyListeners();
  }

}
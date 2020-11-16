import 'package:flutter/foundation.dart';

class RecipePool extends ChangeNotifier {
  List<String> _recipes = [];

  List<String> get recipes => _recipes;

  Iterator<String> iterator;

  RecipePool() : super() {
    iterator = recipeIterator().iterator;
  }

  Iterable<String> recipeIterator() sync* {
    var n = 0;
    while(true) {
      yield n.toString();
      n++;
    }
  }


  void addRecipe(String title){
    _recipes.add(title);
    notifyListeners();
  }

}
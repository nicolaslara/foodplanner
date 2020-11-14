import 'package:flutter/foundation.dart';

class RecipePool extends ChangeNotifier {
  List<String> _recipes = [];

  List<String> get recipes => _recipes;

  void addRecipe(String title){
    _recipes.add(title);
    notifyListeners();
  }

}
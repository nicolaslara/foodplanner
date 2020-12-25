import 'package:flutter/material.dart';
import 'package:foodplanner/stores/recipe_pool.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe _recipe;

  RecipeDetails(this._recipe);


  @override
  Widget build(BuildContext context) {
    print(_recipe.title);
    return Scaffold(
        appBar: AppBar(title: Text(_recipe.title)),

    );
  }

}
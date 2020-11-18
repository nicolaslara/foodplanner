import 'package:flutter/material.dart';
import 'package:foodplanner/stores/recipe_pool.dart';

class RecipeCard extends StatelessWidget {
  static const _biggerFont = TextStyle(fontSize: 18.0);

  final Recipe recipe;

  RecipeCard({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      constraints: BoxConstraints.expand(height: 200),
      child: Card(
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 1, child: FlutterLogo()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(recipe.title, style: _biggerFont),
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('235 kcal'), Text('P: 18g'), Text('C: 15g'), Text('F: 3g')]),
                          ],
                        ),
                      ]),
                ),
                Icon(
                    recipe.saved ?  Icons.star : Icons.star_border,
                    color: recipe.saved ? Colors.red : null
                ),
              ],
            ),
          )
      ),
    );
  }

}

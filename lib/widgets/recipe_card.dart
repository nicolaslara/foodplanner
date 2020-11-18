import 'package:flutter/material.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/constants.dart';
import 'package:provider/provider.dart';


class Tag extends StatelessWidget {
  final String title;

  Tag(this.title);

  @override
  Widget build(BuildContext context) {
    Filters filters = Provider.of<Filters>(context);
    return Padding(
        padding: EdgeInsets.only(right: 3),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {

            filters.setFilter('tags', {#arrayContains: title});
          },
          child: Chip(
            backgroundColor: filters.value('tags') == title  ? Colors.lightGreenAccent : null,
            label: Text(title, style: TextStyle(fontSize: smallFont),),
          ),
        )
    );
  }
}

class RecipeCard extends StatelessWidget {

  final Recipe recipe;

  RecipeCard({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      constraints: BoxConstraints.expand(height: 250),
      child: Card(
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 1, child: FlutterLogo()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(recipe.title, style: TextStyle(fontSize: bigFont)),
                              ),
                              Row(
                                children: [...recipe.tags.map((t)=>Tag(t)).toList()],
                              ),
                            ]),
                          Column(
                              children: [
                                Text('235 kcal', style: TextStyle(fontSize: smallFont),),
                                Text('P: 18g', style: TextStyle(fontSize: smallFont)),
                                Text('C: 15g', style: TextStyle(fontSize: smallFont)),
                                Text('F: 3g', style: TextStyle(fontSize: smallFont))
                              ]
                          ),
                        ],
                      ),
                    ]),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Icon(
                        recipe.saved ?  Icons.star : Icons.star_border,
                        color: recipe.saved ? Colors.red : null
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

}

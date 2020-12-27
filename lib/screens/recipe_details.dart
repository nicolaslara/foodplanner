
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/widgets/recipe_card.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
import '../main.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  RecipeDetails(this.recipe);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(recipe.title)),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: recipe.images.length > 0 ? recipe.images.reversed.map((image) => SizedBox(width: 410, child: FittedBox(child: Image.network(image), fit: BoxFit.cover))).toList() : [FlutterLogo()]
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(fontSize: bigFont),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(
                    height: 30,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [...recipe.tags.map((t)=>Tag(t, null)).toList()]),
                  ),

                  GestureDetector(
                    child: Text(recipe.url),
                    onTap: () => {
                      navigatorKey.currentState.push(
                          MaterialPageRoute(builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text(recipe.url),
                              ),
                              body: WebView(
                                initialUrl: recipe.url,
                                javascriptMode: JavascriptMode.unrestricted,
                              ))
                          ))
                    },
                  ),

                ],
              ),
            )
          ],
        )

    );
  }

}
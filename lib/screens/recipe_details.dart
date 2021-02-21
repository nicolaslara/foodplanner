
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/utils/helpers.dart';
import 'package:foodplanner/widgets/recipe_card.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
import '../main.dart';
import 'editor/edit_recipe.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  RecipeDetails(this.recipe);

  Widget fullScreenImage(image){
    return Scaffold(
      //appBar: AppBar(),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(8),
        minScale: 0.1,
        maxScale: 4,
        child: CachedNetworkImage(
            imageUrl: image,
            height: double.infinity,
            width: double.infinity,
            placeholder: (context, url) => CircularProgressIndicator()
        ),
      ),
    );
  }

  Widget images(context) {
    if (recipe.images.length > 0){
      return SizedBox(
        height: MediaQuery.of(context).size.width,
        child: PageView(
            scrollDirection: Axis.horizontal,
            children: recipe.images.reversed.map((image) {
              return SizedBox(width: 410,
                  child: GestureDetector(
                      child: FittedBox(
                          child: CachedNetworkImage(imageUrl: image), fit: BoxFit.cover),
                      onTap:() {
                        navigatorKey.currentState.push(
                          MaterialPageRoute(builder: (context) => fullScreenImage(image)),
                        );
                      }
                  )
              );
            }).toList()
        ),
      );
    } else {
      return SizedBox(
        height: 300,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: [FlutterLogo()]
        ),
      );
    }
  }

  Widget get nutritionalInfo {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            recipe.kcal != null ? Text('${recipe.kcal} kcal', style: TextStyle(fontSize: mediumFont),) : Container(),
            recipe.protein != null ? Text('P: ${recipe.protein}g', style: TextStyle(fontSize: smallFont)) : Container(),
            recipe.carbs != null ? Text('C: ${recipe.carbs}g', style: TextStyle(fontSize: smallFont)) : Container(),
            recipe.fat != null ? Text('F: ${recipe.fat}g', style: TextStyle(fontSize: smallFont)) : Container()
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever_sharp),
              color: Colors.red,
              onPressed: () async {
                await showDeleteDialog(context, recipe);
              },
            ),

            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                navigatorKey.currentState.push(
                  MaterialPageRoute(builder: (context) => EditRecipe(recipe)),
                );
              },
            ),

          ],

        ),
        body: Column(
          children: [
            images(context),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    recipe.title,
                    style: TextStyle(fontSize: bigFont),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    height: 30,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [...recipe.tags.map((t)=>Tag(title: t)).toList()]),
                  ),

                  SizedBox(height: 20),

                  recipe.url.isNotEmpty ? GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 30),
                      child: Text(
                        recipe.url == 'None' ? '' : recipe.url,
                        style: TextStyle(fontSize: mediumFont, color: Colors.lightBlue),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
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
                  ) : Container(),

                  nutritionalInfo,

                  recipe.notes != null ? Text(recipe.notes) : Container()
                ],
              ),
            )
          ],
        )

    );
  }

}
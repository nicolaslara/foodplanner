
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                navigatorKey.currentState.push(
                  MaterialPageRoute(builder: (context) => EditRecipe(recipe)),
                );
              },
            )
          ],

        ),
        body: Column(
          children: [
            images(context),

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
                        children: [...recipe.tags.map((t)=>Tag(title: t)).toList()]),
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
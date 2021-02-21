import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/screens/recipe_details.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/constants.dart';
import 'package:provider/provider.dart';

import '../main.dart';


class Tag extends StatelessWidget {
  final String title;
  final Filters filters;
  final Function onDelete;

  Tag({this.title, this.filters, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: Chip(
        backgroundColor: filters != null && filters.value('tags') == title  ? Colors.pink[500] : Colors.black54,
        deleteIcon: Icon( Icons.close, ),
        onDeleted: onDelete,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(title, style: TextStyle(fontSize: smallFont, color: Colors.white)),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {

  final Recipe recipe;

  RecipeCard({this.recipe});

  Widget get image{
    if (recipe.images.length > 0) {
      return FittedBox(
          fit: BoxFit.cover,
          child: CachedNetworkImage(imageUrl: recipe.images[recipe.images.length - 1])
      );
    } else {
      return FlutterLogo();
    }
  }

  Widget get title {
    return Text(
      recipe.title,
      style: TextStyle(fontSize: mediumFont),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get nutritionalInfo {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          recipe.kcal != null ? Text('${recipe.kcal} kcal', style: TextStyle(fontSize: smallFont),) : Container(),
          recipe.protein != null ? Text('P: ${recipe.protein}g', style: TextStyle(fontSize: smallFont)) : Container(),
          recipe.carbs != null ? Text('C: ${recipe.carbs}g', style: TextStyle(fontSize: smallFont)) : Container(),
          recipe.fat != null ? Text('F: ${recipe.fat}g', style: TextStyle(fontSize: smallFont)) : Container()
        ]
    );
  }

  Widget tags(context) {
    Filters filters = Provider.of<Filters>(context);
    return SizedBox(
      height: 30,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: [...recipe.tags.map((t)=>Tag(title: t, filters: filters)).toList()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState.push(
          MaterialPageRoute(builder: (context) => RecipeDetails(recipe)),
        );
      },
      child: Card(
        elevation: 3,

        child: Stack(
          children: [

            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: image),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    child: SizedBox(
                      height: 100,
                      child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: title,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      tags(context),
                                    ])
                                  ),
                                  nutritionalInfo,
                                ]
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ]
            ),

            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(
                      recipe.saved ?  Icons.star : Icons.star_border,
                      color: recipe.saved ? Colors.red : null
                  ),
                  onTap: () {
                    FirebaseFirestore.instance.runTransaction((transaction) async {
                      DocumentReference ref = FirebaseFirestore.instance.collection('recipes').doc(recipe.slug);
                      DocumentSnapshot snapshot = await transaction.get(ref);
                      transaction.update(ref, {
                        'saved': !snapshot['saved']
                      });
                    });
                  },
                ),
              ),
            ),

          ])

      ),
    );
  }

}

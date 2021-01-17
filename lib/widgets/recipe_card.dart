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
        backgroundColor: filters != null && filters.value('tags') == title  ? Colors.lightGreenAccent : null,
        deleteIcon: Icon( Icons.close, ),
        onDeleted: onDelete,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(title, style: TextStyle(fontSize: smallFont)),
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
          child: Image.network(recipe.images[recipe.images.length - 1])
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
          Text('235 kcal', style: TextStyle(fontSize: smallFont),),
          Text('P: 18g', style: TextStyle(fontSize: smallFont)),
          Text('C: 15g', style: TextStyle(fontSize: smallFont)),
          Text('F: 3g', style: TextStyle(fontSize: smallFont))
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
                            title,
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: tags(context),
                                      ),
                                    ])
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: nutritionalInfo,
                                  ),
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

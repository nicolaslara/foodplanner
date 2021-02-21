import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/widgets/filter_badge.dart';
import 'package:foodplanner/widgets/recipe_card.dart';
import 'package:provider/provider.dart';


class RecipeList extends StatelessWidget {
  RecipeList({Key key, this.title, this.selected=false}) : super(key: key);

  final String title;
  final bool selected;

  Widget _buildRow(document) {
    Map macros = document.data()["macros"];
    Recipe _recipe = Recipe(
        slug: document.reference.id,
        title: document["title"],
        saved: document["saved"] ?? false,
        images: document["images"].cast<String>(),
        url: document["url"],
        kcal: document.data()["kcal"],
        protein: macros != null ? macros['protein'] : null,
        carbs: macros != null ? macros['protein'] : null,
        fat: macros != null ? macros['protein'] : null,
        tags: document["tags"].cast<String>()
    );
    return RecipeCard(recipe: _recipe);
  }

  @override
  Widget build(context) {
    Filters filters = Provider.of<Filters>(context);
    Query query = FirebaseFirestore.instance.collection('recipes');
    if (this.selected){
      query = query.where('saved', isEqualTo: true);
    } else {
      filters.all.forEach((String key, Map<Symbol, dynamic> value) {
        query = Function.apply(query.where, [key], value);
      });
    }

    return Scaffold(
          appBar: AppBar(
              title: Text(this.title),
              actions: [ !this.selected ? FilterBadge() : Container() ]
          ),
          body: StreamBuilder(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              print(snapshot.data);
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => _buildRow(snapshot.data.docs[index])
              );
            },

          )
    );
  }
}

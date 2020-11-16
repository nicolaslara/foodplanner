import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class RecipeList extends StatefulWidget {
  RecipeList({Key key, this.title, this.filter=false}) : super(key: key);

  final String title;
  final bool filter;

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  bool _filter = false;

  Widget _recipeList() {
    if (this._filter) {
      return Text('Saved here');
      // final tiles = _saved.map((String word) => RecipeCard(
      // title: word, saved: true)).toList();
      //
      // return ListView(children: tiles, padding: EdgeInsets.all(20));
    }

    return ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (context, int index) {
          RecipePool pool = Provider.of<RecipePool>(context);
          // SchedulerBinding.instance.addPostFrameCallback(
          //     (duration) => pool.addRecipe('test')
          // );
          pool.addRecipe('test');

          return FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 1000), () {
              List<Recipe> recipes = pool.recipes;
              Recipe recipe = recipes.length > index ? recipes[index] : null;
              return recipe;
            }),
            builder: (context, snapshot) {
              var ret;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return _buildRow(snapshot.data, index);
                  }
              }
              return ret;
          });
        });

  }

  Widget _buildRow(recipe, index) {
    if (recipe == null){
      return Divider();
    }
    return InkWell(
      child: RecipeCard(
        title: recipe.title,
        index: index,
        saved: recipe.saved ?? false
      ),
      onTap: () {
        if (recipe.saved ?? false) {
          recipe.saved = true;
        } else {
          recipe.saved = false;
        }
      },
    );
  }

  @override
  Widget build(context) {
    this._filter = widget.filter;
    return ChangeNotifierProvider(
      create: (context) => RecipePool(),
      child: Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              actions: [ IconButton(icon: Icon(Icons.filter_list), onPressed: () {  },)]
          ),
          body: _recipeList(),
        ),
    );
  }
}

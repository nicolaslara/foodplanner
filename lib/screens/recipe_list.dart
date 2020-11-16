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
          if (index < pool.recipes.length) {
            return _buildRow(pool.recipes[index]);
          } else {
            SchedulerBinding.instance.addPostFrameCallback(
                    (duration) => pool.addRecipe('test ${index}')
            );
            return Divider();
          }
        });
  }

  Widget _buildRow(recipe) {
    return InkWell(
      child: RecipeCard(
        title: recipe.title,
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

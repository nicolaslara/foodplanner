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

    RecipePool pool = Provider.of<RecipePool>(context);
    if (this._filter) {
      final saved = pool.recipes.where((Recipe recipe) => recipe.saved);
      final tiles = saved.map(
              (recipe) => RecipeCard(title: recipe.title, saved: true)).toList();
      return ListView(padding: EdgeInsets.all(20), children: tiles,);
    }

    return ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (context, int index) {
          if (index < pool.recipes.length) {
            return _buildRow(pool, index);
          } else {
            SchedulerBinding.instance.addPostFrameCallback(
                    (duration) => pool.addRecipe('test ${index}')
            );
            return Divider();
          }
        });
  }

  Widget _buildRow(pool, index) {
    return InkWell(
      child: RecipeCard(
        title: pool.recipes[index].title,
        saved: pool.recipes[index].saved ?? false
      ),
      onTap: () {
        pool.toggleSaved(index);
      },
    );
  }

  @override
  Widget build(context) {
    this._filter = widget.filter;
    return Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              actions: [ IconButton(icon: Icon(Icons.filter_list), onPressed: () {  },)]
          ),
          body: _recipeList()
    );
  }
}

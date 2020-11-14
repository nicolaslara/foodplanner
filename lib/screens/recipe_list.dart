import 'package:flutter/material.dart';
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
  final _saved = <String>[];
  bool _filter = false;

  Widget _recipeList() {
    if (this._filter) {
      final tiles = _saved.map((String word) => RecipeCard(
      title: word, saved: true)).toList();

      return ListView(children: tiles, padding: EdgeInsets.all(20));
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemBuilder: (BuildContext context, int index) {
        var pool = Provider.of<RecipePool>(context);
        if (index >= pool.recipes.length) {
          pool.addRecipe("test " + index.toString());
        }
        return _buildRow(pool.recipes[index]);
      },
    );
  }

  Widget _buildRow(word) {
    return InkWell(
      child: RecipeCard(
        title: word,
        saved: _saved.contains(word),
      ),
      onTap: () {
        setState(() {
          if (_saved.contains(word)) {
            _saved.remove(word);
          } else {
            _saved.add(word);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

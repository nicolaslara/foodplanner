import 'package:flutter/material.dart';
import 'package:foodplanner/widgets/recipe.dart';

class RecipeList extends StatefulWidget {
  RecipeList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final _recipes = <String>[];
  final _saved = <String>[];

  void _showSaved(){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final tiles = _saved.map((String word) => Recipe(
                  title: word, saved: true)).toList();

              return Scaffold(
                appBar: AppBar(title: Text('Saved')),
                body: ListView(children: tiles, padding: EdgeInsets.all(16.0)),
              );

            }
        )
    );
  }

  Widget _recipeList() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemBuilder: (BuildContext context, int index) {
        if (index >= _recipes.length) {
          _recipes.add("test " + index.toString());
        }
        return _buildRow(_recipes[index]);
      },
    );
  }

  Widget _buildRow(word) {
    return InkWell(
      child: Recipe(
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
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          actions: [ IconButton(icon: Icon(Icons.star), onPressed: _showSaved,)]
      ),
      body: _recipeList(),
    );
  }
}

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

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showSaved(){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final tiles = _saved.map((String word) => Recipe(
                  title: word, saved: true));

              final list = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return Scaffold(
                appBar: AppBar(title: Text('Saved')),
                body: ListView(children: list, padding: EdgeInsets.all(16.0)),
              );

            }
        )
    );
  }

  Widget _recipeList() {
    final divideBy = 2;
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int i) {
        if(i==0) return Container(width: 0, height: 0);
        if (i % divideBy == 0) return Divider();
        final index = i - (i ~/ divideBy) + _counter;
        if (index >= _recipes.length) {
          _recipes.add("test" + index.toString());
        }
        return _buildRow(_recipes[index-1]);
      },
    );
  }

  Widget _buildRow(word) {
    final saved = _saved.contains(word);
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
          actions: [ IconButton(icon: Icon(Icons.list), onPressed: _showSaved,)]
      ),
      body: _recipeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

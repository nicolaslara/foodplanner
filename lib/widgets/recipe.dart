import 'package:flutter/material.dart';

class Recipe extends StatelessWidget {
  static const _biggerFont = TextStyle(fontSize: 18.0);

  final String title;
  final bool saved;

  Recipe({this.title, this.saved=false});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(
              title,
              style: _biggerFont,
            ),
            trailing: Icon(
                saved ?  Icons.favorite : Icons.favorite_border,
                color: saved ? Colors.red : null
            )
        )
    );
  }

}
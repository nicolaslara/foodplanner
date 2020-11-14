import 'package:flutter/material.dart';

class Recipe extends StatelessWidget {
  static const _biggerFont = TextStyle(fontSize: 18.0);

  final String title;
  final bool saved;

  Recipe({this.title, this.saved=false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 200),
      child: Card(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 1, child: FlutterLogo()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: _biggerFont),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('Cals'), Text('Prot'), Text('Carbs'), Text('Fat')]),
                        ],
                      ),
                    ]),
              ),
              Icon(
                  saved ?  Icons.star : Icons.star_border,
                  color: saved ? Colors.red : null
              ),
            ],
          )
      ),
    );
  }

}

/*
ListTile(
            title: Text(
              title,
              style: _biggerFont,
            ),
            trailing: Icon(
                saved ?  Icons.favorite : Icons.favorite_border,
                color: saved ? Colors.red : null
            )
        )
 */
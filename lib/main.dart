import 'package:flutter/material.dart';
import 'package:foodplanner/recipes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo 2',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RecipeList(title: 'Food Planner'),
    );
  }
}


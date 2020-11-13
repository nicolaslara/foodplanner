import 'package:flutter/material.dart';
import 'package:foodplanner/screens/recipes.dart';

void main() {
  runApp(FoodPlanner());
}

class FoodPlanner extends StatelessWidget {

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

/*
* ToDo:
*  - Experiment with state management (states_rebuilder? https://github.com/gskinnerTeam/flutter-mvcs-hello-world?)
*  - Integrate with Firebase
*  - Add separate screens and Routes
*  - Make responsive
*
*
* */
import 'package:flutter/material.dart';
import 'package:foodplanner/screens/recipes.dart';
import 'package:foodplanner/widgets/navigation.dart';

void main() {
  runApp(FoodPlanner());
}

class FoodPlanner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Navigation()
    );
  }
}

/*
* ToDo:
*  - Experiment with state management (states_rebuilder? https://github.com/gskinnerTeam/flutter-mvcs-hello-world?)
*  - Integrate with Firebase
*  - Add separate screens and Routes
*  - Make responsive
*  - Currently using fake navigation. Use real navigation (named routes+back button). Prob with PageController
*
*
* */
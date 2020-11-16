import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/widgets/navigation.dart';

void main() {
  runApp(FoodPlanner());
}

class FoodPlanner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              home: Navigation()
          );
        }

        // Loading screen
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.deepPurple,
            body: Center(child: Text("Initializing Firebase!", style: TextStyle(color: Colors.white),))
          ),
        );
      },
    );
  }
}

/*
* ToDo:
*  - Integrate with Firebase
*  - Make responsive
*  - Currently using fake navigation. Use real navigation (named routes+back button). Prob with PageController
*
*
* */
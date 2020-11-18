import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:foodplanner/widgets/navigation.dart';
import 'package:provider/provider.dart';

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
          print('ERROR');
          return Text('Error');
        }
        var app;
        if (snapshot.connectionState == ConnectionState.done) {
          app = MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => NavigationController()),
                ChangeNotifierProvider(create: (context) => Filters()),
              ],
              child: Navigation()
          );
        }else {
          app =  Scaffold(
              backgroundColor: Colors.deepPurple,
              body: Center(
                  child: Text("Initializing Firebase!",
                    style: TextStyle(color: Colors.white),
                  )
              )
          );
        }

          return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              home: app
          );
        }
    );
  }
}

/*
* ToDo:
*  - Make responsive
*  - Better filters: Make a filters page, make the active filters state global, dynamically filter on the recipes page.
*  - Currently using fake navigation. Use real navigation (named routes+back button). Prob with PageController
*  - Add real data to actually make this into a usable application
*  - Create recipe
*
* */
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:foodplanner/stores/tag_pool.dart';
import 'package:foodplanner/widgets/navigation.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(FoodPlanner());
}

MaterialColor swatchify(MaterialColor color, int value) {
  return MaterialColor(color[value].hashCode, <int, Color>{
    50: color[value],
    100: color[value],
    200: color[value],
    300: color[value],
    400: color[value],
    500: color[value],
    600: color[value],
    700: color[value],
    800: color[value],
    900: color[value],
  });
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
                ChangeNotifierProvider(create: (context) => TagPool())
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
            debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: swatchify(Colors.orange, 300),
                cardColor: Colors.orange[100],
                canvasColor: Colors.orange[100],
              ),
              navigatorKey: navigatorKey,
              home: app
          );
      }
    );
  }
}

/*
* ToDo:
*  - Make responsive
*  - Prefetch images in the model
*  - Create recipe page
*  - Add cover image selection
*  - Select default image
*  - Create recipe
*  - Add rating (easy/good) and comments
*  - Add macro targets / count
*  - Add machine learning to extract ingredients/macros from recipes
*  - Currently using fake navigation. Use real navigation (named routes+back button). Prob with PageController
*  - Better filters / search
* */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:foodplanner/stores/tag_pool.dart';
import 'package:foodplanner/widgets/navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show GoogleAuthButton;

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

class FoodPlanner extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => FoodPlannerState();
}

class FoodPlannerState extends State<FoodPlanner> {
  UserCredential userCredential;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Widget loginScreen(context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Welcome to',
                    style: Theme.of(context).textTheme.headline5),
                Text(
                    'FoodPlanner',
                    style: Theme.of(context).textTheme.headline2),
                SizedBox(height: 30),


                GoogleAuthButton(
                  onPressed: () async {
                    try {
                      UserCredential credential = await signInWithGoogle();
                      setState(() {
                        userCredential = credential;
                      });
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: 'Error signing in',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          fontSize: 16.0
                      );
                    }
                  },
                  //darkMode: true,
                ),

              ],
            )
        )
    );
  }

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
          FirebaseAuth auth = FirebaseAuth.instance;
          FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

          if (auth.currentUser == null){
            // Login Screeen
            app = loginScreen(context);
          } else {
            app = MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => NavigationController()),
                  ChangeNotifierProvider(create: (context) => Filters()),
                  ChangeNotifierProvider(create: (context) => TagPool())
                ],
                child: Navigation()
            );

          }

        }else {
          app =  Scaffold(
              backgroundColor: Colors.deepOrangeAccent,
              body: Center(
                  child: Text("Initializing...",
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

Future<void> showDeleteDialog(context, recipe) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this recipe?'),
              Text('This action is not reversible.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            style: TextButton.styleFrom(
            ),
            onPressed: () {
              navigatorKey.currentState.pop();
            },
          ),

          TextButton(
            child: Text('Delete'),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              final recipes = FirebaseFirestore.instance.collection('recipes');
              try {
                await recipes.doc(recipe.slug).delete();
                Fluttertoast.showToast(
                    msg: 'Deleted!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0
                );
              } catch (e) {
                print(e);
                FirebaseCrashlytics.instance.recordFlutterError(e);
                Fluttertoast.showToast(
                    msg: 'Error deleting',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0
                );

              }

              navigatorKey.currentState.pop();
              navigatorKey.currentState.pop();
            },
          ),

        ],
      );
    },
  );
}


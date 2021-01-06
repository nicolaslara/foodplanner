import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/screens/editor/tags.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:slugify/slugify.dart';

import '../../main.dart';
import 'images.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe();

  @override
  EditRecipeState createState() => EditRecipeState();
}

const double imageSize = 150;

class EditRecipeState  extends State<EditRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _imagesKey = GlobalKey<ImagesState>();
  final _tagsKey = GlobalKey<TagEditorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Recipe recipe = Recipe();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Recipe'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                children: [
                  Images(key: _imagesKey),
                  TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title'
                    ),
                    onSaved: (val) => recipe.title = val,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Source'
                    ),
                    onSaved: (val) => recipe.url = val,
                  ),
                  TagEditor(key: _tagsKey),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final scaffold = _scaffoldKey.currentState;
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          recipe.slug = Slugify(recipe.title);
                          recipe.tags = _tagsKey.currentState.tags;

                          List<String> images = [];

                          try {
                            print(_imagesKey.currentState.images);
                            FirebaseStorage bucket = FirebaseStorage.instanceFor(bucket: 'foodplanner-d4a4c');
                            for (var i=0; i < _imagesKey.currentState.images.length; i++){
                              Reference ref = bucket.ref('${recipe.slug}-${i}');
                              await ref.putFile(_imagesKey.currentState.images[i]);
                              images.add(await ref.getDownloadURL());
                            }
                          } on FirebaseException catch (e) {
                            // e.g, e.code == 'canceled'
                            print('ERROR');
                            print(e);
                            scaffold.showSnackBar(SnackBar(content: Text("Can't upload images")));
                            return;
                          }

                          Map<String, dynamic> data = {
                            'title': recipe.title,
                            'url': recipe.url,
                            'tags': recipe.tags,
                            'saved': false,
                            'new': true,
                            'images': images,
                          };

                          final recipes = FirebaseFirestore.instance.collection('recipes');
                          DocumentReference doc = recipes.doc(recipe.slug);
                          DocumentSnapshot snapshot = await doc.get();
                          if (snapshot.exists){
                            await doc.update(data);
                          } else {
                            await doc.set(data);
                          }

                          scaffold.showSnackBar(SnackBar(content: Text('Saved!')));
                          navigatorKey.currentState.pop();
                        } else {
                          scaffold.showSnackBar(SnackBar(content: Text('Error')));
                        }
                      },
                      child: Text('Submit'),
                    ),
                  )
                ]
            ),
          ),
        ),
      ),
    );


  }

}

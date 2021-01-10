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
  final Recipe recipe;

  const EditRecipe(this.recipe);
  const EditRecipe.empty()
      : recipe = null;

  @override
  EditRecipeState createState() => EditRecipeState();
}

const double imageSize = 150;

class EditRecipeState  extends State<EditRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _imagesKey = GlobalKey<ImagesState>();
  final _tagsKey = GlobalKey<TagEditorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Recipe recipe;

  @override
  void initState(){
    super.initState();
    if (widget.recipe == null){
      recipe = Recipe();
    } else {
      recipe = widget.recipe;
    }
  }

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
                  Images(key: _imagesKey, images: recipe.images),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Title *',
                        border: InputBorder.none,
                        hintText: 'Delicious food with extra toppings'
                    ),
                    initialValue: recipe.title,
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
                        labelText: 'Source',
                        border: InputBorder.none,
                        hintText: 'http://www.superrecipes.com/delicious/'
                    ),
                    initialValue: recipe.url,
                    onSaved: (val) => recipe.url = val,
                  ),
                  TagEditor(key: _tagsKey, tags: recipe.tags),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final scaffold = _scaffoldKey.currentState;
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          if (recipe.slug == null){
                            recipe.slug = Slugify(recipe.title);
                          }
                          recipe.tags = _tagsKey.currentState.tags;

                          List<String> images = _imagesKey.currentState.existingImages;

                          try {
                            print(_imagesKey.currentState.images);
                            FirebaseStorage bucket = FirebaseStorage.instanceFor(bucket: 'foodplanner-d4a4c');
                            for (var i=0; i < _imagesKey.currentState.images.length; i++){
                              Reference ref = bucket.ref('${recipe.slug}-$i');
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
                          if (navigatorKey.currentState.canPop()){
                            navigatorKey.currentState.pop();  // Temporarily pop twice while the states are not using shared states
                          }
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

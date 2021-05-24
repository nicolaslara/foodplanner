import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodplanner/screens/editor/tags.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:foodplanner/stores/tag_pool.dart';
import 'package:foodplanner/utils/helpers.dart';

import 'package:slugify/slugify.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

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

  Widget macrosField(label, hint, value, {onSaved}){
    return TextFormField(
      decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          hintText: hint
      ),
      initialValue: value?.toString(),
      keyboardType: TextInputType.number,
      validator: (val) {
        if (val.isEmpty){
          return null;
        }
        try {
          int.parse(val);
          return null;
        } catch (e){
          return 'Number required';
        }
      },
      onSaved: onSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    TagPool tagPool = TagPool();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Recipe'),
        actions: recipe.slug != null ? [
          IconButton(
            icon: const Icon(Icons.delete_forever_sharp),
            color: Colors.red,
            onPressed: () async {
              await showDeleteDialog(context, recipe);
              navigatorKey.currentState.pop();
            },
          ),
        ] : [],
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
                  FutureBuilder(
                      future: tagPool.fetchTags(),
                      builder: (context, snapshot)  {
                        if (snapshot.connectionState == ConnectionState.done){
                          return TagEditor(key: _tagsKey, tags: recipe.tags, tagSuggestions: tagPool.tags.keys.toList());
                        }
                        return Container();
                      }
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Source',
                        border: InputBorder.none,
                        hintText: 'http://www.superrecipes.com/delicious/'
                    ),
                    initialValue: recipe.url == 'None' ? '' : recipe.url,
                    onSaved: (val) => recipe.url = val,
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Notes',
                        border: InputBorder.none,
                        hintText: 'This one is really good for parties!! 🥳'
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: recipe.notes,
                    onSaved: (val) => recipe.notes = val,
                  ),

                  macrosField('KCal', '350', recipe.kcal,
                      onSaved:  (val) => recipe.kcal = val.isNotEmpty ? int.parse(val) : null
                  ),
                  macrosField('Protein', '32', recipe.protein,
                      onSaved:  (val) => recipe.protein = val.isNotEmpty ? int.parse(val) : null
                  ),
                  macrosField('Carbs', '25', recipe.carbs,
                      onSaved:  (val) => recipe.carbs = val.isNotEmpty ? int.parse(val) : null
                  ),
                  macrosField('Fat', '18', recipe.fat,
                      onSaved:  (val) => recipe.fat = val.isNotEmpty ? int.parse(val) : null
                  ),



                  Align(
                    alignment: Alignment.bottomRight,
                    child: TapDebouncer(
                      cooldown: const Duration(milliseconds: 5000),
                      builder: (BuildContext context, TapDebouncerFunc onTap) {
                        return ElevatedButton(
                          onPressed: onTap,
                          child: onTap == null
                              ? const CircularProgressIndicator()
                              : const Text('Submit'),
                        );
                      },
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          if (recipe.slug == null){
                            recipe.slug = Slugify(recipe.title);
                          }

                          _tagsKey.currentState.tags.remove('all');
                          _tagsKey.currentState.tags.remove('no tag');
                          recipe.tags = _tagsKey.currentState.tags.toSet().toList();

                          List<String> images = _imagesKey.currentState.existingImages;

                          try {
                            print(_imagesKey.currentState.images);
                            FirebaseStorage bucket = FirebaseStorage.instanceFor(bucket: 'foodplanner-d4a4c');
                            for (var i=0; i < _imagesKey.currentState.images.length; i++){
                              print('${recipe.slug}-$i');
                              Reference ref = bucket.ref('${recipe.slug}-$i');
                              await ref.putFile(_imagesKey.currentState.images[i]);
                              images.add(await ref.getDownloadURL());
                            }
                          } on FirebaseException catch (e) {
                            // e.g, e.code == 'canceled'
                            print('ERROR');
                            print(e);
                            FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't upload images")));
                            return;
                          }

                          Map<String, dynamic> data = {
                            'title': recipe.title,
                            'url': recipe.url,
                            'tags': recipe.tags,
                            'saved': false,
                            'new': true,
                            'images': images,
                            'kcal': recipe.kcal,
                            'notes': recipe.notes,
                            'macros': {
                              'protein': recipe.protein,
                              'carbs': recipe.carbs,
                              'fat': recipe.fat,
                            }
                          };

                          final recipes = FirebaseFirestore.instance.collection('recipes');
                          DocumentReference doc = recipes.doc(recipe.slug);
                          DocumentSnapshot snapshot = await doc.get();
                          if (snapshot.exists){
                            await doc.update(data);
                          } else {
                            await doc.set(data);
                          }

                          Fluttertoast.showToast(
                              msg: 'Saved!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0
                          );

                          navigatorKey.currentState.pop();
                          if (navigatorKey.currentState.canPop()){
                            navigatorKey.currentState.pop();  // Temporarily pop twice while the states are not using shared states
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Error',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0
                          );
                        }
                      },
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

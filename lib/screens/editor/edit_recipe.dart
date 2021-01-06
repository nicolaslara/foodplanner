import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/screens/editor/tags.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:slugify/slugify.dart';

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
  Recipe recipe = Recipe();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        final scaffold = Scaffold.of(context);
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          recipe.tags = _tagsKey.currentState.tags;

                          final recipes = FirebaseFirestore.instance.collection('recipes');
                           await recipes
                               .doc(Slugify(recipe.title))
                               .update({
                             'title': recipe.title,
                             'url': recipe.url,
                             'tags': recipe.tags,
                             'saved': false,
                             'new': true,
                           });


                          scaffold.showSnackBar(SnackBar(content: Text('Saved!')));
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

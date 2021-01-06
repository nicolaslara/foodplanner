import 'package:flutter/material.dart';
import 'package:foodplanner/screens/editor/tags.dart';

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
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Source'
                    ),
                  ),
                  TagEditor(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final scaffold = Scaffold.of(context);
                        if (_formKey.currentState.validate()) {
                          scaffold.showSnackBar(SnackBar(content: Text('Processing Data')));
                          print(_formKey.currentState);
                          print(_imagesKey.currentState.images);
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

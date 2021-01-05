import 'package:flutter/material.dart';

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
      body: Form(
        key: _formKey,
        child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title'
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'URL'
                ),
              ),
              Images(key: _imagesKey),
              ElevatedButton(
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
              )
            ]
        ),
      ),
    );


  }

}

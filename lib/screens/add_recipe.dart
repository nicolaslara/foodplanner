import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/widgets/recipe_card.dart';

GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

class AddRecipe extends StatefulWidget {
  final File _image;
  const AddRecipe(this._image);

  @override
  AddRecipeState createState() => AddRecipeState(this._image);
}

const double imageSize = 150;

class AddRecipeState  extends State<AddRecipe>  {
  List<File> images = [];
  String currentText = "";
  List<String> added = [];

  AddRecipeState(File image) : super() {
    this.images.add(image);
  }

  Widget get tags {
    return SizedBox(
      height: 30,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: [...added.map((t)=>Tag(t, null)).toList()]),
    );
  }


  List<Widget> get imageWidgets{
    if (images.length == 0){
      return [Text('No image selected.')];
    } else {
      return images.map((image)=> Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: FittedBox(
                child: Image.file(image),
                fit: BoxFit.cover
            )
        ),
      )).toList() + [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Icon(Icons.add)
              ),
          ),
        )
      ];

    }
  }

  @override
  Widget build(BuildContext context) {
    SimpleAutoCompleteTextField tagAutocompleteField = SimpleAutoCompleteTextField(
      key: key,
      controller: TextEditingController(text: "Add tags"),
      textChanged: (text) => currentText = text,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          print('test');
          print(added);
          added.add(text);
        }
      }),
      suggestions: ["tag", "test"],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Add new recipe from Image'),
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title'
              ),
            ),
            ListTile(
              title: tagAutocompleteField,
              trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print(tagAutocompleteField);
                    tagAutocompleteField.triggerSubmitted();
                    print(added);
                  }),
            ),
            tags,
            Text('Description goes here'),
            Text('ETC...'),
            SizedBox(
                height: imageSize,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: imageWidgets
                )
            )
          ]
        ),
      ),
    );
  }

}
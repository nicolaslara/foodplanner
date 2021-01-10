import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/widgets/recipe_card.dart';


class TagEditor extends StatefulWidget {
  final List<String> tags;
  const TagEditor({Key key, this.tags}) : super(key: key);

  @override
  TagEditorState createState() => TagEditorState();

}

class TagEditorState  extends State<TagEditor> {
  List<String> tags = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> _autocompleteKey = new GlobalKey();
  SimpleAutoCompleteTextField tagAutocompleteField;

  @override
  void initState(){
    super.initState();
    if (widget.tags != null){
      tags = List.from(widget.tags);
    }
    tagAutocompleteField = SimpleAutoCompleteTextField(
      key: _autocompleteKey,
      controller: TextEditingController(),
      textChanged: (text) => setState(() {
        currentText = text;
      }),
      textSubmitted: (text) => setState(() {
        if (text != "") {
          tags.add(text);
        }
      }),
      suggestions: ["tag", "test"],
    );
  }


  Widget get tagDisplay {
    return SizedBox(
      height: 30,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...tags.map((t)=>Tag(
              title: t,
              onDelete: (){
                setState(() {
                  tags.remove(t);
                });
              })).toList()
          ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: tagAutocompleteField,
          subtitle: Text("Add tags"),
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                print(tagAutocompleteField);
                tagAutocompleteField.triggerSubmitted();
              }),
        ),
        tagDisplay,
      ],
    );
  }

}
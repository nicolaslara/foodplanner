import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/widgets/recipe_card.dart';

class RecipeList extends StatelessWidget {
  RecipeList({Key key, this.title, this.selected=false}) : super(key: key);

  final String title;
  final bool selected;

  Widget _buildRow(document) {
    return Stack(
      children: [
        RecipeCard(
            title: document["title"],
            saved: document["saved"] ?? false
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    if (this.selected) return null;
                    FirebaseFirestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot snapshot = await transaction.get(document.reference);
                      transaction.update(document.reference, {
                        'saved': !snapshot['saved']
                      });
                    });
                  })
          ),
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    Query query;
    if (this.selected){
      query = FirebaseFirestore.instance.collection('recipes').where('saved', isEqualTo: true);
    } else {
      query = FirebaseFirestore.instance.collection('recipes');
    }
    return Scaffold(
          appBar: AppBar(
              title: Text(this.title),
              actions: [ IconButton(icon: Icon(Icons.filter_list), onPressed: () {  },)]
          ),
          body: StreamBuilder(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildRow(snapshot.data.documents[index])
              );
            },

          )
    );
  }
}

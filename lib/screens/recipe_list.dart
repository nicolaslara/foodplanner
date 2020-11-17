import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/widgets/recipe_card.dart';

class RecipeList extends StatelessWidget {
  RecipeList({Key key, this.title, this.filter=false}) : super(key: key);

  final String title;
  final bool filter;

  Widget _buildRow(document) {
    return InkWell(
      child: RecipeCard(
          title: document["title"],
          saved: document["saved"] ?? false
      ),
      onTap: () {
        if (this.filter) return null;

        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(document.reference);
          transaction.update(document.reference, {
            'saved': !snapshot['saved']
          });
        });
      },
    );
  }

  @override
  Widget build(context) {
    Query query;
    if (this.filter){
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

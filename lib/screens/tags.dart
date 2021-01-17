import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/constants.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:provider/provider.dart';


class Tags extends StatelessWidget {

  Widget _buildRow(String tag, context){
    return Center(
      child: Card(
        child: InkWell(
          onTap: () {
            NavigationController nav = Provider.of<NavigationController>(context);
            Filters filters = Provider.of<Filters>(context);
            nav.setPage(1);
            if (tag == "All"){
              filters.clear();
            } else {
              filters.setFilter('tags', {#arrayContains: tag});
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Expanded(child: Center(child: Text(tag, style: TextStyle(fontSize: mediumFont))))],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('recipes');
    return Scaffold(
      appBar: AppBar(
        title: Text("Collections"),
      ),
      body: StreamBuilder(
        stream: collection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          List tags = snapshot.data.documents.map((i)=>i['tags']).reduce((val, elem)=> val+elem);
          tags.insert(0, "All");
          tags = tags.toSet().toList();
          tags.sort();
          return ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, index) => _buildRow(tags[index], context)
          );
        },

      )
      ,
    );
  }
}

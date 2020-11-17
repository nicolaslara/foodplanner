import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:provider/provider.dart';


class Tags extends StatelessWidget {

  Widget _buildRow(tag, context){
    return Center(
      child: Card(
        child: InkWell(
          onTap: () {
            NavigationController pool = Provider.of<NavigationController>(context);
            pool.setPage(1);
          },
          child: Container(
            width: 300,
            height: 100,
            child: Text(tag),
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

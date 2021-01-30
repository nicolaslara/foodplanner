import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';


class TagPool extends ChangeNotifier {
  Map<String, String> tags = {};
  StreamSubscription _subscription;
  CollectionReference collection = FirebaseFirestore.instance.collection('recipes');

  TagPool() : super() {

    _subscription = collection.snapshots().listen((QuerySnapshot snapshot)  {
      if (snapshot.docs.isEmpty) {
        return;
      }

      snapshot.docs.forEach((doc) {
        doc['tags'].forEach((tag){
          String defaultImage = tags.containsKey(tag) ? tags[tag] : '';
          tags[tag] = doc['images'].isNotEmpty ? doc['images'][0] : defaultImage;
        });
      });
      notifyListeners();
    });
  }

  fetchTags() async {
    QuerySnapshot query = await collection.orderBy('title').get();
    query.docs.forEach((doc) {
      doc['tags'].forEach((tag) {
        String defaultImage = tags.containsKey(tag) ? tags[tag] : '';
        tags[tag] = doc['images'].isNotEmpty ? doc['images'][0] : defaultImage;
      });
    });
  }

  asData(){
    List tagList = tags.entries.map((e)=>{'tag': e.key, 'image': e.value}).toList();
    tagList.sort((a,b)=>compareNatural(a['tag'], (b['tag'])));
    tagList.insert(0, {'tag': 'No Tag', 'image': ''});
    tagList.insert(0, {'tag': 'All', 'image': ''});
    return tagList;
  }


  @override
  void dispose() {
    if (_subscription != null){
      _subscription.cancel();
    }
    super.dispose();
  }

}

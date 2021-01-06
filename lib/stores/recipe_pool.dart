import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  Recipe({this.title, this.reference, this.saved, this.tags, this.images, this.url}) : super() {
    this.title = this.title?.replaceAll('\n', '');
  }

  String title;
  DocumentReference reference;
  String url;
  bool saved = false;
  List<String> tags = [];
  List<String> images = [];
}

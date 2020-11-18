import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Filters extends ChangeNotifier {
  Map<String, Map<Symbol, String>> _filters = {};
  Map<String, Map<Symbol, String>> get filters => _filters;

  void setFilter(field, [params=const {}]){
    _filters[field] = params;
    notifyListeners();
  }
}
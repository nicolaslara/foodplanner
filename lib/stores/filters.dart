import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Filters extends ChangeNotifier {
  Map<String, Map<Symbol, dynamic>> _filters = {};
  Map<String, Map<Symbol, dynamic>> get all => _filters;

  String value(key){
    var vals = _filters[key];
    if (vals != null){
      return vals[#arrayContains];
    }
    return null;
  }

  void setFilter(field, [params=const {}]){
    _filters[field] = params;
    notifyListeners();
  }

  void clear(){
    _filters = {};
    notifyListeners();
  }
}
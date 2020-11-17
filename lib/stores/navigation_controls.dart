import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  void setPage(index){
    _currentPage = index;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    notifyListeners();
  }

}
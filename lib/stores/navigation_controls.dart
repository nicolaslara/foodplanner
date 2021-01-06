import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _currentPage = 1;
  int get currentPage => _currentPage;
  PageController _pageController = PageController(initialPage: 1);
  PageController get pageController => _pageController;

  void setPage(index){
    _currentPage = index;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    notifyListeners();
  }

  void previousPage(){
    _pageController.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    _currentPage = _currentPage > 0 ? currentPage - 1: 0;
    notifyListeners();
  }


}
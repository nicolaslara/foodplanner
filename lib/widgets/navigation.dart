import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodplanner/main.dart';
import 'package:foodplanner/screens/add_recipe.dart';
import 'package:foodplanner/screens/editor/edit_recipe.dart';
import 'package:foodplanner/screens/recipe_list.dart';
import 'package:foodplanner/screens/tags.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class FourthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fourth Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}


class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  static final List<Widget> _pageList = [
    Tags(),
    RecipeList(title: 'Recipes'),
    RecipeList(title: 'Selected', selected: true),
    FourthScreen()
  ];

  static final List<BottomNavigationBarItem> _pageButtons = [
    BottomNavigationBarItem(
      icon: Icon(Icons.all_inbox_sharp),
      label: 'Collections',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: 'Recipes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: 'Selected',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.pie_chart),
      label: 'Stats',
    ),
  ];

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        navigatorKey.currentState.push(
          MaterialPageRoute(builder: (context) => AddRecipe(File(pickedFile.path))),
        );
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    NavigationController navController = Provider.of<NavigationController>(context);
    return Scaffold(
        body: WillPopScope(
          child: PageView(
            controller: navController.pageController,
            children: _pageList,
            onPageChanged: (index) {
              navController.setPage(index);
            },
          ),
          onWillPop: () {
            if (navigatorKey.currentState.canPop()) {
              navigatorKey.currentState.maybePop();
              return Future<bool>.value(false);
            }
            if (navController.currentPage > 0){
              navController.previousPage();
              return Future<bool>.value(false);
            }
            return Future<bool>.value(true);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SizedBox(
                height: 55,
                width: 55,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
                    navigatorKey.currentState.push(
                      MaterialPageRoute(builder: (context) => EditRecipe.empty()),
                    );
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: const Alignment(0.7, -0.5),
                        end: const Alignment(0.6, 0.5),
                        colors: [
                          swatchify(Colors.orange, 300),
                          swatchify(Colors.orange, 700),
                          //Colors.pinkAccent,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.add_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
            )
        ),
        bottomNavigationBar: SizedBox(
          height: 65,
          child: BottomNavigationBar(
            backgroundColor: swatchify(Colors.orange, 300),
            selectedItemColor: Colors.pink[500],
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            items: _pageButtons,
            currentIndex: navController.currentPage,
            onTap: (int index){
              NavigationController nav = Provider.of<NavigationController>(context);
              nav.setPage(index);
            },
          ),
        ));
  }

}

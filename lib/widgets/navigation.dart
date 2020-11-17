import 'package:flutter/material.dart';
import 'package:foodplanner/screens/recipe_list.dart';
import 'package:foodplanner/screens/tags.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      NavigationController pool = Provider.of<NavigationController>(context);
      pool.setPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    NavigationController navController = Provider.of<NavigationController>(context);
    return Scaffold(
        body: PageView(
            controller: navController.pageController,
            children: _pageList
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: SizedBox(
                height: 65,
                width: 65,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: const Alignment(0.7, -0.5),
                        end: const Alignment(0.6, 0.5),
                        colors: [
                          Colors.orange,
                          Colors.deepOrange,
                        ],
                      ),
                    ),
                    child: Icon(Icons.add, size: 30),
                  ),
                )
            )
        ),
        bottomNavigationBar: SizedBox(
          height: 65,
          child: BottomNavigationBar(
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            items: _pageButtons,
            currentIndex: navController.currentPage,
            onTap: _onItemTapped,
          ),
        ));
  }

}

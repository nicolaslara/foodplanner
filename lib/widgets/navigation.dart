import 'package:flutter/material.dart';
import 'package:foodplanner/screens/recipe_list.dart';
import 'package:foodplanner/stores/recipe_pool.dart';
import 'package:provider/provider.dart';


class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Screen"),
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
  int routeIndex = 0;

  static final pageList = [
    RecipeList(title: 'Recipes'),
    RecipeList(title: 'Selected', filter: true),
    ThirdScreen(),
    FourthScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      routeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipePool(),
      child: Scaffold(
          body: IndexedStack(
            index: routeIndex,
            children: pageList,
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.house),
                  label: 'Recipes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'This Week',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_sharp),
                  label: 'Shopping List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart),
                  label: 'Stats',
                ),
              ],
              currentIndex: routeIndex,
              onTap: _onItemTapped,
            ),
          )),
    );
  }

}

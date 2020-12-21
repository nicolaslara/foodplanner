import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodplanner/constants.dart';
import 'package:foodplanner/stores/filters.dart';



class FilterManagement extends StatelessWidget {
  final Filters _filters;

  FilterManagement(this._filters);

  @override
  Widget build(BuildContext context) {
    var tags = [...?_filters.all['tags']?.values?.map((i)=>Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Chip(label: Text(i), backgroundColor: Colors.lightGreenAccent,),
    ))];

    return Scaffold(
        appBar: AppBar(title: Text("Active Filters")),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Search', style: TextStyle(fontSize: bigFont),),
                          ),
                          Container(width: 200, child: TextField(maxLength: 35,))
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text('Tags', style: TextStyle(fontSize: bigFont),),
                        ),
                        Container(
                            child: Row(
                                children: tags.isNotEmpty ? tags : [Text('All',)]
                            )
                        )
                      ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Saved', style: TextStyle(fontSize: bigFont),),
                          ),
                          DropdownButton(
                            items: [
                              DropdownMenuItem(child: Text('Show all')),
                              DropdownMenuItem(child: Text('Show saved'))
                            ],
                            onChanged: (value) {  },
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: RaisedButton(
                color: Colors.blueAccent,
                child: Text('Filter', style: TextStyle(color: Colors.white, fontSize: mediumFont),),
                onPressed: () {  },),
            )
          ],
        )
    );
  }
}
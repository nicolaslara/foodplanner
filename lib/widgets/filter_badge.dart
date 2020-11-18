import 'package:flutter/material.dart';
import 'package:foodplanner/screens/filters.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:provider/provider.dart';

class FilterBadge extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Filters filters = Provider.of<Filters>(context);

    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            //navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => FilterManagement()));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterManagement()),
            );
          },
        ),
        filters.all.length != 0 ? new Positioned(
          right: 11,
          top: 11,
          child: new Container(
            padding: EdgeInsets.all(2),
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              '${filters.all.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ) : new Container(),
    ]
    );
  }

}
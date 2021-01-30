import 'package:flutter/material.dart';
import 'package:foodplanner/constants.dart';
import 'package:foodplanner/stores/filters.dart';
import 'package:foodplanner/stores/navigation_controls.dart';
import 'package:foodplanner/stores/tag_pool.dart';
import 'package:provider/provider.dart';


class Tags extends StatelessWidget {

  Widget _buildRow(Map tagData, context){
    String tag = tagData['tag'];
    String image = tagData['image'];
    return Center(
      child: Card(
        child: InkWell(
          onTap: () {
            NavigationController nav = Provider.of<NavigationController>(context);
            Filters filters = Provider.of<Filters>(context);
            nav.setPage(1);
            if (tag == "All"){
              filters.clear();
            } else if (tag == "No Tag") {
              filters.setFilter('tags', {#isEqualTo: []});
            } else {
              filters.setFilter('tags', {#arrayContains: tag});
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 80,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: image.isNotEmpty ? Image.network(image) : FlutterLogo()
                    ),
                  ),
                  Center(child: Text(tag, style: TextStyle(fontSize: mediumFont)))
                ])
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    TagPool tagPool = Provider.of<TagPool>(context);
    List displayData = tagPool.asData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Collections"),
      ),
      body: ListView.builder(
          itemCount: displayData.length,
          itemBuilder: (context, index) => _buildRow(displayData[index], context)
      )
    );
  }
}

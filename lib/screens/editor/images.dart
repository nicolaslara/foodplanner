
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Images extends StatefulWidget {
  const Images({Key key}) : super(key: key);

  @override
  ImagesState createState() => ImagesState();

}

class ImagesState  extends State<Images> {

  static const double imageSize = 350;

  final picker = ImagePicker();
  List<File> images = [];


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        images.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  Padding get addImageButton{
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: getImage,
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                ),
                child: Icon(Icons.add)
            ),
          ),
        ),
      );
  }

  List<Padding> get imageWidgets{
    if (images.length == 0){
      return [];
    } else {
      return images.map((image)=> Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: FittedBox(
                child: Image.file(image),
                fit: BoxFit.cover
            )
        ),
      )).toList();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: imageSize,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: imageWidgets + [addImageButton]
            )
        ),
      ],
    );

  }
}
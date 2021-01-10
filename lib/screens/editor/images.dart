
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Images extends StatefulWidget {
  final List<String> images;
  const Images({Key key, this.images}) : super(key: key);

  @override
  ImagesState createState() => ImagesState();

}

class ImagesState  extends State<Images> {

  static const double imageSize = 250;

  final picker = ImagePicker();
  List<String> existingImages;
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    existingImages = widget.images != null ? List.from(widget.images) : [];
  }

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

  Stack imageWithDelete({Widget image, Function onDelete}){
    return Stack(
      children: [
        SizedBox(
            width: imageSize,
            height: imageSize,
            child: FittedBox(
                child: image,
                fit: BoxFit.cover
            )
        ),
        SizedBox(
            width: imageSize,
            height: imageSize,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: onDelete),
              ),
            )
        )
    ]
    );
  }

  List<Padding> get imageWidgets{
    if (existingImages.length + images.length == 0){
      return [];
    } else {
      return existingImages.map((image)=> Padding(
        padding: const EdgeInsets.all(4.0),
        child: imageWithDelete(
          image: Image.network(image),
          onDelete: () {
            setState(() {
              existingImages.remove(image);
            });
          }
        )
      )).toList() + images.map((image)=> Padding(
        padding: const EdgeInsets.all(4.0),
        child: imageWithDelete(
            image: Image.file(image),
            onDelete: () {
              setState(() {
                images.remove(image);
              });
            }

        )
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

import 'dart:io';
import "dart:math" show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

GlobalKey<CircularMenuState> animationKey = GlobalKey<CircularMenuState>();


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


  Future getImage({source=ImageSource.camera}) async {
    final pickedFile = await picker.getImage(source: source);
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
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                ),

                child: CircularMenu(
                    key: animationKey,
                    alignment: Alignment.center,
                    radius: 70,
                    toggleButtonAnimatedIconData: AnimatedIcons.add_event,
                    toggleButtonBoxShadow: [],
                    startingAngleInRadian:  5*pi/16,
                    endingAngleInRadian: 11*pi/16,
                    items: [
                      CircularMenuItem(icon: Icons.add_a_photo_rounded, onTap: () {
                        getImage();
                        animationKey.currentState.reverseAnimation();
                      }),
                      CircularMenuItem(icon: Icons.add_photo_alternate_rounded, onTap: () {
                        getImage(source: ImageSource.gallery);
                        animationKey.currentState.reverseAnimation();
                      }),
                    ])

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
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge
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
          image: CachedNetworkImage(imageUrl: image,),
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
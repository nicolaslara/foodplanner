
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final double imageSize = 150;

class Images extends FormField<List<File>> {


  Images({
    FormFieldSetter<List<File>> onSaved,
    FormFieldValidator<List<File>> validator,
    List<File> initialValue = const [],
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      builder: (FormFieldState<List<File>> state) {
        final picker = ImagePicker();
        return Column(
          children: [
            SizedBox(
                height: imageSize,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: state.value.map((image) =>
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: FittedBox(
                                  child: Image.file(image),
                                  fit: BoxFit.cover
                              )
                          ),
                        )).toList() + [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () async {
                            final pickedFile = await picker.getImage(source: ImageSource.camera);
                            if (pickedFile != null) {
                              state.didChange(state.value + [File(pickedFile.path)]);
                            }
                          },
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
                      )
                    ]
                )
            ),
          ],
        );

      });

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedFile != null) {
  //       images.add(File(pickedFile.path));
  //     } else {
  //       print('No image selected');
  //     }
  //   });
  // }

  Padding get addImageButton{
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        // onTap: getImage,
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

  List<Padding> imageWidgets(images) {
    if (images.length == 0) {
      return [];
    } else {
      return images.map((image) =>
          Padding(
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

}
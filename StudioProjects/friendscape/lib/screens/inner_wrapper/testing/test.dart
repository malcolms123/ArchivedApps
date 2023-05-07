import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  MemoryImage? image;
  File? file;

  Future downloadImage() async {
    Reference ref = FirebaseStorage.instance
        .ref('test/Screen Shot 2021-04-24 at 4.36.42 AM.png');
    MemoryImage pic = MemoryImage((await ref.getData())!);

    setState(() {
      image = pic;
    });
  }

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    print(xFile);

    if (xFile != null) {
      String path = xFile.path;
      print("a");
      File f = File(path);
      print("a");

      setState(() {
        file = f;
      });

      print("a");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Column(
        children: [
          Image.file(file!),
          TextButton(child: Text('post'), onPressed: () async {
            await FirebaseStorage.instance.ref('test/doc1.jpg').putFile(file!);
          })
        ],
      );
      return Image.file(file!);
      /*
      return Container(
        decoration: BoxDecoration(
          image: new DecorationImage(image: image!)
        ),
      );
       */
    } else {
      return TextButton(onPressed: getImage, child: Text('get image'));
    }
  }
}

import 'dart:io';

import 'package:fluentui_icons/fluentui_icons.dart';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

    static String result = '';
    List<String> resultElements = [];
    File? imageFile;
    XFile? image;
    //ImagePicker? imagePicker;
    final ImagePicker _picker = ImagePicker();

  pickImageFromCamera() async {
    
    image = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
    setState(() {
      image;
      performImageLabeling();
    });
    print('SONUCLAR' + result);
    
  }
  
  performImageLabeling() async {
    final GoogleVisionImage visionImage =
        GoogleVisionImage.fromFile(imageFile!);
    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    result = '';
    setState(() {
      for (TextBlock block in visionText.blocks) {
        //final String? txt = block.text;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += "${element.text!} ";
            resultElements.add(element.text!);
          }
        }
        result += "\n\n";
      }
    });

    for(String element in resultElements){
      print(element);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey.shade300,
      onTap: () {
        pickImageFromCamera();
      },
      child: Ink(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: const Align(
            alignment: Alignment.center,
            child: Icon(FluentSystemIcons.ic_fluent_camera_add_regular)),
      ),
    );
  }
}

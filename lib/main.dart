import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:costumer_project/navPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static String result = '';
  List<String> resultElements = [];
  File? imageFile;
  XFile? image;
  //ImagePicker? imagePicker;
  final ImagePicker _picker = ImagePicker();
  String name = '';
  String readableVariable = '';

  final TextEditingController controller = TextEditingController();

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
        result += "\n";
      }
    });
    setState(() {});
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyApp._title,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 244, 245),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          color: Colors.grey.withOpacity(0.5))
                    ]),
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(
                        'Whats in it',
                        style: GoogleFonts.raleway(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffF5F5F5),
                              border: Border.all(
                                  //width: 0.2,
                                  color:
                                      const Color.fromARGB(90, 194, 192, 192))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              style: GoogleFonts.raleway(),
                              controller: controller,
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'type anything...',
                                hintStyle: GoogleFonts.raleway(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        InkWell(
                          splashColor: Colors.grey.shade300,
                          onTap: () async {
                            controller.clear();
                            await pickImageFromCamera();
                            setState(() {});
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff2F84F1),
                            ),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(0),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 10, right: 10, bottom: 10),
                child: Text('Ingredients',
                    style: GoogleFonts.raleway(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: SizedBox(
                            height: 540,
                            child: ListView.builder(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                itemCount: snapshots.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshots.data!.docs[index].data()
                                      as Map<String, dynamic>;
                                  if (!name.isEmpty && data['name'].toString().toLowerCase().startsWith(name.toLowerCase())) {
                                    print('arama ile gelenler');
                                    return ListTile(
                                      minVerticalPadding: 15,
                                      title: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                25,
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 15),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.5))
                                            ],
                                            color: const Color(0xff2F84F1),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 5, bottom: 5),
                                          child: Text(
                                            data['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.raleway(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      subtitle: Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10, left: 20),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.5))
                                            ],
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15))),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Kosher'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Kosher'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                      'Kosher : ' +
                                                          data['Kosher']
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Free Form'] ==
                                                                false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color:
                                                            data['Free Form'] ==
                                                                    false
                                                                ? Colors.red
                                                                : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Free Form : ' +
                                                            data['Free Form']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Halal'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Halal'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    const Gap(5),
                                                    Text(
                                                        'Halal : ${data['Halal']}',
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Vegan'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Vegan'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Vegan : ' +
                                                            data['Vegan']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Vegeterian'] ==
                                                                false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color:
                                                            data['Vegeterian'] ==
                                                                    false
                                                                ? Colors.red
                                                                : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Vegeterian : ' +
                                                            data['Vegeterian']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Helal'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Helal'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Helal : ' +
                                                            data['Helal']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );;
                                  } 
                                  if (name.isEmpty &&result.toLowerCase().contains(
                                      data['name'].toString().toLowerCase())) {
                                    return ListTile(
                                      minVerticalPadding: 15,
                                      title: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                25,
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 15),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.5))
                                            ],
                                            color: const Color(0xff2F84F1),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 5, bottom: 5),
                                          child: Text(
                                            data['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.raleway(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      subtitle: Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10, left: 20),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.5))
                                            ],
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15))),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Kosher'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Kosher'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                      'Kosher : ' +
                                                          data['Kosher']
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Free Form'] ==
                                                                false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color:
                                                            data['Free Form'] ==
                                                                    false
                                                                ? Colors.red
                                                                : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Free Form : ' +
                                                            data['Free Form']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Halal'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Halal'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    const Gap(5),
                                                    Text(
                                                        'Halal : ${data['Halal']}',
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Vegan'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Vegan'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Vegan : ' +
                                                            data['Vegan']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Vegeterian'] ==
                                                                false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color:
                                                            data['Vegeterian'] ==
                                                                    false
                                                                ? Colors.red
                                                                : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Vegeterian : ' +
                                                            data['Vegeterian']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        data['Helal'] == false
                                                            ? Icons.close
                                                            : Icons.check,
                                                        color: data['Helal'] ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.green),
                                                    Gap(5),
                                                    Text(
                                                        'Helal : ' +
                                                            data['Helal']
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .black)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

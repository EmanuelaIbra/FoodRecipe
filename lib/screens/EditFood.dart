import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrecipe/screens/HomePage.dart';
import 'package:image_picker/image_picker.dart';

class EditFood extends StatefulWidget {
  const EditFood({
    Key? key,
    required this.document,
    required this.id,
  }) : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  late TextEditingController _namecontroller;
  late TextEditingController _recipecontroller;
  late String image2;
  XFile? image;
  String? imageUrl;
  XFile? imageTemp;
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    try {
      File file = File(imageFile.path);
      String fileName = file.path.split('/').last;
      Reference reference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
      );
      if (image == null) return;
      final imageTemp = XFile(image!.path);
      print("olduuu");
      String? imageUrl = await uploadImageToFirebase(imageTemp);
      setState(() => this.imageUrl = imageUrl);
      print("gfd");
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String name =
        widget.document['name'] == null ? 'My Recipe' : widget.document['name'];
    _namecontroller = TextEditingController(text: name);
    _recipecontroller = TextEditingController(text: widget.document['recipe']);
    imageUrl = widget.document["imageUrl"];
    image2 = imageUrl ??
        'https://www.codecheck.info/news/bilder/Hauptbild-650x371-1-7100.jpeg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white54,
            image: DecorationImage(
                image: AssetImage("assets/1.png"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.black,
                        size: 28,
                      )),
                  Icon(
                    Icons.restaurant_menu,
                    color: Colors.black,
                    size: 28,
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Food")
                          .doc(widget.id)
                          .delete()
                          .then((value) => {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst),
                              });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        label(" Food Image"),
                        IconButton(
                            color: Colors.black,
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 25,
                            ),
                            onPressed: () {
                              pickImage();
                            }),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildImage(),
                    label(" Food Name"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: 20),
                    label(" Recipe"),
                    SizedBox(
                      height: 12,
                    ),
                    Recipe(),
                    SizedBox(
                      height: 40,
                    ),
                    button(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        await FirebaseFirestore.instance
            .collection("Food")
            .doc(widget.id)
            .update({
          "name": _namecontroller.text,
          "recipe": _recipecontroller.text,
          "imageUrl": imageUrl,
        });
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Edit Food",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "Alkatra"),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (image2 == null) {
      return Text("No image selected");
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Image.network(image2),
      );
    }
  }

  Widget Recipe() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white54,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _recipecontroller,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Food Recipe",
          hintStyle: TextStyle(color: Colors.black, fontSize: 15),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white54,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ], // changes position of shadow
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _namecontroller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Food Name",
          hintStyle: TextStyle(color: Colors.black, fontSize: 15),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          fontFamily: "Alkatra",
          letterSpacing: 0.2),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/screens/EditFood.dart';
import 'package:foodrecipe/screens/HomePage.dart';

class ViewRecipe extends StatefulWidget {
  const ViewRecipe({
    Key? key,
    required this.document,
    required this.id,
  }) : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  late String label1;
  late String recipe1;
  late String image1;
  @override
  void initState() {
    super.initState();
    label1 = widget.document["name"];
    recipe1 = widget.document['recipe'];
    image1 = widget.document["imageUrl"] == null
        ? 'https://www.codecheck.info/news/bilder/Hauptbild-650x371-1-7100.jpeg'
        : widget.document["imageUrl"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white54),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditFood(
                                      document: widget.document,
                                      id: widget.id,
                                    )));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 28,
                      )),
                ],
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.orange.shade200,
                      Colors.white
                    ]),
                  ),
                  child: Image(
                    image: NetworkImage(image1),
                    fit: BoxFit.contain,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    label(label1),
                    SizedBox(height: 20),
                    recipe(recipe1),
                  ],
                ),
              ),
            ],
          ),
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
          fontFamily: "Alkatra",
          fontSize: 38,
          letterSpacing: 1),
    );
  }

  Widget recipe(String recipe) {
    return Text(
      recipe,
      style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          letterSpacing: 1,
          fontFamily: "Alkatra"),
    );
  }
}

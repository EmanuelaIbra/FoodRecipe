import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/models/recipe.api.dart';
import 'package:foodrecipe/screens/AddFood.dart';
import 'package:foodrecipe/screens/ViewRecipe.dart';
import 'package:foodrecipe/screens/widgets/recipe_card.dart';
import '../models/recipe.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Food").snapshots();
  List<String> _dismissedItems = [];
  @override
  void deleteCard(String id) async {
    FirebaseFirestore.instance.collection('Food').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(
                width: 10,
              ),
              Text(
                "Food Recipe",
                style: TextStyle(fontSize: 22, fontFamily: "Alkatra"),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.black,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => AddFood()));
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xffff7043),
                        Color(0xffffcc80),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Colors.black,
              ),
              label: 'Settings')
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs!.length,
                itemBuilder: (context, index) {
                  late Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    onDismissed: (direction) {
                      setState(() {
                        _dismissedItems.add(snapshot.data!.docs[index].id);
                      });
                      deleteCard(snapshot.data!.docs[index].id);
                    },
                    child: _dismissedItems
                            .contains(snapshot.data!.docs[index].id)
                        ? SizedBox()
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => ViewRecipe(
                                            document: document,
                                            id: snapshot.data!.docs[index].id,
                                          )));
                            },
                            child: RecipeCard(
                              title: document["name"] == null
                                  ? "My Recipe"
                                  : document["name"],
                              thumbnailUrl: document["imageUrl"] == null
                                  ? 'https://www.codecheck.info/news/bilder/Hauptbild-650x371-1-7100.jpeg'
                                  : document["imageUrl"],
                              id: snapshot.data!.docs[index].id,
                            ),
                          ),
                  );
                });
          }),
    );
  }
}

import 'package:foodrecipe/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeApi {
  /*const options = {
    method: 'GET',
    url: 'https://yummly2.p.rapidapi.com/feeds/list',
    params: {limit: '24', start: '0'},
    headers: {
      'X-RapidAPI-Key': '16047142bemshe0c608ca2391e64p110ee2jsnb4354dc89568',
      'X-RapidAPI-Host': 'yummly2.p.rapidapi.com'
    }
  };*/
  static Future<List<Recipe>?> getRecipe() async {
    var uri = Uri.https(
        "yummly2.p.rapidapi.com", "/feeds/list", {"limit": "24", "start": "0"});

    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': '16047142bemshe0c608ca2391e64p110ee2jsnb4354dc89568',
      'X-RapidAPI-Host': 'yummly2.p.rapidapi.com',
      'useQueryString': 'true'
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes');
    }
    Map data = jsonDecode(response.body);
    List<dynamic> temp = [];
    if (data["feed"] != null) {
      for (var i in data["feed"]) {
        if (i['type'] == "single recipe") temp.add(i['content']['details']);
        //_temp.add(i["content"]["details"]);
      }
      return Recipe.recipesFromSnapshot(temp);
    } else {
      return null;
    }
  }
}

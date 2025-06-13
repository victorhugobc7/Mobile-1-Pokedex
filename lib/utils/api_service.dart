import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_post.dart';

enum HttpVerb { get, post, put, delete }
List<dynamic> users = [];

class ApiResponse<Pokemon> {

}

class ApiService {

}

void fetchPokemon(int offset) async{
  print("Fetch pokemon called!");
  String url = 'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=20';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
  users = json['results'];
  print("it worked!!!!");
  print(users[0]['url']);
  for(String element in users){
    print(element[]);
  }
}
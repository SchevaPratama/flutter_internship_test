import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/character_model.dart';

class CharacterService {
  final http.Client client;

  CharacterService({required this.client});
  static Future<List<Character>> fetchCharacters() async {
    final response =
        await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<List<Character>> fetchCharactersTest() async {
    final response =
        await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  static List<Character> filterCharacters(
      List<Character> allCharacters, String query) {
    query = query.toLowerCase();
    return allCharacters
        .where((character) =>
            character.name.toLowerCase().contains(query) ||
            character.species.toLowerCase().contains(query) ||
            character.gender.toLowerCase().contains(query) ||
            character.origin.toString().toLowerCase().contains(query) ||
            character.location.toString().toLowerCase().contains(query))
        .toList();
  }
}

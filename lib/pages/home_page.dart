import 'package:flutter/material.dart';
import 'package:rick_morty/pages/search_page.dart';
import '../model/character_model.dart';
import '../services/character_service.dart';
import '../pages/detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Character> characters;
  late List<Character> filteredCharacters = [];

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      characters = await CharacterService.fetchCharacters();
      filteredCharacters = List.from(characters);
      setState(() {}); // Rebuild the UI with the fetched data
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void _navigateToDetailPage(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CharacterDetailPage(character: character)),
    );
  }

  void _navigateToSearchPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchPage(
                allCharacters: characters,
                initialResults: filteredCharacters,
              )),
    );

    if (result != null && result is List<Character>) {
      setState(() {
        filteredCharacters = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick and Morty Characters'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _navigateToSearchPage,
          ),
        ],
      ),
      body: filteredCharacters.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredCharacters.length,
              itemBuilder: (context, index) {
                final character = filteredCharacters[index];
                return GestureDetector(
                  onTap: () => _navigateToDetailPage(character),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(character.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            character.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No matching characters',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}

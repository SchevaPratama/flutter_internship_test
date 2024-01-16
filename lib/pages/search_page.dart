import 'package:flutter/material.dart';
import 'package:rick_morty/pages/detail_page.dart';
import '../model/character_model.dart';
import '../services/character_service.dart';

class SearchPage extends StatefulWidget {
  final List<Character> allCharacters;
  final List<Character> initialResults;

  SearchPage({required this.allCharacters, required this.initialResults});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  late List<Character> filteredCharacters;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredCharacters = List.from(widget.initialResults);
  }

  void _navigateToDetailPage(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CharacterDetailPage(character: character)),
    );
  }

  void _performSearch(String query) {
    final filteredResults =
        CharacterService.filterCharacters(widget.allCharacters, query);
    setState(() {
      filteredCharacters = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Characters'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                labelText:
                    'Search by name, species, gender, origin, or location',
              ),
            ),
          ),
          Expanded(
            child: filteredCharacters.isNotEmpty
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }
}

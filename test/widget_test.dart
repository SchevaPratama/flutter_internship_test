import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchData(http.Client client) async {
  final response = await client.get(Uri.parse('/api/character'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load data');
  }
}

void main() {
  testWidgets('Fetch and display characters', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final widget = TestWidget(
        fetchData: () => fetchData(MockClient((request) async {
              return http.Response(
                  json.encode({
                    'results': [
                      {'name': 'Rick Sanchez'},
                      {'name': 'Morty Smith'}
                    ]
                  }),
                  200);
            })));

    await tester.pump();

    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Morty Smith'), findsOneWidget);
  });

  test('Fetch data and check length', () async {
    final client = MockClient((request) async {
      return http.Response(
          json.encode({
            'results': [
              {'name': 'Rick Sanchez'},
              {'name': 'Morty Smith'}
            ]
          }),
          200);
    });

    final data = await fetchData(client);

    expect(data, isNotNull);
    expect(data, isNotEmpty);
  });

  test('Fetch data and check specific character', () async {
    final client = MockClient((request) async {
      return http.Response(
          json.encode({
            'results': [
              {'name': 'Rick Sanchez'},
              {'name': 'Morty Smith'}
            ]
          }),
          200);
    });

    final data = await fetchData(client);

    final character = data.firstWhere(
        (character) => character['name'] == 'Rick Sanchez',
        orElse: () => throw Exception('Failed to load data'));
    expect(character, isNotNull);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TestWidget(fetchData: () => fetchData(http.Client())),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchData;

  TestWidget({required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final characters = snapshot.data;
          return ListView.builder(
            itemCount: characters!.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return ListTile(
                title: Text(character['name']),
              );
            },
          );
        }
      },
    );
  }
}

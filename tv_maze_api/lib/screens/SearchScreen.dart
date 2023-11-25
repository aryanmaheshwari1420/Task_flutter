import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tv_maze_api/screens/DetailsScreen.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for a movie',
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                searchMovies(_searchController.text);
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailsScreen(movie: searchResults[index]),
                  ),
                );
              },
              leading: Image.network(
                searchResults[index]['show']['image']['medium'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(searchResults[index]['show']['name']),
              subtitle: Text(searchResults[index]['show']['summary']),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
          currentIndex:
              1, 
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context); 
            }
          },
        ));
  }

  Future<void> searchMovies(String query) async {
    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    final response =
        await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    }
  }
}

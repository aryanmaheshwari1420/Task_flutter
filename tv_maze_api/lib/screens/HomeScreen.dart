import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tv_maze_api/screens/DetailsScreen.dart';
import 'package:tv_maze_api/screens/SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> sanitizedMovies = [];

      for (var movie in decodedResponse) {
        final sanitizedMovie = {
          'show': {
            'name': movie['show']?['name'] ?? 'Name not available',
            'summary': movie['show']?['summary'] ?? 'Summary not available',
            'image': {
              'medium': movie['show']?['image']?['medium'] ?? 'https://static.tvmaze.com/uploads/images/medium_portrait/425/1064746.jpg',
            },
          },
        };

        sanitizedMovies.add(sanitizedMovie);
      }

      setState(() {
        movies = sanitizedMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(movie: movies[index]),
                ),
              );
            },
            leading: Container(
              width: 50,
              height: 50,
              child: Image.network(
                movies[index]['show']['image']['medium'] ,
                fit: BoxFit.fill, 
              ),
            ),
            title: Text(movies[index]['show']['name']),
            subtitle: Text(
              removeHtmlTags(
                  movies[index]['show']['summary'] ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          }
        },
      ),
    );
  }

  String removeHtmlTags(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<p[^>]*>'), '')
        .replaceAll(RegExp(r'</p>'), '')
        .replaceAll(RegExp(r'<b[^>]*>'), '')
        .replaceAll(RegExp(r'</b>'), '');
  }
}

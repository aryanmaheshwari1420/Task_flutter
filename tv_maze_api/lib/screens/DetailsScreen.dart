import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    print("Movie data : $movie");
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              movie['show']['image']['original'] ??
                  movie['show']['image']['medium'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // color: Colors.yellow,
                child: Text(
                  "Name: ${movie['show']?['name'] ?? 'Not available'}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 103, 99, 99)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  // color: Colors.red,
                  child: Text(
                "Summary: ${removeHtmlTags(movie['show']?['summary'])})",
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 85, 81, 81),
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     // color: Colors.yellow,
            //     child: Text(
            //             movie['show']['url'],
            //       style: TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: Color.fromARGB(255, 103, 99, 99)),
            //     ),
            //   ),
            // ),
          ],
        ),
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

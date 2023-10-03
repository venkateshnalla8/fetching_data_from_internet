import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Album>> futureAlbumList;

  @override
  void initState() {
    super.initState();
    futureAlbumList = fetchAlbums();
  }

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Album> albums = data.map((json) => Album.fromJson(json)).toList();
      return albums;
    } else {
      throw Exception('Failed to load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Network Data"),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbumList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data available');
              } else {
                List<Album> albums = snapshot.data!;
                return ListView.builder(
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(albums[index].title),
                      subtitle: Text('User ID: ${albums[index].userId}, ID: ${albums[index].id}'),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}


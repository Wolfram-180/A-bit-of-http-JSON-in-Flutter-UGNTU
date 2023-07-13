import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(int parse) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$parse'));
  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
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

Future<Post> fetchPost(int parse) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$parse'));
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();

  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String _appTitle = 'Fetch Posts Data Example';
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_appTitle),
        ),
        body: ListView(
          children: [
            Stack(
              alignment: const Alignment(1.0, 1.0),
              children: [
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: 'Enter Post ID...'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  child: const Icon(Icons.clear),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                futurePost = fetchPost(int.parse(_controller.text));
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _controller.clear();
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              child: const Text('Get Post', style: TextStyle(fontSize: 20)),
            ),
            Column(
              children: [
                Center(
                  child: FutureBuilder<Post>(
                    future: futurePost,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            const Text('Post tile:'),
                            Text(snapshot.data!.title),
                            const Divider(),
                            const Text('Post body:'),
                            Text(snapshot.data!.body),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

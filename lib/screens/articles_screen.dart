import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/main.dart';
import 'package:news_app/screens/news_screen.dart';
import 'package:news_app/secrets/secrets.dart';

class MyAppCreateState extends State<MyApp> {
  bool isDark = false;
  List<dynamic> articles = [];
  Error? _error;

  Future<void> getNews(query) async {
    var url = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$API_KEY');
    if (query != "") {
      url = Uri.parse('https://newsapi.org/v2/everything?q=$query&sortBy=popularity&apiKey=$API_KEY');
    }
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'];
          _error = null;
        });
      } else {
        setState(() {
          articles = [];
          _error = "Failed to load news" as Error?;
        });
      }
    } catch (e) {
      setState(() {
          articles = [];
          _error = e as Error?;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    getNews("");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text("News App")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    getNews(value);
                  }
                },
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  Tooltip(
                    message: 'Change brightness mode',
                    child: IconButton(
                      isSelected: isDark,
                      onPressed: () {
                        setState(() {
                          isDark = !isDark;
                        });
                      },
                      icon: const Icon(Icons.wb_sunny_outlined),
                      selectedIcon: const Icon(Icons.brightness_2_outlined),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: (_error == null) ?
                ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ListTile(
                    leading: article['urlToImage'] != null ? 
                      CachedNetworkImage(
                        imageUrl: article['urlToImage'],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ) : Icon(
                        Icons.image,
                        size: 50,
                      ),
                    title: Text(article['title'] ?? "No Title"),
                    subtitle: Text(article['description'] ?? "No description"),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => NewsScreen(article: article)
                        )
                      );
                    },
                  );
                },
              ) : Text(
                "While fetching news error occured $_error", 
                style: Theme.of(context).textTheme.titleMedium,
              )
            )
          ],
        ),
      )
    );
  }
}

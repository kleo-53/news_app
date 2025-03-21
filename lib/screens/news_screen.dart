import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  
  const NewsScreen({super.key, required this.article});
  
  // Future<String> getContent(url) async {
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return data;
  //     } else {
  //       return article['content'];
  //     }
  //   } catch (e) {
  //     return article['content'];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'])
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              CachedNetworkImage(
                imageUrl: article['urlToImage'],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              article['title'] ?? "No Title", 
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (article['url'] != null)
            Text(
              article['content'],
              // getContent(article['url']) as String,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      )
    );
  }
}
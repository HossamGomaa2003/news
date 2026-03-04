import 'package:flutter/material.dart';
import 'package:news/Widgets/news_drawer.dart';
import 'package:provider/provider.dart';
import '../models/news_response.dart';
import '../theme_provider.dart';

class NewsScreen extends StatelessWidget {
  final Articles? article;

  const NewsScreen({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;
    ThemeData theme = Theme.of(context);

    String sourceName = article?.source?.name ?? "News Details";
    String title = article?.title ?? "No Title Available";
    String description = article?.description ?? "";
    String author = article?.author ?? "Unknown Author";
    String publishedAt = article?.publishedAt?.split('T')[0] ?? "Unknown Date";
    String imageUrl = article?.urlToImage ?? "";
    String content = article?.content ?? "No content available for this article.";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: NewsDrawer(
        onCategoryClick: () {
          Navigator.pop(context);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        title: Text(
          sourceName,
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 12),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("By ", style: TextStyle(color: isDark ? Colors.white60 : Colors.grey)),
                  Expanded(
                    child: Text(
                      author,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                publishedAt,
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: Icon(Icons.image, color: Colors.white, size: 50),
                        ),
                      )
                    : Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Icon(Icons.image, color: Colors.white, size: 50),
                      ),
              ),
              SizedBox(height: 24),
              Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

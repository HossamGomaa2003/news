import 'package:flutter/material.dart';
import 'package:news/Screens/News_Screen.dart';
import 'package:news/Screens/Search_Screen.dart';
import 'package:news/Widgets/news_drawer.dart';
import 'package:news/core/api_manager.dart';
import 'package:news/models/sources_response.dart';
import 'package:news/models/news_response.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return FutureBuilder<SourcesResponse?>(
      future: ApiManager.getSources(categoryName.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(categoryName)),
            drawer: NewsDrawer(
              onCategoryClick: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            body: Center(
                child: CircularProgressIndicator(
                    color: theme.textTheme.bodyLarge?.color)),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(categoryName)),
            drawer: NewsDrawer(
              onCategoryClick: () {
                Navigator.pop(context);
              },
            ),
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
            ),
          );
        }

        var sources = snapshot.data?.sources ?? [];

        if (sources.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(categoryName)),
            drawer: NewsDrawer(
              onCategoryClick: () {
                Navigator.pop(context);
              },
            ),
            body: Center(
              child: Text(
                "No Sources Found",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
            ),
          );
        }

        return DefaultTabController(
          length: sources.length,
          child: Scaffold(
            drawer: NewsDrawer(
              onCategoryClick: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            appBar: AppBar(
              title: Text(categoryName),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.search, size: 30),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.symmetric(horizontal: 8),
                indicatorColor: theme.textTheme.bodyLarge?.color,
                indicatorWeight: 3,
                labelColor: theme.textTheme.bodyLarge?.color,
                unselectedLabelColor: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: sources.map((source) => Tab(text: source.name)).toList(),
              ),
            ),
            body: TabBarView(
              children: sources
                  .map((source) => NewsListWidget(sourceId: source.id ?? ""))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class NewsListWidget extends StatelessWidget {
  final String sourceId;
  const NewsListWidget({super.key, required this.sourceId});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return FutureBuilder<NewsResponse?>(
      future: ApiManager.getNewsData(sourceId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                  color: theme.textTheme.bodyLarge?.color));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          );
        }

        var articles = snapshot.data?.articles ?? [];

        if (articles.isEmpty) {
          return Center(
            child: Text(
              "No News Found",
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          separatorBuilder: (context, index) => SizedBox(height: 20),
          itemBuilder: (context, index) {
            return NewsCard(article: articles[index]);
          },
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final Articles article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _showNewsDetails(context, article),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.textTheme.bodyLarge?.color ?? Colors.grey, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                article.urlToImage ?? "",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 200,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: theme.textTheme.bodyLarge?.color)),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/general.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'By: ${article.author ?? article.source?.name ?? "Unknown"}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontSize: 14),
                        ),
                      ),
                      Text(
                        _formatDate(article.publishedAt),
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return "";
    }
  }

  void _showNewsDetails(BuildContext context, Articles article) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color bgColor = isDark ? Colors.white : const Color(0xFF171717);
    Color textColor = isDark ? Colors.black : Colors.white;
    Color buttonBg = isDark ? Colors.black : Colors.white;
    Color buttonText = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  article.urlToImage ?? "",
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/general.png',
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                article.description ?? article.content ?? "No description available",
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsScreen(article: article),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBg,
                  foregroundColor: buttonText,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Full Article',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'Category_Screen.dart';
import '../Widgets/news_drawer.dart';
import 'Search_Screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const NewsDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Here is some News For You',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCategoryCard(
                    context,
                    'General',
                    'assets/images/general.png',
                    false, // Start with Right
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Business',
                    'assets/images/busniess.png',
                    true, // Left
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Sports',
                    'assets/images/sport.png',
                    false, // Right
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Health',
                    'assets/images/helth.png',
                    true, // Left
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Science',
                    'assets/images/science.png',
                    false, // Right
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Technology',
                    'assets/images/technology.png',
                    true, // Left
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context,
                    'Entertainment',
                    'assets/images/entertainment.png',
                    false, // Right
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, String imagePath, bool isLeft) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(categoryName: title),
          ),
        );
      },
      child: Container(
        height: 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Image - Background
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            // Semi-transparent overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            // Title
            Positioned(
              top: 40,
              left: isLeft ? 30 : null,
              right: isLeft ? null : 30,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
            // View All Button
            Positioned(
              bottom: 20,
              left: isLeft ? 20 : null,
              right: isLeft ? null : 20,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

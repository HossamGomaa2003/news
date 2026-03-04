import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class NewsDrawer extends StatelessWidget {
  final Function()? onCategoryClick;
  const NewsDrawer({super.key, this.onCategoryClick});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Drawer(
      backgroundColor: isDark ? Color(0xFF171717) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            color: isDark ? Colors.white : Colors.black,
            alignment: Alignment.center,
            child: Text(
              'News App',
              style: TextStyle(
                color: isDark ? Colors.black : Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
              ),
            ),
          ),
          SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              if (onCategoryClick != null) {
                onCategoryClick!();
              }
            },
            child: _buildSectionHeader(context, Icons.home_outlined, 'Go To Home', isDark),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: isDark ? Colors.white : Colors.black, thickness: 1),
          ),

          _buildSectionHeader(context, Icons.palette_outlined, 'Them', isDark),
          _buildThemeDropdown(context, themeProvider, isDark),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: isDark ? Colors.white : Colors.black, thickness: 1),
          ),

          _buildSectionHeader(context, Icons.public, 'Language', isDark),
          _buildLanguageDropdown(context, isDark),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, IconData icon, String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: isDark ? Colors.white : Colors.black, size: 30),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeDropdown(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            dropdownColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
            icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : Colors.black, size: 35),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black, 
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
            onChanged: (ThemeMode? newValue) {
              if (newValue != null) {
                themeProvider.changeTheme(newValue);
              }
            },
            items: [
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: 'English',
            dropdownColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
            icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : Colors.black, size: 35),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black, 
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
            onChanged: (String? newValue) {},
            items: [
              DropdownMenuItem(
                value: 'English',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'Arabic',
                child: Text('Arabic'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

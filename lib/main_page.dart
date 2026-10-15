import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class Shot {
  final String title;
  final String category;
  final IconData icon;
  final Color color;

  Shot(this.title, this.category, this.icon, this.color);
}

final List<Shot> shots = [
  Shot('Funny Meme', 'Memes', Icons.emoji_emotions, Colors.orange),
  Shot('Chat Screenshot', 'Chats', Icons.chat, Colors.green),
];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final titles = ['My Screenshots', 'Categories', 'Search', 'Settings'];

  Widget homeScreen() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: shots.length,
      itemBuilder: (context, i) {
        final shot = shots[i];
        return Container(
          decoration: BoxDecoration(
            color: shot.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(shot.icon, size: 48, color: shot.color),
              const SizedBox(height: 8),
              Text(shot.title),
              Text(shot.category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  Widget categoriesScreen() {
    final categories = shots.map((s) => s.category).toSet().toList();
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final count = shots.where((s) => s.category == categories[i]).length;
        return ListTile(
          leading: const Icon(Icons.folder, color: Colors.indigo),
          title: Text(categories[i]),
          trailing: Text('$count'),
        );
      },
    );
  }

  Widget currentScreen() {
    if (index == 0) return homeScreen();
    if (index == 1) return categoriesScreen();
    if (index == 2) return const SearchScreen();
    return const SettingsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => index = 2),
          ),
        ],
      ),
      body: currentScreen(),
      floatingActionButton: index == 0
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            shots.add(Shot('New Screenshot ${shots.length + 1}',
                'Memes', Icons.image, Colors.cyan));
          });
        },
        child: const Icon(Icons.add_a_photo),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
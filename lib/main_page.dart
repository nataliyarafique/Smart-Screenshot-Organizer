import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class Shot {
  final String path;
  String category;

  Shot(this.path, this.category);

  String get name => path.split(RegExp(r'[\\/]')).last;
}

final List<Shot> shots = [];
final List<String> categories = ['Chats', 'Memes', 'Bills', 'Notes', 'Other'];

Future<String?> pickCategory(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Category chunein'),
      children: categories
          .map((c) => SimpleDialogOption(
        onPressed: () => Navigator.pop(ctx, c),
        child: Text(c),
      ))
          .toList(),
    ),
  );
}

Future<void> showShotDialog(BuildContext context, Shot s) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Image.file(File(s.path)),
          ),
          const SizedBox(height: 12),
          Text('Category: ${s.category}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final c = await pickCategory(ctx);
            if (c != null) s.category = c;
            if (ctx.mounted) Navigator.pop(ctx);
          },
          child: const Text('Category badlein'),
        ),
        TextButton(
          onPressed: () {
            shots.remove(s);
            Navigator.pop(ctx);
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class ShotGrid extends StatelessWidget {
  final List<Shot> items;
  final VoidCallback onChanged;

  const ShotGrid({super.key, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Abhi koi screenshot nahi'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final s = items[i];
        return GestureDetector(
          onTap: () async {
            await showShotDialog(context, s);
            onChanged();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(s.path), fit: BoxFit.cover),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      s.category,
                      textAlign: TextAlign.center,
                      style:
                      const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final items = shots.where((s) => s.category == widget.category).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ShotGrid(items: items, onChanged: () => setState(() {})),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final titles = ['My Screenshots', 'Categories', 'Search', 'Settings'];

  Future<void> addShots() async {
    final files = await ImagePicker().pickMultiImage();
    if (files.isEmpty || !mounted) return;
    final cat = await pickCategory(context);
    if (cat == null) return;
    setState(() {
      for (final f in files) {
        shots.add(Shot(f.path, cat));
      }
    });
  }

  Widget categoriesScreen() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final c = categories[i];
        final count = shots.where((s) => s.category == c).length;
        return ListTile(
          leading: const Icon(Icons.folder, color: Colors.indigo),
          title: Text(c),
          trailing: Text('$count'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CategoryPage(category: c)),
            );
            setState(() {});
          },
        );
      },
    );
  }

  Widget currentScreen() {
    if (index == 0) {
      return ShotGrid(items: shots, onChanged: () => setState(() {}));
    }
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
        onPressed: addShots,
        child: const Icon(Icons.add_photo_alternate),
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
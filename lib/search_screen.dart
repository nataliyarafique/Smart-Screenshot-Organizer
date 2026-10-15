import 'package:flutter/material.dart';
import 'main_page.dart';

Future<void> showShotDialog(BuildContext context, Shot s) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          Icon(s.icon, color: s.color),
          const SizedBox(width: 8),
          Expanded(child: Text(s.title)),
        ],
      ),
      content: Text('Category: ${s.category}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final results = shots
        .where((s) =>
    s.title.toLowerCase().contains(query.toLowerCase()) ||
        s.category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Screenshot ya category dhundo...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (v) => setState(() => query = v),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('Kuch nahi mila'))
              : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, i) {
              final s = results[i];
              return ListTile(
                leading: Icon(s.icon, color: s.color, size: 32),
                title: Text(s.title),
                subtitle: Text(s.category),
                trailing:
                const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  await showShotDialog(context, s);
                  setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
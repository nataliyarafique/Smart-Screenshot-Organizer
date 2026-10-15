import 'dart:io';
import 'package:flutter/material.dart';
import 'main_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final results = shots
        .where((s) =>
    s.name.toLowerCase().contains(q) ||
        s.category.toLowerCase().contains(q))
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
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(File(s.path),
                      width: 48, height: 48, fit: BoxFit.cover),
                ),
                title: Text(s.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
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
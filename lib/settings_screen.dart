import 'package:flutter/material.dart';
import 'main_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool autoOrganize = true;
  bool notifications = false;

  Future<void> addCategory() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nayi category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category ka naam'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && !categories.contains(name)) {
      setState(() => categories.add(name));
    }
  }

  Future<void> clearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sab clear karein?'),
        content: const Text(
            'App se saare screenshots hat jayenge (gallery se delete nahi honge).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Nahi'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Haan'),
          ),
        ],
      ),
    );
    if (ok == true) setState(() => shots.clear());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.auto_awesome),
          title: const Text('Auto Organize'),
          subtitle: const Text('Naye screenshots khud sort hon'),
          value: autoOrganize,
          onChanged: (v) => setState(() => autoOrganize = v),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          value: notifications,
          onChanged: (v) => setState(() => notifications = v),
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Total screenshots'),
          trailing: Text('${shots.length}'),
        ),
        ListTile(
          leading: const Icon(Icons.create_new_folder),
          title: const Text('Nayi category banayein'),
          onTap: addCategory,
        ),
        ListTile(
          leading: const Icon(Icons.delete_sweep, color: Colors.red),
          title: const Text('Sab screenshots clear karein'),
          onTap: clearAll,
        ),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
          subtitle: Text('Smart Screenshot Organizer v1.0'),
        ),
      ],
    );
  }
}
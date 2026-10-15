import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool autoOrganize = true;
  bool notifications = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.auto_awesome),
          title: const Text('Auto Organize'),
          subtitle: const Text('Naye screenshots khud sort hon'),
          value: autoOrganize,git commit -m "Updated screens"
          onChanged: (v) => setState(() => autoOrganize = v),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          value: notifications,
          onChanged: (v) => setState(() => notifications = v),
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
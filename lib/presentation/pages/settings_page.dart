import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = true;
  bool notifications = true;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Text(
          "Settings",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          value: darkMode,
          onChanged: (v) => setState(() => darkMode = v),
          title: const Text("Dark Mode"),
          subtitle: const Text("Toggle application theme"),
        ),
        SwitchListTile(
          value: notifications,
          onChanged: (v) => setState(() => notifications = v),
          title: const Text("Notifications"),
          subtitle: const Text("Enable or disable system notifications"),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.save),
          label: const Text("Save Changes"),
        ),
      ],
    );
  }
}

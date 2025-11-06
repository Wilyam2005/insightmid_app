// lib/features/insightmind/presentation/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:insightmid_app/theme_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.grey.shade900.withOpacity(0.3), // Gradasi abu-abu
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Use the global theme manager so toggling affects the whole app.
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, mode, child) {
                return SwitchListTile(
                  title: const Text('Mode Gelap'),
                  value: mode == ThemeMode.dark,
                  onChanged: (bool value) {
                    // Toggle the global theme. The app listens to themeModeNotifier.
                    toggleThemeMode();
                    // inform user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mode Gelap ${value ? 'Aktif' : 'Nonaktif'}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    setState(() {}); // rebuild to reflect new switch state
                  },
                  secondary: const Icon(Icons.dark_mode_outlined),
                );
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Aktifkan Notifikasi Harian'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                  // TODO: Implementasi logika set/cancel notifikasi
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifikasi ${value ? 'Aktif' : 'Nonaktif'}')),
                  );
                });
              },
              secondary: const Icon(Icons.notifications_active_outlined),
            ),
             const Divider(),
             ListTile(
               leading: const Icon(Icons.info_outline),
               title: const Text('Tentang Aplikasi'),
               onTap: (){
                  // Tampilkan dialog About
                  showAboutDialog(
                    context: context,
                    applicationName: 'InsightMind',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025 InsightMind Dev',
                    children: <Widget>[
                       const Padding(
                         padding: EdgeInsets.only(top: 15),
                         child: Text('Aplikasi screening kesehatan mental sederhana.')
                       )
                    ],
                  );
               },
             ),
             const Divider(),
             ListTile(
               leading: Icon(Icons.logout, color: Colors.red.shade400),
               title: Text('Keluar (Logout)', style: TextStyle(color: Colors.red.shade400)),
               onTap: (){
                 // TODO: Implementasi logika logout (jika ada Firebase Auth)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Logout belum diimplementasikan')),
                  );
               },
             ),
          ],
        ),
      ),
    );
  }
}

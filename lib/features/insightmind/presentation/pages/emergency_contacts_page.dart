// lib/features/insightmind/presentation/pages/emergency_contacts_page.dart

import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Uncomment jika ingin fitur telepon

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  // Contoh kontak darurat (bisa diambil dari database/API)
  final List<Map<String, String>> contacts = const [
    {'name': 'Layanan Kesehatan Jiwa Nasional', 'number': '119 ext 8'},
    {'name': 'Komunitas Peduli Skizofrenia Indonesia (KPSI)', 'number': '0811XXXXXX'}, // Ganti dengan nomor asli jika ada
    {'name': 'Hotline Kesehatan Mental XYZ', 'number': '0812XXXXXX'}, // Ganti
    {'name': 'Kontak Keluarga/Teman Dekat', 'number': '(Simpan di sini)'},
  ];

  /* // Fungsi untuk menelepon (membutuhkan url_launcher)
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''), // Hapus spasi
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Tampilkan error jika tidak bisa menelepon
       print('Could not launch $launchUri');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak Darurat'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.red.shade900.withOpacity(0.3), // Gradasi merah
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.redAccent),
                title: Text(contact['name']!),
                subtitle: Text(contact['number']!),
                // Uncomment trailing jika ingin tombol telepon
                /*
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () => _makePhoneCall(contact['number']!),
                ),
                */
                 onTap: () {
                    // Bisa ditambahkan aksi copy nomor telepon
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Menampilkan info: ${contact['name']}')),
                    );
                 }
              ),
            );
          },
        ),
      ),
    );
  }
}
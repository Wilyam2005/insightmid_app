// lib/features/insightmind/presentation/pages/education_page.dart

import 'package:flutter/material.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  // Contoh data artikel (bisa diambil dari database/API nanti)
  final List<Map<String, String>> articles = const [
    {'title': '5 Cara Efektif Mengelola Stres Sehari-hari', 'summary': 'Pelajari teknik sederhana untuk mengurangi stres...'},
    {'title': 'Pentingnya Tidur Berkualitas untuk Kesehatan Mental', 'summary': 'Mengapa tidur cukup sangat vital...'},
    {'title': 'Mengenal Teknik Mindfulness untuk Ketenangan', 'summary': 'Latihan dasar mindfulness yang bisa Anda coba...'},
    {'title': 'Kapan Sebaiknya Mencari Bantuan Profesional?', 'summary': 'Tanda-tanda Anda mungkin perlu konsultasi...'},
    {'title': 'Manfaat Olahraga Rutin bagi Mood Anda', 'summary': 'Bagaimana aktivitas fisik memengaruhi kondisi mental...'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Edukasi'),
      ),
      body: Container(
        // Tambahkan background gradasi agar konsisten
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.teal.shade900.withOpacity(0.3),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                title: Text(article['title']!),
                subtitle: Text(article['summary']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigasi ke halaman detail artikel
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Membuka: ${article['title']}')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
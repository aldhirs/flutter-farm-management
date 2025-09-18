import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mutations = [
      {
        "kandang": "Kandang Utama",
        "nomor": "MUT-2025-001",
        "tanggal": "18 Sep 2025",
        "status": "Selesai",
      },
      {
        "kandang": "Kandang B",
        "nomor": "MUT-2025-002",
        "tanggal": "17 Sep 2025",
        "status": "Proses",
      },
      {
        "kandang": "Kandang C",
        "nomor": "MUT-2025-003",
        "tanggal": "16 Sep 2025",
        "status": "Ditolak",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Mutasi"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mutations.length,
        itemBuilder: (context, index) {
          final item = mutations[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris 1: Nama kandang
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        item["kandang"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusChip(item["status"]!),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris 2: Nomor mutasi
                  Text(
                    "Nomor: ${item["nomor"]}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  // Baris 3: Tanggal mutasi
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item["tanggal"]!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case "Selesai":
        color = Colors.green;
        break;
      case "Proses":
        color = Colors.orange;
        break;
      case "Ditolak":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: CustomScrollView(
        slivers: [
          /// HEADER dengan gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            foregroundColor: Colors.black54,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF25AFCB),
                      AppColors.current.mint500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.pets, size: 40, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Ear Tag: 12345",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "RFID: RFID-908765",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          /// BODY CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// INFO CARD HORIZONTAL
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildInfoChip("Status", "Sehat", Colors.green),
                        _buildInfoChip("Bobot", "420 Kg", Colors.blue),
                        _buildInfoChip("Drafting", "12-09-2025", Colors.orange),
                        _buildInfoChip("Kandang", "A", Colors.purple),
                        _buildInfoChip("Pen", "7", Colors.teal),
                        _buildInfoChip("Kelamin", "Jantan", Colors.indigo),
                        _buildInfoChip("Grade", "A+", Colors.red),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ====== Detail Sapi (Vertical Card) ======
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Ear Tag", "ET-123456"),
                        _buildDetailRow("RFID", "RFID-90877"),
                        _buildDetailRow("Status", "Sehat"),
                        _buildDetailRow("Bobot Akhir", "350 kg"),
                        _buildDetailRow("Tanggal Drafting", "12 Sept 2025"),
                        _buildDetailRow("Kandang", "Kandang A"),
                        _buildDetailRow("Pen", "Pen 03"),
                        _buildDetailRow("Jenis Kelamin", "Jantan"),
                        _buildDetailRow("Grade", "A"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// RIWAYAT PERAWATAN
                  _buildSectionTitle("Riwayat Perawatan"),
                  _buildCardList([
                    {
                      "keterangan": "Vitamin",
                      "jenis": "Suplemen",
                      "tanggal": "01-09-2025",
                    },
                    {
                      "keterangan": "Vaksinasi",
                      "jenis": "Imunisasi",
                      "tanggal": "05-09-2025",
                    },
                  ], icon: Icons.health_and_safety),

                  const SizedBox(height: 24),

                  /// CATATAN MEDIS
                  _buildSectionTitle("Catatan Medis"),
                  _buildCardList([
                    {
                      "keterangan": "Demam ringan",
                      "jenis": "Infeksi",
                      "tanggal": "20-08-2025",
                    },
                    {
                      "keterangan": "Luka kecil",
                      "jenis": "Cedera",
                      "tanggal": "28-08-2025",
                    },
                  ], icon: Icons.note_alt),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// CHIP CARD HORIZONTAL
  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// LIST CARD FUTURISTIC
  Widget _buildCardList(
    List<Map<String, String>> items, {
    required IconData icon,
  }) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["keterangan"]!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["jenis"]!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["tanggal"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF5F7FA),
  //     appBar: AppBar(
  //       elevation: 0,
  //       backgroundColor: Colors.white,
  //       centerTitle: true,
  //       title: const Text(
  //         "Profil Sapi",
  //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
  //       ),
  //       iconTheme: const IconThemeData(color: Colors.black87),
  //     ),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           /// --- Info Utama Sapi ---
  //           Container(
  //             padding: const EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black12.withOpacity(0.05),
  //                   blurRadius: 8,
  //                   offset: const Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               children: [
  //                 CircleAvatar(
  //                   radius: 40,
  //                   backgroundColor: Colors.blue.shade100,
  //                   child: const Icon(Icons.pets, size: 40, color: Colors.blue),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 const Text(
  //                   "Ear Tag: 12345",
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const Divider(height: 24),
  //                 _buildInfoRow("RFID", "RFID-908765"),
  //                 _buildInfoRow("Status", "Sehat"),
  //                 _buildInfoRow("Bobot Akhir", "420 Kg"),
  //                 _buildInfoRow("Tanggal Drafting", "12-09-2025"),
  //                 _buildInfoRow("Kandang", "Kandang A"),
  //                 _buildInfoRow("Pen", "Pen 7"),
  //                 _buildInfoRow("Jenis Kelamin", "Jantan"),
  //                 _buildInfoRow("Grade Sapi", "A+"),
  //               ],
  //             ),
  //           ),

  //           /// HEADER PROFILE CARD
  //           Container(
  //             width: double.infinity,
  //             padding: const EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //               gradient: const LinearGradient(
  //                 colors: [Color(0xFF0066FF), Color(0xFF33CCFF)],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //               borderRadius: BorderRadius.circular(20),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.blue.withOpacity(0.2),
  //                   blurRadius: 10,
  //                   offset: const Offset(0, 6),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               children: [
  //                 const CircleAvatar(
  //                   radius: 40,
  //                   backgroundColor: Colors.white,
  //                   child: Icon(Icons.pets, size: 40, color: Colors.blue),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 const Text(
  //                   "Ear Tag: 12345",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 const Text(
  //                   "RFID: RFID-908765",
  //                   style: TextStyle(fontSize: 14, color: Colors.white70),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 Wrap(
  //                   alignment: WrapAlignment.center,
  //                   spacing: 16,
  //                   runSpacing: 12,
  //                   children: [
  //                     _buildChip("Status: Sehat"),
  //                     _buildChip("Bobot: 420 Kg"),
  //                     _buildChip("Drafting: 12-09-2025"),
  //                     _buildChip("Kandang: A"),
  //                     _buildChip("Pen: 7"),
  //                     _buildChip("Kelamin: Jantan"),
  //                     _buildChip("Grade: A+"),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),

  //           const SizedBox(height: 24),

  //           /// TREATMENT LIST
  //           _buildSectionTitle("Riwayat Perawatan"),
  //           _buildListCard([
  //             {
  //               "keterangan": "Vitamin",
  //               "jenis": "Suplemen",
  //               "tanggal": "01-09-2025",
  //             },
  //             {
  //               "keterangan": "Vaksinasi",
  //               "jenis": "Imunisasi",
  //               "tanggal": "05-09-2025",
  //             },
  //           ]),

  //           const SizedBox(height: 24),

  //           /// MEDICAL LIST
  //           _buildSectionTitle("Catatan Medis"),
  //           _buildListCard([
  //             {
  //               "keterangan": "Demam ringan",
  //               "jenis": "Infeksi",
  //               "tanggal": "20-08-2025",
  //             },
  //             {
  //               "keterangan": "Luka kecil",
  //               "jenis": "Cedera",
  //               "tanggal": "28-08-2025",
  //             },
  //           ]),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // /// --- CHIP STYLE INFO
  // Widget _buildChip(String text) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Text(
  //       text,
  //       style: const TextStyle(color: Colors.white, fontSize: 13),
  //     ),
  //   );
  // }

  // /// --- SECTION TITLE
  // Widget _buildSectionTitle(String title) {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: Text(
  //       title,
  //       style: const TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black87,
  //       ),
  //     ),
  //   );
  // }

  // /// --- LIST CARD
  // Widget _buildListCard(List<Map<String, String>> items) {
  //   return Column(
  //     children: items.map((item) {
  //       return Container(
  //         margin: const EdgeInsets.only(top: 12),
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black12.withOpacity(0.05),
  //               blurRadius: 8,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: Colors.blue.shade50,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: const Icon(
  //                 Icons.medical_services,
  //                 color: Colors.blue,
  //                 size: 28,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     item["keterangan"]!,
  //                     style: const TextStyle(
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     item["jenis"]!,
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.black54,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     item["tanggal"]!,
  //                     style: const TextStyle(fontSize: 12, color: Colors.grey),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  // /// --- Row Info Sapi ---
  // Widget _buildInfoRow(String title, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           title,
  //           style: const TextStyle(color: Colors.black54, fontSize: 14),
  //         ),
  //         Text(
  //           value,
  //           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
  //         ),
  //       ],
  //     ),
  //   );
  // }
// }

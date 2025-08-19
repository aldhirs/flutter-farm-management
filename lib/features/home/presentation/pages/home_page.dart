import 'package:farm_management/features/cattle/presentation/pages/rfid_input_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onLogout;

  const HomePage({Key? key, required this.onLogout}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RfidInputPage(),
  ];

  final List<String> _titles = [
    'Drafting',
    'Weighing',
  ];

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // close the drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: themeColor,
              ),
              margin: EdgeInsets.zero, // hilangkan margin bawaan
              padding: const EdgeInsets.all(16), // jarak isi ke tepi
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.agriculture, color: Colors.white, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'PT Agrisatwa\nJaya Kecana',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.rss_feed, color: themeColor),
              title: Text('Drafting', style: GoogleFonts.poppins()),
              onTap: () => _onDrawerItemTapped(0),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: Text('Logout', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                widget.onLogout();
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

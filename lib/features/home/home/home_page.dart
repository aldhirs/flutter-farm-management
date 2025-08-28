import 'package:auto_route/auto_route.dart';
import 'package:farm/features/home/home/widgets/quick_action_card.dart';
import 'package:farm/features/home/home/widgets/stat_card.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.neutral400,
      appBar: CommonAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        forceMaterialTransparency: false,
        title: Text(
          'Beranda',
          style: TextStyles.heading6().copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Stats Section
            const Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                StatCard(
                  title: "Drafting Total",
                  count: "120",
                  color: Colors.green,
                  icon: Icons.pets,
                ),
                StatCard(
                  title: "Rooms",
                  count: "12",
                  color: Colors.blue,
                  icon: Icons.meeting_room,
                ),
                StatCard(
                  title: "Available",
                  count: "5",
                  color: Colors.orange,
                  icon: Icons.check_circle,
                ),
                StatCard(
                  title: "Sales",
                  count: "30",
                  color: Colors.red,
                  icon: Icons.shopping_cart,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text("Jalan Pintas", style: TextStyles.heading6()),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.list_alt,
                    label: "Drafting",
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.sell,
                    label: "Sales",
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.barcode_reader,
                    label: "Gun Connect",
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Slideshow
            // CarouselSlider(
            //   options: CarouselOptions(
            //     height: 180, // min 60px, you can adjust
            //     autoPlay: true,
            //     enlargeCenterPage: true,
            //     viewportFraction: 1.0,
            //   ),
            //   items:
            //       [
            //         "https://picsum.photos/800/300",
            //         "https://picsum.photos/801/300",
            //         "https://picsum.photos/802/300",
            //       ].map((url) {
            //         return ClipRRect(
            //           borderRadius: BorderRadius.circular(12),
            //           child: Image.network(
            //             url,
            //             fit: BoxFit.cover,
            //             width: double.infinity,
            //           ),
            //         );
            //       }).toList(),
            // ),
          ],
        ),
      ),
    );
  }
}

// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'package:yansnet/subscription/widgets/profile_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> assetImagePaths = [
    'assets/images/post.jpg',
    'assets/images/test.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar().build(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espace pour compenser l'avatar qui déborde
          const SizedBox(height: 35),
          // Hauteur égale à la moitié du rayon de l'avatar + bordure

          // Section Informations de Profil
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // j'ai utilisé un Row pour placer le texte et l'icône côte à côte
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Pour espacer le texte et l'icône
                  children: [
                    const Text(
                      'Pixsellz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      // L'icône de menu est ici maintenant
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                      // Couleur noire
                      onPressed: () {
                        // Action quand on clique sur le menu
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '@pixsellz',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Digital Goodies Team - Web & Mobile UI/UX development; Graphics; Illustrations',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.link, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    const Text(
                      'pixsellz.io',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Promotion X2026',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      '217',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Following',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '118',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Followers',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF5D1225),
              labelColor: const Color(0xFF5D1225),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Posts'),
                Tab(text: 'Media'),
              ],
            ),
          ),
          // Contenu du Tab Bar (Grid d'Images)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(child: Text('Aucune publication')),
                GridView.builder(
                  padding: const EdgeInsets.all(4.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: assetImagePaths.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      assetImagePaths[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// lib/another_profile.dart
import 'package:flutter/material.dart';
import 'package:yansnet/subscription/widgets/profile_app_bar.dart';

class AnotherProfilePage extends StatefulWidget {
  const AnotherProfilePage({super.key});

  @override
  State<AnotherProfilePage> createState() => _AnotherProfilePageState();
}

class _AnotherProfilePageState extends State<AnotherProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> assetImagePaths = ['assets/images/test.jpg'];

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

          // Section Informations de Profil
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texte du nom de profil (Pixsellz)
                const Text(
                  'Passi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '@angelpassi',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dev Team - Web & Mobile UI/UX development; Graphics; Illustrations',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),

                const SizedBox(height: 12),
                // Espacement après la description
                const Row(
                  children: [
                    Icon(Icons.link, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'pixsellz.io',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Promotion X2026',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      '217',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Following',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '118',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Followers',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Espace avant les boutons

                // Boutons Follow et Message
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action pour le bouton Follow
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          // Couleur de fond gris clair
                          foregroundColor: Colors.black,
                          // Couleur du texte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Bords arrondis
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0, // Pas d'ombre
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Espacement entre les boutons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action pour le bouton Message
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          // Couleur de fond gris clair
                          foregroundColor: Colors.black,
                          // Couleur du texte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Bords arrondis
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0, // Pas d'ombre
                        ),
                        child: const Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Espace après les boutons et avant le TabBar
              ],
            ),
          ),
          // Tab Bar
          ColoredBox(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF5D1225),
              labelColor: const Color(0xFF5D1225),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Tweets'),
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
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
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

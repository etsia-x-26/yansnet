// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/profile/view/popup.dart';
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
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pixsellz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                      offset: const Offset(0, 50),
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.black87,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Paramètres',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Déconnexion',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (String value) {
                        if (value == 'settings') {
                          context.push(
                            '/settings',
                            extra: {
                              'userId': 'current_user_id',
                              'username': 'pixsellz',
                            },
                          );
                        } else if (value == 'logout') {
                          showDialog<void>(
                            context: context,
                            builder: (context) => LogoutConfirmationPopup(
                              onConfirm: () {
                                Navigator.of(context).pop(); // Fermer le popup
                                SystemNavigator.pop(); // Fermer l'application
                              },
                              onCancel: () {
                                Navigator.of(context).popUntil(
                                  (route) => route.isFirst,
                                ); // Fermer le popup
                              },
                            ),
                          );
                        }
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
                        fontSize: 16,
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

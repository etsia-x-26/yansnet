// import 'package:flutter/material.dart';
// // Importez votre page de messages
// import 'package:yansnet/conversation/views/messages_list_page.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Yansnet',
//       theme: ThemeData(
//         primaryColor: const Color(0xFF5D1A1A),
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF5D1A1A),
//         ),
//         useMaterial3: true,
//       ),
//       // Option 1: Afficher directement MessagesListPage
//       home: const MessagesListPage(),
//
//       // Option 2: Ou créer une page d'accueil avec un bouton
//       // home: const HomePage(),
//     );
//   }
// }
//
// // Option 2: Page d'accueil avec navigation (si vous préférez)
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           "Yansnet 🚀",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF5D1A1A),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Logo ou image
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF5D1A1A).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.chat_bubble_rounded,
//                 size: 80,
//                 color: Color(0xFF5D1A1A),
//               ),
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               "Bienvenue sur Yansnet",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Restez connecté avec vos amis",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 48),
//             // Bouton Messages
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const MessagesListPage(),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.message),
//               label: const Text(
//                 "Voir mes messages",
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF5D1A1A),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Bouton direct vers Groupes
//             OutlinedButton.icon(
//               onPressed: () {
//                 // Import nécessaire pour GroupsListPage
//                 // import 'package:yansnet/conversation/views/groups_list_page.dart';
//                 // Décommentez cette ligne après avoir créé GroupsListPage
//                 /*
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const GroupsListPage(),
//                   ),
//                 );
//                 */
//                 // Pour l'instant, naviguer vers Messages
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const MessagesListPage(),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.groups),
//               label: const Text(
//                 "Voir mes groupes",
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: const Color(0xFF5D1A1A),
//                 side: const BorderSide(
//                   color: Color(0xFF5D1A1A),
//                   width: 2,
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_search_appbar.dart';

class ExploreHistoryPage extends StatefulWidget {
  const ExploreHistoryPage({super.key});

  @override
  State<ExploreHistoryPage> createState() => _ExploreHistoryPageState();
}

class _ExploreHistoryPageState extends State<ExploreHistoryPage> {
  final TextEditingController _exploreController = TextEditingController();

  List<Map<String, dynamic>> recentExplores = [
    {
      'type': 'user',
      'avatar': 'assets/images/image.png',
      'name': 'tyresehaliburton',
      'subtitle': 'X2026 • Following',
      'verified': true,
    },
    {
      'type': 'keyword',
      'keyword': 'la chaine X2026',
    },
  ];

  void _removeExplore(int index) {
    setState(() {
      recentExplores.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSearchAppBar(
        controller: _exploreController,
        onCancel: () => Navigator.of(context).pop(),
        showCancel: true, // Assure-toi que `showCancel` est défini dans ton widget CustomSearchAppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 46,
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Text(
                'Recent',
                style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF090909),
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: recentExplores.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final item = recentExplores[i];
                  final isUser = item['type'] == 'user';
                  final title = isUser
                      ? item['name'] as String
                      : item['keyword'] as String?;
                  final subtitle = item['subtitle'] as String?;

                  return Container(
                    width: double.infinity,
                    height: 75.5,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFC0262E), width: 1),
                            color: isUser ? Colors.black : Colors.white,
                          ),
                          child: isUser
                              ? ClipOval(
                            child: Image.asset(
                              item['avatar'] as String,
                              fit: BoxFit.cover,
                            ),
                          )
                              : const Center(
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Texts
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    title ?? '',
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (item['verified'] == true) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, size: 12, color: Colors.blue),
                                  ]
                                ],
                              ),
                              if (subtitle != null)
                                Text(
                                  subtitle,
                                  style: GoogleFonts.alegreyaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Close Button
                        GestureDetector(
                          onTap: () => _removeExplore(i),
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

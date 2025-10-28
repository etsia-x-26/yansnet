import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yansnet/publication/widgets/custom_search_appbar.dart';


class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _exploreController = TextEditingController();

  final List<Map<String, String>> newReleases = [
    {'image': 'https://i.pinimg.com/474x/e4/29/69/e429697f201ade295adfdc189d656047.jpg',
      'title': 'BenIt Bruhner',
      'subtitle': 'X2026',
    },
    {'image': 'https://i.pinimg.com/736x/ee/97/aa/ee97aad105740376bb29f9fd130931bf.jpg',
      'title': 'Aerdna_eco',
      'subtitle': 'X2026',
    },
    {'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXRmV6h5Xm3VjW1Lx-AwiLIYDV7YqE2iLBigD-UEOk_vvY4h8szgzwUy62gz6cw5FQtDA&usqp=CAU',
      'title': 'Aerdna_eco',
      'subtitle': 'X2026',
    },
    {'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJb9veKRknkWgd57TYXI2UxPSwcrvewgTnx90P2cg9JeGzJpmBcTR8pl7a68XXr42m4mI&usqp=CAU',
      'title': 'Aerdna_eco',
      'subtitle': 'X2026',},
    {'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe3grk3njWHN-bNSfP7s5yuHpWQUkluynnvoces0F547R-0ENuOq-6c5smAdEtAVfBb-U&usqp=CAU',
      'title': 'Aerdna_eco',
      'subtitle': 'X2026',},
  ];

  final List<String> exploreImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQm3lrjqWli6xEUpW25BxXxbM_GPKKtYI49klSespQW4F1RFZS2u8tcjclOfuZGOR2KdM&usqp=CAU',
    'https://thumbs.dreamstime.com/b/royaume-de-babungo-au-cameroun-65931028.jpg',
    'https://www.lebledparle.com/wp-content/uploads/2021/12/Festvalo.JPG',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkJQqGlkIAW97U3_Ls0PgaZUnA5cdeZZX9bsdYqwSjQEmbgxTiIjD5jiQS-sVYjMphXek&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTMusOkcAVi4NkiKFlUttNGUY4aC8DJi_3VA&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReoTpNVEPpEs8_zPjPlSOB5rv19FbtW0ZeeQ&s',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSearchAppBar(
        controller: _exploreController,
        hintText: 'Search for people and groups',
        showCancel: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Releases',
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF090909),
              ),
            ),
            const SizedBox(height: 13),

            SizedBox(
              height: 247,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: newReleases.length,
                separatorBuilder: (_, __) => const SizedBox(width: 13),
                itemBuilder: (context, index) {
                  final item = newReleases[index];
                  return Container(
                    width: 277,
                    height: 247,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-10, 10),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image']!,
                            width: 277,
                            height: 187,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle']!,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF49454F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Explore',
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF090909),
              ),
            ),
            const SizedBox(height: 13),

            LayoutBuilder(
              builder: (context, constraints) {
                const itemsPerRow = 3;
                const double spacing = 8;

                const totalSpacing = spacing * (itemsPerRow - 1);
                final itemWidth = (constraints.maxWidth - totalSpacing) / itemsPerRow;
                const double itemHeight = 140;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: exploreImages
                      .map((imagePath) => Container(
                    width: itemWidth,
                    height: itemHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),)
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
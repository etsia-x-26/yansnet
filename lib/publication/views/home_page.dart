import 'package:flutter/material.dart';
import 'package:yansnet/publication/widgets/add_button.dart';
import 'package:yansnet/publication/widgets/home/post_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final postTimestamp = DateTime(2004, 1, 29, 17, 35);
    final postDate =
        '${postTimestamp.day}/${postTimestamp.month}/${postTimestamp.year % 10000}';
    final postTime =
        '${postTimestamp.hour.toString().padLeft(2, '0')}:'
        '${postTimestamp.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      floatingActionButton: const AddButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            PostItem(
              username: 'thatjoshguy69',
              displayName: 'Josh Design',
              content: "I'm cookin' something cool 😎",
              imageUrl:
                  'https://i.pinimg.com/474x/e4/29/69/e429697f201ade295adfdc189d656047.jpg',
              time: '$postTime - $postDate',
              likes: 15,
              comments: 15,
            ),
            const PostItem(
              username: 'bennettbuhner',
              displayName: 'Bennt Bruhner',
              content: "Oooooo what's this place?",
              imageUrl:
                  'https://i.pinimg.com/736x/ee/97/aa/ee97aad105740376bb29f9fd130931bf.jpg',
              time: '',
              likes: 0,
              comments: 0,
            ),
          ],
        ),
      ),
    );
  }
}

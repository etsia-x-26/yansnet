import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0x1F000000), width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header skeleton
              const ListTile(
                leading: CircleAvatar(
                  radius: 20,
                ),
                title: Text('Nom d\'utilisateur'),
                subtitle: Text('@username'),
                trailing: Icon(Icons.more_vert),
              ),
              // Content skeleton
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contenu du post qui sera affiché ici'),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Text('Ligne de texte supplémentaire'),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const Text('Dernière ligne'),
                    ),
                  ],
                ),
              ),
              // Image skeleton
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Time skeleton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '00:00 - 01/01/2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              // Actions skeleton
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.messenger_outline_rounded,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '0',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_outline, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '0',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const Icon(Icons.file_upload_outlined, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



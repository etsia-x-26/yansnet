import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<XFile> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Ouvre le clavier automatiquement après le build
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFC0262E),
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF420C18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              onPressed: () {
                // Logique de publication ici
              },
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Zone de texte éditable
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Description of your post',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),

            // Bouton caméra
            // if (_selectedImage != null)
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image.file(
            //       _selectedImage!,
            //       width: double.infinity,
            //       height: 200,
            //       fit: BoxFit.cover,
            //     ),
            //   )
            // else
            //   Align(
            //     alignment: Alignment.centerLeft,
            //     child: GestureDetector(
            //       onTap: () => _pickImage(ImageSource.camera),
            //       child: Container(
            //         width: 50,
            //         height: 50,
            //         decoration: BoxDecoration(
            //           border: Border.all(color: const Color(0xFF420C18)),
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFC0262E)),
            //       ),
            //     ),
            //   ),

            Row(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF420C18)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFC0262E)),
                  ),
                ),
                if (_selectedImages.isNotEmpty)
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_selectedImages[index].path),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),


            const Spacer(),

            // Barre d'icônes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: Color(0xFFC0262E)),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),

                const Icon(Icons.add_circle, color: Color(0xFF420C18)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

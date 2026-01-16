import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../core/error/error_handler.dart';
import '../core/utils/dialog_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    // Assuming phone number is available in user object
    // _phoneController = TextEditingController(text: user?.phoneNumber?.value ?? '');
    _phoneController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      DialogUtils.showError(context, 'Error picking image: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      // Prevent multiple taps
      if (authProvider.isLoading) return;

      try {
        String? profilePictureUrl = authProvider.currentUser?.profilePictureUrl;

        // Upload image if selected
        if (_selectedImage != null) {
          final uploadedUrl = await authProvider.uploadMedia(_selectedImage!);
          if (uploadedUrl != null) {
            profilePictureUrl = uploadedUrl;
          } else {
            if (mounted) DialogUtils.showError(context, 'Failed to upload image.');
            return;
          }
        }

        final success = await authProvider.updateProfile(
          name: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          profilePictureUrl: profilePictureUrl,
          // Assuming updateUser supports username and phone, we should pass them too
          // If the provider doesn't support them yet, we need to update provider signature.
          // Based on OpenAPI UserUpdateDto, it supports many fields.
          // For now we stick to what existing provider likely supports or will support.
        );

        if (mounted) {
          if (success) {
            DialogUtils.showSuccess(context, 'Profile updated successfully!', onPressed: () => Navigator.pop(context));
          } else {
            DialogUtils.showError(context, ErrorHandler.getErrorMessage(authProvider.error));
          }
        }
      } catch (e) {
        if (mounted) {
          DialogUtils.showError(context, ErrorHandler.getErrorMessage(e));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final user = context.read<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1313EC),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                  ),
                  child: isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Save', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : (user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl: user.profilePictureUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                                    errorWidget: (context, url, error) => const Icon(Icons.person, size: 40, color: Colors.grey),
                                  )
                                : const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1313EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 1), // Divider logic visual
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PUBLIC INFO", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500])),
                    const SizedBox(height: 12),
                    _buildField("Name", _nameController, "Your Name", validator: (v) => v!.isEmpty ? "Name required" : null),
                    const SizedBox(height: 16),
                    _buildField("Bio", _bioController, "Write a short bio...", maxLines: 4),
                    
                    const SizedBox(height: 24),
                    Text("PRIVATE INFO", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500])),
                    const SizedBox(height: 12),
                     _buildField("Username", _usernameController, "@username", readOnly: true, hintStyle: TextStyle(color: Colors.grey)), 
                     // Assuming username might be read-only or not easily changeable
                    const SizedBox(height: 16),
                    _buildField("Phone", _phoneController, "+1 234 567 890", readOnly: true), 
                    const SizedBox(height: 8),
                    Text("Contact support to change sensitive info.", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, {int maxLines = 1, bool readOnly = false, TextStyle? hintStyle, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800])),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.plusJakartaSans(fontSize: 15, color: readOnly ? Colors.grey[600] : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]).merge(hintStyle),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1313EC)),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../features/events/presentation/providers/events_provider.dart';
import '../features/posts/presentation/providers/feed_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../core/error/error_handler.dart';
import '../core/utils/dialog_utils.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  XFile? _selectedImage;
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
       final time = await showTimePicker(
         context: context,
         initialTime: TimeOfDay.now(),
       );
       if (time != null && mounted) {
         setState(() {
           _selectedDate = date;
           _selectedTime = time;
         });
       }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 70, 
      maxWidth: 1920
    );
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        DialogUtils.showError(context, 'Please select date and time');
        return;
      }

      setState(() => _isSubmitting = true);
      
      final user = context.read<AuthProvider>().currentUser;
      if (user == null) {
        setState(() => _isSubmitting = false);
        DialogUtils.showError(context, 'You must be logged in');
        return;
      }

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await context.read<FeedProvider>().uploadMedia(File(_selectedImage!.path));
        if (imageUrl == null && mounted) {
           DialogUtils.showError(context, 'Failed to upload image. Please try again.');
           setState(() => _isSubmitting = false);
           return;
        }
      }

      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      if (mounted) {
        try {
          final success = await context.read<EventsProvider>().createEvent(
            _titleController.text,
            dateTime,
            _locationController.text,
            _descriptionController.text,
            _categoryController.text,
            int.tryParse(_maxParticipantsController.text) ?? 100,
            imageUrl,
            user.id,
            user.name,
          );

          if (mounted) {
            setState(() => _isSubmitting = false);
            if (success) {
               DialogUtils.showSuccess(context, 'Event created successfully!', onPressed: () => Navigator.pop(context));
            } else {
               DialogUtils.showError(context, 'Failed to create event. Please try again.');
            }
          }
        } catch (e) {
          if (mounted) {
            setState(() => _isSubmitting = false);
            DialogUtils.showError(context, ErrorHandler.getErrorMessage(e));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create Event',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
            Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1313EC),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    disabledBackgroundColor: const Color(0xFFEFF3F4),
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: _isSubmitting 
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : Text('Create', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // User Info Row
              Row(
                children: [
                   CircleAvatar(
                     radius: 22,
                     backgroundColor: Colors.grey[100],
                     backgroundImage: user?.profilePictureUrl != null 
                       ? NetworkImage(user!.profilePictureUrl!) as ImageProvider
                       : const AssetImage('assets/images/onboarding_welcome.png'),
                   ),
                   const SizedBox(width: 12),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         user?.name ?? 'User',
                         style: GoogleFonts.plusJakartaSans(
                           fontWeight: FontWeight.bold,
                           fontSize: 15,
                           color: Colors.black,
                         ),
                       ),
                       const SizedBox(height: 2),
                       Text(
                         'Host',
                         style: GoogleFonts.plusJakartaSans(
                           color: Colors.grey[600],
                           fontSize: 12,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ],
                   ),
                ],
              ),
              
              const SizedBox(height: 24),

              // Title
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600),
                decoration: _buildMinimalDecoration('Event Name', 'e.g. Annual Tech Symposium'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              
              const SizedBox(height: 20),

              // Date & Time
              InkWell(
                onTap: _pickDateTime,
                child: InputDecorator(
                  decoration: _buildMinimalDecoration('Date & Time', ''),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null 
                          ? 'Select Date & Time' 
                          : '${DateFormat.yMMMd().format(_selectedDate!)} at ${_selectedTime!.format(context)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: _selectedDate == null ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                      const Icon(Icons.event_outlined, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Location
              TextFormField(
                controller: _locationController,
                style: GoogleFonts.plusJakartaSans(fontSize: 15),
                decoration: _buildMinimalDecoration('Location', 'e.g. Main Auditorium'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 15),
                      decoration: _buildMinimalDecoration('Category', 'e.g. Workshop'),
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxParticipantsController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.plusJakartaSans(fontSize: 15),
                      decoration: _buildMinimalDecoration('Max People', 'e.g. 100'),
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              
              // Cover Image
              InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5FC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                    image: _selectedImage != null 
                      ? DecorationImage(image: FileImage(File(_selectedImage!.path)), fit: BoxFit.cover)
                      : null,
                  ),
                  child: _selectedImage == null 
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_photo_alternate_outlined, size: 28, color: Color(0xFF1313EC)),
                          ),
                          const SizedBox(height: 12),
                          Text('Upload Cover Image', style: GoogleFonts.plusJakartaSans(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('High quality images preferred', style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontSize: 12)),
                        ],
                      )
                    : Stack(
                        children: [
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          )
                        ],
                      ),
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                minLines: 5,
                 style: GoogleFonts.plusJakartaSans(fontSize: 15, height: 1.5),
                decoration: _buildMinimalDecoration('About Event', 'Describe what participants can expect...'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildMinimalDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[300]),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1313EC))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../features/jobs/presentation/providers/jobs_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/domain/auth_domain.dart';
import '../features/jobs/presentation/providers/jobs_provider.dart';
import '../core/error/error_handler.dart';
import '../core/utils/dialog_utils.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _applicationUrlController = TextEditingController();
  
  String _selectedType = 'Full Time';
  DateTime? _selectedDeadline;
  
  bool _isSubmitting = false;

  final List<String> _jobTypes = [
    'Full Time',
    'Part Time',
    'Internship',
    'Contract',
    'Remote',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _applicationUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      setState(() {
        _selectedDeadline = date;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDeadline == null) {
        DialogUtils.showError(context, 'Please select a deadline');
        return;
      }
      
      final user = context.read<AuthProvider>().currentUser;
      if (user == null) {
        DialogUtils.showError(context, 'You must be logged in');
        return;
      }

      setState(() => _isSubmitting = true);
      
      try {
        final success = await context.read<JobsProvider>().createJob(
          _titleController.text,
          _companyController.text,
          _locationController.text,
          _selectedType,
          _descriptionController.text,
          _salaryController.text,
          _selectedDeadline!,
          _applicationUrlController.text,
          user.id,
        );

        if (mounted) {
          setState(() => _isSubmitting = false);
          if (success) {
             DialogUtils.showSuccess(context, 'Job posted successfully!', onPressed: () => Navigator.pop(context));
          } else {
             DialogUtils.showError(context, 'Failed to post job. Please try again.');
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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Post a Job',
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
                    : Text('Post', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
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
                         'Posting as ${user?.userType == UserType.company ? "Company" : "Individual"}',
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

              TextFormField(
                controller: _titleController,
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600),
                decoration: _buildMinimalDecoration('Job Title', 'e.g. Senior Product Designer'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _companyController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 15),
                      decoration: _buildMinimalDecoration('Company', 'e.g. Acme Corp'),
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 15),
                      decoration: _buildMinimalDecoration('Location', 'City, Country'),
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedType,
                icon: const Icon(Icons.keyboard_arrow_down),
                decoration: _buildMinimalDecoration('Job Type', ''),
                style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.black),
                items: _jobTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _salaryController,
                style: GoogleFonts.plusJakartaSans(fontSize: 15),
                decoration: _buildMinimalDecoration('Salary Range (Optional)', 'e.g. \$80k - \$120k'),
              ),

              const SizedBox(height: 20),

              InkWell(
                onTap: _pickDeadline,
                child: InputDecorator(
                  decoration: _buildMinimalDecoration('Applications Deadline', ''),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDeadline == null ? 'Select Date' : DateFormat.yMMMd().format(_selectedDeadline!),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: _selectedDeadline == null ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _applicationUrlController,
                style: GoogleFonts.plusJakartaSans(fontSize: 15),
                decoration: _buildMinimalDecoration('Apply URL/Email', 'https://... or mailto:...'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                minLines: 5,
                 style: GoogleFonts.plusJakartaSans(fontSize: 15, height: 1.5),
                decoration: _buildMinimalDecoration('Job Description', 'Describe responsibilities, requirements...'),
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

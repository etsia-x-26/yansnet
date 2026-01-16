import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../features/jobs/presentation/providers/jobs_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/domain/auth_domain.dart';
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
      backgroundColor: const Color(0xFFFAFAFA), // Even softer white
      resizeToAvoidBottomInset: false, // Prevents bottom bar from riding up
      appBar: AppBar(
        title: Text(
          'Post a Job',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[100], height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 80),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Identity Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[100]!), // Softer border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02), // Very subtle shadow
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[50],
                            backgroundImage: user?.profilePictureUrl != null 
                              ? NetworkImage(user!.profilePictureUrl!) as ImageProvider
                              : const AssetImage('assets/images/onboarding_welcome.png'),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'User',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Posting as ${user?.userType == UserType.company ? "Company" : "Individual"}',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader('Job Details'),
                    const SizedBox(height: 16),

                    _buildPremiumField(
                      controller: _titleController,
                      label: 'Job Title',
                      hint: 'e.g. Senior Product Designer',
                      icon: Icons.work_outline_rounded,
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),
                    
                    const SizedBox(height: 16),

                    _buildPremiumField(
                      controller: _companyController,
                      label: 'Company Name',
                      hint: 'e.g. Acme Corp',
                      icon: Icons.business_rounded,
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),

                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildPremiumField(
                            controller: _locationController,
                            label: 'Location',
                            hint: 'City, Country',
                            icon: Icons.location_on_outlined,
                            validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader('Employment'),
                    const SizedBox(height: 16),

                    // Job Type Dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16), // Softer radius
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset:const Offset(0, 2))
                        ]
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Job Type',
                            floatingLabelStyle: TextStyle(color: Color(0xFF1313EC)),
                          ),
                          style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
                          items: _jobTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: (v) => setState(() => _selectedType = v!),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildPremiumField(
                      controller: _salaryController,
                      label: 'Salary Range (Optional)',
                      hint: 'e.g. \$80k - \$120k',
                      icon: Icons.attach_money_rounded,
                    ),

                    const SizedBox(height: 24),
                    _buildSectionHeader('Application Info'),
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: _pickDeadline,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                             BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset:const Offset(0, 2))
                          ]
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, color: Colors.grey[500], size: 22),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Application Deadline',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedDeadline == null ? 'Select Date' : DateFormat.yMMMd().format(_selectedDeadline!),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedDeadline == null ? Colors.grey[400] : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildPremiumField(
                      controller: _applicationUrlController,
                      label: 'Apply URL / Email',
                      hint: 'https://... or mailto:...',
                      icon: Icons.link_rounded,
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),

                    const SizedBox(height: 16),

                    _buildPremiumField(
                      controller: _descriptionController,
                      label: 'Job Description',
                      hint: 'Describe responsibilities, requirements...',
                      icon: Icons.description_outlined,
                      maxLines: 6,
                      validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          
          // Sticky Bottom Button (Stays Put)
          Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03), // Softer shadow
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54, // Taller button
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1313EC),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  disabledBackgroundColor: const Color(0xFFEFF3F4),
                  disabledForegroundColor: Colors.grey,
                ),
                child: _isSubmitting 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                  : Text('Post Job Now', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPremiumField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.black),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontWeight: FontWeight.w500),
        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1313EC), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        // Add shadow via a container in parent if needed, but InputDecorator doesn't support easy shadows. 
        // We'll stick to cleaner borders.
      ),
    );
  }
}

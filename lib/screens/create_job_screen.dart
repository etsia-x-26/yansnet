import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../features/jobs/presentation/providers/jobs_provider.dart';

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
  String _selectedType = 'Full Time';
  
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
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      final success = await context.read<JobsProvider>().createJob(
        _titleController.text,
        _companyController.text,
        _locationController.text,
        _selectedType,
        _descriptionController.text,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted successfully!')));
           Navigator.pop(context);
        } else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to post job.')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Post a Job', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Job Title'),
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration('e.g. Senior Flutter Developer'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 16),

              _buildLabel('Company Name'),
              TextFormField(
                controller: _companyController,
                decoration: _buildInputDecoration('e.g. YansNet Corp'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 16),

              _buildLabel('Location'),
              TextFormField(
                controller: _locationController,
                decoration: _buildInputDecoration('e.g. New York, NY (or Remote)'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 16),

              _buildLabel('Job Type'),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: _buildInputDecoration(''),
                items: _jobTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 16),

              _buildLabel('Description'),
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: _buildInputDecoration('Describe the role and requirements...'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1313EC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text('Post Job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1313EC))),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }
}

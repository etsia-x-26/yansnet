import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../features/events/presentation/providers/events_provider.dart';

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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select date and time')));
        return;
      }

      setState(() => _isSubmitting = true);
      
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      final success = await context.read<EventsProvider>().createEvent(
        _titleController.text,
        dateTime,
        _locationController.text,
        _descriptionController.text,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event created successfully!')));
           Navigator.pop(context);
        } else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create event.')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Event', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.black)),
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
              _buildLabel('Event Title'),
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration('e.g. Annual Tech Symposium'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 16),

              _buildLabel('Date & Time'),
              InkWell(
                onTap: _pickDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null 
                          ? 'Select Date & Time' 
                          : '${DateFormat.yMMMd().format(_selectedDate!)} at ${_selectedTime!.format(context)}',
                        style: GoogleFonts.plusJakartaSans(
                          color: _selectedDate == null ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel('Location'),
              TextFormField(
                controller: _locationController,
                decoration: _buildInputDecoration('e.g. Main Auditorium'),
                validator: (v) => v?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 16),

              _buildLabel('Description'),
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: _buildInputDecoration('Describe the event...'),
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
                    : const Text('Create Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

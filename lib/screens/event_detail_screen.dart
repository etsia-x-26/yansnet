import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../features/events/domain/entities/event_entity.dart';
import '../features/events/presentation/providers/events_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: event.bannerUrl != null && event.bannerUrl!.isNotEmpty
                  ? Image.network(event.bannerUrl!, fit: BoxFit.cover)
                  : Image.asset('assets/images/onboarding_collaborate.png', fit: BoxFit.cover),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), 
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3F4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'EVENT',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${event.attendeesCount} attendees',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Info Rows
                  _buildInfoRow(Icons.calendar_today, DateFormat.yMMMMEEEEd().format(event.eventDate), DateFormat.jm().format(event.eventDate)),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.location_on_outlined, event.location, 'Get Directions'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.person_outline, event.organizer, 'Organizer'),
                  
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),
                   
                  Text(
                    'About this event',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Consumer<EventsProvider>(
          builder: (context, provider, _) {
            // Find current event state in provider if available to show real-time updates
             final currentEvent = provider.events.firstWhere((e) => e.id == event.id, orElse: () => event);
             
             return SizedBox(
              width: double.infinity,
               child: ElevatedButton(
                onPressed: () {
                  provider.toggleRsvp(currentEvent);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentEvent.isAttending ? Colors.white : const Color(0xFF1313EC),
                  foregroundColor: currentEvent.isAttending ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: currentEvent.isAttending ? BorderSide(color: Colors.grey[300]!) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  currentEvent.isAttending ? 'Cancel RSVP' : 'RSVP Now', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            ),
             );
          }
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1313EC), size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        )
      ],
    );
  }
}

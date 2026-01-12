import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../features/events/presentation/providers/events_provider.dart';
import '../../features/events/domain/entities/event_entity.dart';
import 'package:intl/intl.dart';
import 'event_detail_screen.dart';
import 'create_event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().loadEvents(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'University Events',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Career', false),
                _buildFilterChip('Social', false),
                _buildFilterChip('Workshops', false),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen()));
        },
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<EventsProvider>().loadEvents(refresh: true),
        child: Consumer<EventsProvider>(
          builder: (context, provider, child) {
            final hasEvents = provider.events.isNotEmpty;
            final featuredEvent = hasEvents ? provider.events.first : null;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Header (Dynamic)
                  if (featuredEvent != null)
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: featuredEvent.bannerUrl != null && featuredEvent.bannerUrl!.isNotEmpty
                                  ? NetworkImage(featuredEvent.bannerUrl!) as ImageProvider
                                  : const AssetImage('assets/images/onboarding_opportunities.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1313EC),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text('FEATURED',
                                    style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Text(
                                  featuredEvent.title,
                                  style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                '${featuredEvent.location} • ${DateFormat('MMM dd, hh:mm a').format(featuredEvent.eventDate)}',
                                style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Upcoming Events',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),

                  // Event List
                  if (provider.isLoading && provider.events.isEmpty)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    )),
                  if (provider.error != null && provider.events.isEmpty)
                    Center(child: Text('Error: ${provider.error}')),
                  if (!provider.isLoading && provider.events.isEmpty)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No events found.'),
                    )),

                  if (provider.events.isNotEmpty)
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.events.length,
                      separatorBuilder: (c, i) =>
                          const Divider(height: 1, indent: 70, color: Color(0xFFEFF3F4)),
                      itemBuilder: (context, index) {
                        final event = provider.events[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailScreen(event: event)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date Column
                                Column(
                                  children: [
                                    Text(
                                      DateFormat('MMM')
                                          .format(event.eventDate)
                                          .toUpperCase(),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd').format(event.eventDate),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                // Image Thumbnail
                                Container(
                                  width: 80,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: event.bannerUrl != null &&
                                              event.bannerUrl!.isNotEmpty
                                          ? NetworkImage(event.bannerUrl!)
                                              as ImageProvider
                                          : const AssetImage(
                                              'assets/images/onboarding_collaborate.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.title,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${event.location} • ${DateFormat('hh:mm a').format(event.eventDate)}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.people_outline,
                                              size: 12, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${event.attendeesCount} Going',
                                            style: GoogleFonts.plusJakartaSans(
                                                color: Colors.grey, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // const Spacer(), // Removed Spacer usage in expanded row
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    provider.toggleRsvp(event);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: event.isAttending
                                        ? Colors.grey[300]
                                        : const Color(0xFF1313EC),
                                    foregroundColor: event.isAttending
                                        ? Colors.black
                                        : Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 0),
                                    minimumSize: const Size(0, 32),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: Text(
                                    event.isAttending ? 'Joined' : 'Join',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.black : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: selected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

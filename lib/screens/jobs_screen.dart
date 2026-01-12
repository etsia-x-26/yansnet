import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../features/jobs/presentation/providers/jobs_provider.dart';
import 'job_detail_screen.dart';
import 'create_job_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobsProvider>().loadJobs(refresh: true);
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
          'Jobs & Internships',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: Colors.black), // Filter icon
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF3F4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
                  hintText: 'Search for jobs, companies...',
                  hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  isDense: true,
                ),
                style: GoogleFonts.plusJakartaSans(fontSize: 13),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateJobScreen()));
        },
        backgroundColor: const Color(0xFF1313EC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<JobsProvider>().loadJobs(refresh: true),
        child: Consumer<JobsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.jobs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null && provider.jobs.isEmpty) {
              return Center(child: Text('Error: ${provider.error}'));
            }
            if (provider.jobs.isEmpty) {
              return const Center(child: Text('No jobs available at the moment.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.jobs.length,
              separatorBuilder: (c, i) => const Divider(height: 24, color: Color(0xFFEFF3F4)),
              itemBuilder: (context, index) {
                final job = provider.jobs[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailScreen(job: job),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          image: job.bannerUrl != null 
                             ? DecorationImage(image: NetworkImage(job.bannerUrl!), fit: BoxFit.cover)
                             : null,
                        ),
                        child: job.bannerUrl == null 
                          ? Center(child: Text(job.companyName[0], style: const TextStyle(fontWeight: FontWeight.bold)))
                          : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              job.companyName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${job.location} (${job.type})',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Posted ${DateFormat.yMMMd().format(job.postedAt)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: Colors.green, // "Active" look
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.bookmark_border, color: Colors.grey[400]),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

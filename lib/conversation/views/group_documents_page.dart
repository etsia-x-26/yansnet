import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupDocumentsPage extends StatelessWidget {
  GroupDocumentsPage({
    required this.groupName,
    super.key,
  });

  final String groupName;

  // Données mockées pour les documents
  final List<DocumentItem> _documentItems = [
    const DocumentItem(
      id: '1',
      name: 'Rapport_Projet_ETSIA.pdf',
      size: '2.4 MB',
      senderName: 'Axelle Bakery',
      date: '15/01/2025',
      isDownloaded: true,
    ),
    const DocumentItem(
      id: '2',
      name: 'Presentation_Reunion.pptx',
      size: '5.1 MB',
      senderName: 'Emmy',
      date: '14/01/2025',
      isDownloaded: false,
    ),
    const DocumentItem(
      id: '3',
      name: 'Budget_2025.xlsx',
      size: '1.2 MB',
      senderName: 'Victoire',
      date: '13/01/2025',
      isDownloaded: true,
    ),
    const DocumentItem(
      id: '4',
      name: 'Notes_Reunion.docx',
      size: '856 KB',
      senderName: 'Passi',
      date: '12/01/2025',
      isDownloaded: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Documents - $groupName',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _documentItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun document',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les documents partagés dans ce groupe\napparaîtront ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _documentItems.length,
              itemBuilder: (context, index) {
                final document = _documentItems[index];
                return _buildDocumentItem(context, document);
              },
            ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, DocumentItem document) {
    final icon = _getFileIcon(document.name);
    final color = _getFileColor(document.name);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          document.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${document.size} • ${document.senderName} • ${document.date}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        /*
        trailing: document.isDownloaded
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              )
            : IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Téléchargement de ${document.name}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
         */
        onTap: () {
          // Action pour ouvrir le document
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ouverture de ${document.name}...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class DocumentItem {
  const DocumentItem({
    required this.id,
    required this.name,
    required this.size,
    required this.senderName,
    required this.date,
    this.isDownloaded = false,
  });

  final String id;
  final String name;
  final String size;
  final String senderName;
  final String date;
  final bool isDownloaded;
}


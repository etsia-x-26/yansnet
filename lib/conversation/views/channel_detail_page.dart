// lib/conversation/views/channel_detail_page.dart
import 'package:flutter/material.dart';

class ChannelDetailPage extends StatefulWidget {
  final String channelName;
  final String channelAvatar;
  final String description;
  final int subscriberCount;
  final bool isSubscribed;
  final bool isOfficial;
  final Function(bool) onSubscriptionChanged;

  const ChannelDetailPage({
    Key? key,
    required this.channelName,
    required this.channelAvatar,
    required this.description,
    required this.subscriberCount,
    required this.isSubscribed,
    required this.isOfficial,
    required this.onSubscriptionChanged,
  }) : super(key: key);

  @override
  State<ChannelDetailPage> createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  late bool _isSubscribed;

  // Posts mockés de la chaîne avec médias
  final List<Map<String, dynamic>> _posts = [
    {
      'text': '📢 Nouvelles inscriptions ouvertes pour le semestre prochain ! Rendez-vous au secrétariat pour plus d\'informations.',
      'time': '10:48',
      'reactions': {'🙏': 45, '👍': 23, '❤️': 12, '😊': 5},
      'mediaType': 'image',
      'mediaUrl': 'https://picsum.photos/400/300?random=1',
    },
    {
      'text': '#L\'histoire de Baya\n\nLorsque une jeune fille devenait femme, sa grand-mère lui mettait aux reins des Bayas. C\'était un signe de passage, de beauté et de dignité.\nUn geste simple, mais chargé d\'histoires, de symboles et de promesses...',
      'time': '10:48',
      'reactions': {'👍': 78, '🙏': 34, '❤️': 15, '😂': 5},
      'mediaType': null,
      'mediaUrl': null,
    },
    {
      'text': 'For the past 25 years, MTN has been at the heart of the Kontinent... And the best is yet to come!',
      'time': '10:48',
      'reactions': {'👍': 15, '🙏': 8, '❤️': 6, '😂': 3},
      'mediaType': 'image',
      'mediaUrl': 'https://picsum.photos/400/300?random=3',
    },
    {
      'text': '🎉 Félicitations à tous les diplômés de la promotion 2024 !',
      'time': '14:20',
      'reactions': {'🎉': 156, '👏': 89, '❤️': 67, '😊': 23},
      'mediaType': 'image',
      'mediaUrl': 'https://picsum.photos/400/300?random=2',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isSubscribed = widget.isSubscribed;
  }

  void _toggleSubscription() {
    setState(() => _isSubscribed = !_isSubscribed);
    widget.onSubscriptionChanged(_isSubscribed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // Toute la zone du titre est cliquable pour voir les infos
        title: InkWell(
          onTap: () => _showChannelInfo(context),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.channelAvatar),
                  ),
                  if (widget.isOfficial)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.verified, size: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.channelName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_formatFollowers(widget.subscriberCount)} followers',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () => _showChannelInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _toggleSubscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSubscribed ? Colors.grey[300] : const Color(0xFF25D366),
                foregroundColor: _isSubscribed ? Colors.black87 : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                _isSubscribed ? 'Abonné' : 'Suivre la chaîne',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _posts.length,
              itemBuilder: (context, index) => _buildPostItem(_posts[index]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)} M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)} K';
    }
    return count.toString();
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    final reactions = post['reactions'] as Map<String, int>;
    final topReactions = reactions.entries.take(4).toList();
    final totalReactions = reactions.values.fold<int>(0, (sum, count) => sum + count);

    return GestureDetector(
      onLongPress: () => _showReactionPicker(context, post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenu texte
            if (post['text'] != null && (post['text'] as String).isNotEmpty)
              Text(
                post['text'] as String,
                style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
              ),
            // Média
            if (post['mediaType'] != null) ...[
              if (post['text'] != null && (post['text'] as String).isNotEmpty)
                const SizedBox(height: 12),
              if (post['mediaType'] == 'image' && post['mediaUrl'] != null)
                GestureDetector(
                  onLongPress: () => _showReactionPicker(context, post),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      post['mediaUrl'] as String,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                ),
              if (post['mediaType'] == 'video')
                GestureDetector(
                  onLongPress: () => _showReactionPicker(context, post),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(Icons.play_circle_outline, size: 64, color: Colors.grey[700]),
                    ),
                  ),
                ),
            ],
            // Heure en bas à droite
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  post['time'] as String,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
            // SEULEMENT les réactions (pas de vues)
            if (totalReactions > 0) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _showAllReactions(context, reactions),
                child: Row(
                  children: [
                    ...topReactions.map((entry) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(entry.key, style: const TextStyle(fontSize: 18)),
                    )),
                    const SizedBox(width: 4),
                    Text(
                      totalReactions.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Icon(Icons.forward, size: 18, color: Colors.grey[600]),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReactionButton('👍', post),
                _buildReactionButton('❤️', post),
                _buildReactionButton('😂', post),
                _buildReactionButton('😱', post),
                _buildReactionButton('😢', post),
                _buildReactionButton('🙏', post),
                _buildReactionButton('🎉', post),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionButton(String emoji, Map<String, dynamic> post) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          final reactions = post['reactions'] as Map<String, int>;
          reactions[emoji] = (reactions[emoji] ?? 0) + 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réaction $emoji ajoutée'), duration: const Duration(seconds: 1)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  void _showAllReactions(BuildContext context, Map<String, int> reactions) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              '${reactions.values.fold<int>(0, (sum, count) => sum + count)} réactions',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...reactions.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showChannelInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                Stack(
                  children: [
                    CircleAvatar(radius: 60, backgroundImage: NetworkImage(widget.channelAvatar)),
                    if (widget.isOfficial)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(Icons.verified, size: 24, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.channelName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Chaîne • ${_formatFollowers(widget.subscriberCount)} followers',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    widget.description,
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Créée le 21/06/2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 24),
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.forward),
                        label: const Text('Transférer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF25D366),
                          side: const BorderSide(color: Color(0xFF25D366)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Partager'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF25D366),
                          side: const BorderSide(color: Color(0xFF25D366)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _toggleSubscription();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isSubscribed ? 'Vous êtes maintenant abonné' : 'Vous êtes désabonné'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubscribed ? Colors.red : const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      _isSubscribed ? 'Se désabonner' : 'Suivre',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.flag_outlined, color: Colors.red),
                  label: const Text(
                    'Signaler la chaîne',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
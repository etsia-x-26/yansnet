// lib/conversation/models/channel_filter.dart
enum ChannelFilter {
  all('Tous'),
  subscribed('Abonnés'),
  popular('Populaires'),
  recent('Récents');

  final String label;
  const ChannelFilter(this.label);
}
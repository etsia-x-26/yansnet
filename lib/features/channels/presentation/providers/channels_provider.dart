import 'package:flutter/material.dart';
import '../../domain/entities/channel_entity.dart';
import '../../domain/usecases/get_channels_usecase.dart';
import '../../domain/usecases/create_channel_usecase.dart';

class ChannelsProvider extends ChangeNotifier {
  final GetChannelsUseCase getChannelsUseCase;
  final CreateChannelUseCase createChannelUseCase;

  List<Channel> _channels = [];
  bool _isLoading = false;
  String? _error;

  ChannelsProvider({
    required this.getChannelsUseCase,
    required this.createChannelUseCase,
  });

  List<Channel> get channels => _channels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChannels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _channels = await getChannelsUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createChannel(String title, String description) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newChannel = await createChannelUseCase(title, description);
      _channels.add(newChannel); // Optimistic or existing list update
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

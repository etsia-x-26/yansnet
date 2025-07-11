import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yansnet/subscription/api/subscription_api.dart';
import 'package:yansnet/subscription/models/channel.dart';

part 'channel_state.dart';
part 'channel_cubit.freezed.dart';

class ChannelCubit extends Cubit<ChannelState> {
  final SubscriptionAPI subscriptionAPI = SubscriptionAPI();
  ChannelCubit() : super(const ChannelState.initial());

  Future<void> getChannels() async {
    try {
      print('yes ');
      var responseEntity = await subscriptionAPI.getChannels();
      print(responseEntity);
      /*
      if (responseEntity.success) {
        List<User> users = [];
        for (var user in responseEntity.data) {
          users.add(User.fromJson(user));
        }
        emit(MailRequestState.userLoaded(users: users));
      } else {
        emit(const MailRequestState.error(message: 'Une erreur est survenue'));
      }

       */
    } catch (e) {
      //emit(const MailRequestState.error(message: 'Une erreur est survenue'));
      print(e);
    }
  }

  Future<void> followChannels(int channelId, int followerId) async {
    try {
      print('yes ');
      var responseEntity = await subscriptionAPI.followChannel(
        channelId,
        followerId,
      );
      print(responseEntity);
      /*
      if (responseEntity.success) {
        List<User> users = [];
        for (var user in responseEntity.data) {
          users.add(User.fromJson(user));
        }
        emit(MailRequestState.userLoaded(users: users));
      } else {
        emit(const MailRequestState.error(message: 'Une erreur est survenue'));
      }

       */
    } catch (e) {
      //emit(const MailRequestState.error(message: 'Une erreur est survenue'));
      print(e);
    }
  }
  Future<void> createChannel(String title, String description) async {
    try {
      print('yes ');
      var responseEntity = await subscriptionAPI.createChannel(
        title,
        description,
      );
      print(responseEntity);
      /*
      if (responseEntity.success) {
        List<User> users = [];
        for (var user in responseEntity.data) {
          users.add(User.fromJson(user));
        }
        emit(MailRequestState.userLoaded(users: users));
      } else {
        emit(const MailRequestState.error(message: 'Une erreur est survenue'));
      }

       */
    } catch (e) {
      //emit(const MailRequestState.error(message: 'Une erreur est survenue'));
      print(e);
    }
  }
}

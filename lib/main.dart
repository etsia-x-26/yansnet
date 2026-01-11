import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/domain/usecases/get_user_usecase.dart';
import 'features/auth/domain/usecases/update_user_usecase.dart';

import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/usecases/get_posts_usecase.dart';
import 'features/posts/domain/usecases/create_post_usecase.dart';
import 'features/posts/domain/usecases/get_comments_usecase.dart';
import 'features/posts/domain/usecases/add_comment_usecase.dart';
import 'features/posts/domain/usecases/like_post_usecase.dart';
import 'features/posts/presentation/providers/feed_provider.dart';
import 'features/posts/presentation/providers/comments_provider.dart';

import 'features/jobs/data/datasources/job_remote_data_source.dart';
import 'features/jobs/data/repositories/job_repository_impl.dart';
import 'features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'features/jobs/presentation/providers/jobs_provider.dart';

import 'features/events/data/datasources/event_remote_data_source.dart';
import 'features/events/data/repositories/event_repository_impl.dart';
import 'features/events/domain/usecases/get_events_usecase.dart';
import 'features/events/domain/usecases/rsvp_event_usecase.dart';
import 'features/events/domain/usecases/cancel_rsvp_usecase.dart';
import 'features/events/presentation/providers/events_provider.dart';

import 'features/channels/data/datasources/channel_remote_data_source.dart';
import 'features/channels/data/repositories/channel_repository_impl.dart';
import 'features/channels/domain/usecases/get_channels_usecase.dart';
import 'features/channels/domain/usecases/create_channel_usecase.dart';
import 'features/channels/presentation/providers/channels_provider.dart';

import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/usecases/get_conversations_usecase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/start_chat_usecase.dart';
import 'features/chat/presentation/providers/chat_provider.dart';

// ... other imports ...
import 'screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  final apiClient = ApiClient();
  
  // Auth
  final authDataSource = AuthRemoteDataSourceImpl(apiClient);
  final authRepository = AuthRepositoryImpl(authDataSource, apiClient);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final getUserUseCase = GetUserUseCase(authRepository);
  final updateUserUseCase = UpdateUserUseCase(authRepository);

  // Posts
  final postDataSource = PostRemoteDataSourceImpl(apiClient);
  final postRepository = PostRepositoryImpl(postDataSource);
  final getPostsUseCase = GetPostsUseCase(postRepository);
  final createPostUseCase = CreatePostUseCase(postRepository);
  final getCommentsUseCase = GetCommentsUseCase(postRepository);
  final addCommentUseCase = AddCommentUseCase(postRepository);
  final likePostUseCase = LikePostUseCase(postRepository);

  // Jobs
  final jobDataSource = JobRemoteDataSourceImpl(apiClient);
  final jobRepository = JobRepositoryImpl(jobDataSource);
  final getJobsUseCase = GetJobsUseCase(jobRepository);

  // Events
  final eventDataSource = EventRemoteDataSourceImpl(apiClient);
  final eventRepository = EventRepositoryImpl(eventDataSource);
  final getEventsUseCase = GetEventsUseCase(eventRepository);
  final rsvpEventUseCase = RsvpEventUseCase(eventRepository);
  final cancelRsvpUseCase = CancelRsvpUseCase(eventRepository);

  // Channels
  final channelDataSource = ChannelRemoteDataSourceImpl(apiClient);
  final channelRepository = ChannelRepositoryImpl(channelDataSource);
  final getChannelsUseCase = GetChannelsUseCase(channelRepository);
  final createChannelUseCase = CreateChannelUseCase(channelRepository);

  // Chat
  final chatDataSource = ChatRemoteDataSourceImpl(apiClient);
  final chatRepository = ChatRepositoryImpl(chatDataSource);
  final getConversationsUseCase = GetConversationsUseCase(chatRepository);
  final getMessagesUseCase = GetMessagesUseCase(chatRepository);
  final sendMessageUseCase = SendMessageUseCase(chatRepository);
  final startChatUseCase = StartChatUseCase(chatRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
          getUserUseCase: getUserUseCase,
          updateUserUseCase: updateUserUseCase,
          apiClient: apiClient,
        )),
        ChangeNotifierProvider(create: (_) => FeedProvider(
          getPostsUseCase: getPostsUseCase,
          createPostUseCase: createPostUseCase,
          likePostUseCase: likePostUseCase,
        )),
        ChangeNotifierProvider(create: (_) => CommentsProvider(
          getCommentsUseCase: getCommentsUseCase,
          addCommentUseCase: addCommentUseCase,
        )),
        ChangeNotifierProvider(create: (_) => JobsProvider(
          getJobsUseCase: getJobsUseCase,
        )),
        ChangeNotifierProvider(create: (_) => EventsProvider(
          getEventsUseCase: getEventsUseCase,
          rsvpEventUseCase: rsvpEventUseCase,
          cancelRsvpUseCase: cancelRsvpUseCase,
        )),
        ChangeNotifierProvider(create: (_) => ChannelsProvider(
          getChannelsUseCase: getChannelsUseCase,
          createChannelUseCase: createChannelUseCase,
        )),
        ChangeNotifierProvider(create: (_) => ChatProvider(
          getConversationsUseCase: getConversationsUseCase,
          getMessagesUseCase: getMessagesUseCase,
          sendMessageUseCase: sendMessageUseCase,
          startChatUseCase: startChatUseCase,
        )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YansNet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1313EC),
        ).copyWith(
          primary: const Color(0xFF1313EC),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const OnboardingScreen(),
    );
  }
}

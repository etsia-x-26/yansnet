import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:yansnet/core/network/api_client.dart';
import 'package:yansnet/features/auth/domain/auth_domain.dart';
import 'package:yansnet/features/auth/presentation/providers/auth_provider.dart';
import 'package:yansnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:yansnet/features/posts/presentation/providers/feed_provider.dart';
import 'package:yansnet/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:yansnet/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:yansnet/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:yansnet/features/posts/domain/entities/post_entity.dart';
import 'package:yansnet/features/events/presentation/providers/events_provider.dart';
import 'package:yansnet/features/events/domain/usecases/get_events_usecase.dart';
import 'package:yansnet/features/events/domain/usecases/rsvp_event_usecase.dart';
import 'package:yansnet/features/events/domain/usecases/cancel_rsvp_usecase.dart';
import 'package:yansnet/features/events/domain/entities/event_entity.dart';
import 'package:yansnet/features/chat/presentation/providers/chat_provider.dart';
import 'package:yansnet/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:yansnet/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:yansnet/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:yansnet/features/chat/domain/usecases/start_chat_usecase.dart';
import 'package:yansnet/features/chat/domain/entities/conversation_entity.dart';
import 'package:yansnet/features/chat/domain/entities/message_entity.dart';

import 'feature_verification_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
  GetPostsUseCase,
  CreatePostUseCase,
  LikePostUseCase,
  GetEventsUseCase,
  RsvpEventUseCase,
  CancelRsvpUseCase,
  GetConversationsUseCase,
  GetMessagesUseCase,
  SendMessageUseCase,
  StartChatUseCase
])
void main() {
  group('Feature Integration Verification', () {
    // Auth
    late MockLoginUseCase mockLoginUseCase;
    // ... authProvider unused in this simplified test for now

    // Feed
    late MockGetPostsUseCase mockGetPostsUseCase;
    late MockCreatePostUseCase mockCreatePostUseCase;
    late MockLikePostUseCase mockLikePostUseCase;
    late FeedProvider feedProvider;

    // Events
    late MockGetEventsUseCase mockGetEventsUseCase;
    late MockRsvpEventUseCase mockRsvpEventUseCase;
    late MockCancelRsvpUseCase mockCancelRsvpUseCase;
    late EventsProvider eventsProvider;

    // Chat
    late MockGetConversationsUseCase mockGetConversationsUseCase;
    late MockGetMessagesUseCase mockGetMessagesUseCase;
    late MockSendMessageUseCase mockSendMessageUseCase;
    late MockStartChatUseCase mockStartChatUseCase;
    late ChatProvider chatProvider;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      
      mockGetPostsUseCase = MockGetPostsUseCase();
      mockCreatePostUseCase = MockCreatePostUseCase();
      mockLikePostUseCase = MockLikePostUseCase();
      feedProvider = FeedProvider(
        getPostsUseCase: mockGetPostsUseCase,
        createPostUseCase: mockCreatePostUseCase,
        likePostUseCase: mockLikePostUseCase,
      );

      mockGetEventsUseCase = MockGetEventsUseCase();
      mockRsvpEventUseCase = MockRsvpEventUseCase();
      mockCancelRsvpUseCase = MockCancelRsvpUseCase();
      eventsProvider = EventsProvider(
        getEventsUseCase: mockGetEventsUseCase,
        rsvpEventUseCase: mockRsvpEventUseCase,
        cancelRsvpUseCase: mockCancelRsvpUseCase,
      );

      mockGetConversationsUseCase = MockGetConversationsUseCase();
      mockGetMessagesUseCase = MockGetMessagesUseCase();
      mockSendMessageUseCase = MockSendMessageUseCase();
      mockStartChatUseCase = MockStartChatUseCase();
      chatProvider = ChatProvider(
        getConversationsUseCase: mockGetConversationsUseCase,
        getMessagesUseCase: mockGetMessagesUseCase,
        sendMessageUseCase: mockSendMessageUseCase,
        startChatUseCase: mockStartChatUseCase,
      );
    });

    test('FeedProvider fetches posts on load', () async {
      when(mockGetPostsUseCase()).thenAnswer((_) async => [
        Post(
          id: 1, 
          content: 'Hello', 
          createdAt: DateTime.now(), 
          user: User(id: 101, email: 'test@test.com', name: 'Test User'),
          totalLikes: 0, 
          totalComments: 0
        )
      ]);

      await feedProvider.loadPosts();

      expect(feedProvider.posts.length, 1);
      expect(feedProvider.posts.first.content, 'Hello');
    });

    test('EventsProvider toggles RSVP', () async {
      final event = Event(id: 1, title: 'Test Event', description: 'Desc', location: 'Loc', eventDate: DateTime.now(), organizer: 'Org', attendeesCount: 10, isAttending: false);
      when(mockGetEventsUseCase()).thenAnswer((_) async => [event]);
      await eventsProvider.loadEvents();
      
      expect(eventsProvider.events.first.isAttending, false);
      expect(eventsProvider.events.first.attendeesCount, 10);

      // Verify toggle Rsvp (Join)
      when(mockRsvpEventUseCase(1)).thenAnswer((_) async => {});
      await eventsProvider.toggleRsvp(event);

      expect(eventsProvider.events.first.isAttending, true);
      expect(eventsProvider.events.first.attendeesCount, 11);
    });

    test('ChatProvider fetches conversations', () async {
       when(mockGetConversationsUseCase()).thenAnswer((_) async => [
         Conversation(
           id: 1, 
           participants: [User(id: 2, email: 'b@test.com', name: 'Bob')],
           lastMessage: Message(id: 1, conversationId: 1, content: 'Hi', senderId: 2, createdAt: DateTime.now())
         )
       ]);
       
       await chatProvider.loadConversations();
       expect(chatProvider.conversations.length, 1);
       expect(chatProvider.conversations.first.lastMessage?.content, 'Hi');
    });
  });
}

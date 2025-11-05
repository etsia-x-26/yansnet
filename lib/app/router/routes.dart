class AppRoutes {
  // Auth Routes
  static const String authLoginRoute = '/auth/login';
  static const String authRegisterRoute = '/auth/register';

  // Main Routes
  static const String homeRoute = '/';
  static const String splashRoute = '/splash';
  static const String settingsSheetRoute = '/settings';
  static const String createPostPageRoute = '/create';

  //Channel Routes
  static const String createChannel = '/channel/create';

  // Message Routes
  static const String messagesRoute = '/messages';
  static const String emptyMessagesRoute = '/empty';
  static const String connectionErrorRoute = '/error';

  // Chat Routes
  static const String chatRoute = '/chat';
  static const String chatConversationRoute = '/chat/:userName';

  // Group Routes
  static const String groupChatRoute = '/group';
  static const String groupInfoRoute = '/:groupName';
  static const String createGroup = '/create';

  // Profile Routes
  static const String profileRoute = '/profile/:username';
}

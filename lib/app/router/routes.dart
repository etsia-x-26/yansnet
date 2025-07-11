class AppRoutes {
  // Auth Routes
  static const String authLoginRoute = '/auth/login';
  static const String authRegisterRoute = '/auth/register';

  // Main Routes
  static const String homeRoute = '/home';
  static const String splashRoute = '/splash';
  static const String homePageRoute = '/home/page';
  static const String createPostPageRoute = '/create';
  
  //Channel Routes
  static const String createChannel = '/channel/create';

  // Message Routes
  static const String messagesRoute = '/messages';
  static const String emptyMessagesRoute = '/messages/empty';
  static const String connectionErrorRoute = '/messages/error';

  // Chat Routes
  static const String chatRoute = '/chat';
  static const String chatConversationRoute = '/chat/:userName';

  // Group Routes
  static const String groupChatRoute = '/group';
  static const String groupInfoRoute = '/group/:groupName/info';
  static const String createGroup = '/group/create';
}
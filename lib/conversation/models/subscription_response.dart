// lib/conversation/models/subscription_response.dart
class SubscriptionResponse {
  final bool success;
  final String message;

  SubscriptionResponse({
    required this.success,
    required this.message,
  });

  factory SubscriptionResponse.fromString(String message) {
    return SubscriptionResponse(
      success: true,
      message: message,
    );
  }
}
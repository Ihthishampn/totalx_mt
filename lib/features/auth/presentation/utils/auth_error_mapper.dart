// he;per text for user frndlyy

String getFriendlyOtpSendError(String type, String? message) {
  final lowerMessage = message?.toLowerCase() ?? '';

  if (lowerMessage.contains('restricted') || lowerMessage.contains('blocked')) {
    return 'OTP delivery is restricted for this number. Please use a different number or contact support.';
  }

  if (lowerMessage.contains('invalid') || lowerMessage.contains('wrong')) {
    return 'The phone number appears invalid. Please check and try again.';
  }

  if (lowerMessage.contains('failed') ||
      lowerMessage.contains('error') ||
      lowerMessage.contains('bad request')) {
    return 'Unable to send OTP right now. Please try again later.';
  }

  if (type.toLowerCase() != 'success') {
    return 'OTP request was rejected by the server. Please verify your phone number.';
  }

  return message?.isNotEmpty == true
      ? message!
      : 'OTP request completed successfully. Please check your messages.';
}

// formating for api
String normalizePhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length == 10) {
    return '91$digits';
  }
  if (digits.length == 12 && digits.startsWith('91')) {
    return digits;
  }
  if (digits.length > 10) {
    return '91${digits.substring(digits.length - 10)}';
  }
  return digits;
}

// check otp done or not
bool isOtpSendSuccess(int statusCode, String type, String message) {
  if (statusCode != 200) {
    return false;
  }

  if (!isSuccessType(type)) {
    return false;
  }

  if (message.isEmpty) {
    return true;
  }

  final normalized = message.toLowerCase();
  final negativeKeywords = [
    'invalid',
    'wrong',
    'failed',
    'error',
    'not found',
    'bad request',
    'blocked',
    'restricted',
  ];
  if (negativeKeywords.any(normalized.contains)) {
    return false;
  }

  final positiveKeywords = [
    'sent',
    'otp has been sent',
    'otp sent',
    'otp sent successfully',
    'message sent',
    'triggered',
  ];
  return positiveKeywords.any(normalized.contains);
}

// I used this to check if there is any problem in my code or not. with this can check api succes an fine problem is dlt template which is get by organisation details need
bool isSuccessType(String type) {
  return type.toLowerCase() == 'success';
}

Map<String, dynamic> responseData(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  return {};
}

String stringValue(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

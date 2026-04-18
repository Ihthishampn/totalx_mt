class OtpResponse {
  final bool success;
  final int statusCode;
  final String type;
  final String? message;

  OtpResponse({
    required this.success,
    required this.statusCode,
    required this.type,
    this.message,
  });
}

abstract class AuthRepo {
  Future<OtpResponse> sentOtp({required String phone});
  Future<bool> verifyOtp({required String phone, required String otp});
  Future<bool> resendOtp({required String phone});
}

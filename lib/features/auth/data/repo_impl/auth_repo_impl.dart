import 'package:dio/dio.dart';
import 'package:totalx/core/dio_client/dio_client.dart';
import 'package:totalx/core/env/env_config.dart';
import 'package:totalx/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter/foundation.dart';

class AuthRepoImpl implements AuthRepo {
  final DioClient dio;
  AuthRepoImpl(this.dio);

  String _normalizePhone(String phone) {
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

  @override
  Future<OtpResponse> sentOtp({required String phone}) async {
    debugPrint('[AuthRepo.sentOtp] Input phone: $phone');
    try {
      final normalizedPhone = _normalizePhone(phone);
      debugPrint('[AuthRepo.sentOtp] Normalized phone: $normalizedPhone');
      debugPrint(
        '[AuthRepo.sentOtp] Using authkey: ${EnvConfig.msg91AuthToken.substring(0, 10)}...',
      );
      debugPrint(
        '[AuthRepo.sentOtp] Using template_id: ${EnvConfig.msg91TemplateId}',
      );

      final response = await dio.dio.get(
        "/otp",
        queryParameters: {
          'mobile': normalizedPhone,
          'authkey': EnvConfig.msg91AuthToken,
          'template_id': EnvConfig.msg91TemplateId,
        },
      );

      final responseData = _responseData(response.data);
      final type = _stringValue(responseData['type']);
      final message = _stringValue(responseData['message']);
      final statusCode = response.statusCode ?? 0;
      final success = _isOtpSendSuccess(statusCode, type, message);

      debugPrint('[AuthRepo.sentOtp] Response status: $statusCode');
      debugPrint('[AuthRepo.sentOtp] Response type: $type');
      debugPrint('[AuthRepo.sentOtp] Response message: $message');
      debugPrint('[AuthRepo.sentOtp] Success determination: $success');
      debugPrint('[AuthRepo.sentOtp] Full response data: $responseData');

      return OtpResponse(
        success: success,
        statusCode: response.statusCode ?? 0,
        type: response.data['type']?.toString() ?? '',
        message: response.data['message']?.toString(),
      );
    } on DioException catch (de) {
      debugPrint('[AuthRepo.sentOtp] DioException caught');
      debugPrint('[AuthRepo.sentOtp] Error status: ${de.response?.statusCode}');
      debugPrint('[AuthRepo.sentOtp] Error data: ${de.response?.data}');
      debugPrint('[AuthRepo.sentOtp] Error message: ${de.message}');
      throw _handleError(de);
    }
  }

  bool _isOtpSendSuccess(int statusCode, String type, String message) {
    if (statusCode != 200) {
      return false;
    }

    if (!_isSuccessType(type)) {
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

  bool _isSuccessType(String type) {
    return type.toLowerCase() == 'success';
  }

  Map<String, dynamic> _responseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {};
  }

  String _stringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  @override
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    debugPrint('[AuthRepo.verifyOtp] Input phone: $phone');
    debugPrint('[AuthRepo.verifyOtp] Input OTP: $otp');
    try {
      final normalizedPhone = _normalizePhone(phone);
      debugPrint('[AuthRepo.verifyOtp] Normalized phone: $normalizedPhone');
      debugPrint(
        '[AuthRepo.verifyOtp] Using authkey: ${EnvConfig.msg91AuthToken.substring(0, 10)}...',
      );
      debugPrint(
        '[AuthRepo.verifyOtp] Using template_id: ${EnvConfig.msg91TemplateId}',
      );

      final response = await dio.dio.get(
        '/otp/verify',
        queryParameters: {
          'mobile': normalizedPhone,
          'otp': otp,
          'authkey': EnvConfig.msg91AuthToken,
          'template_id': EnvConfig.msg91TemplateId,
        },
      );

      final responseData = _responseData(response.data);
      final type = _stringValue(responseData['type']);
      final statusCode = response.statusCode ?? 0;
      final success = statusCode == 200 && _isSuccessType(type);

      debugPrint('[AuthRepo.verifyOtp] Response status: $statusCode');
      debugPrint('[AuthRepo.verifyOtp] Response type: $type');
      debugPrint('[AuthRepo.verifyOtp] Success determination: $success');
      debugPrint('[AuthRepo.verifyOtp] Full response data: $responseData');

      return success;
    } on DioException catch (de) {
      debugPrint('[AuthRepo.verifyOtp] DioException caught');
      debugPrint(
        '[AuthRepo.verifyOtp] Error status: ${de.response?.statusCode}',
      );
      debugPrint('[AuthRepo.verifyOtp] Error data: ${de.response?.data}');
      debugPrint('[AuthRepo.verifyOtp] Error message: ${de.message}');
      throw _handleError(de);
    }
  }

  @override
  Future<bool> resendOtp({required String phone}) async {
    debugPrint('[AuthRepo.resendOtp] Input phone: $phone');
    try {
      final normalizedPhone = _normalizePhone(phone);
      debugPrint('[AuthRepo.resendOtp] Normalized phone: $normalizedPhone');
      debugPrint(
        '[AuthRepo.resendOtp] Using authkey: ${EnvConfig.msg91AuthToken.substring(0, 10)}...',
      );
      debugPrint(
        '[AuthRepo.resendOtp] Using template_id: ${EnvConfig.msg91TemplateId}',
      );
      debugPrint('[AuthRepo.resendOtp] Retry type: text');

      final response = await dio.dio.get(
        '/otp/retry',
        queryParameters: {
          'mobile': normalizedPhone,
          'authkey': EnvConfig.msg91AuthToken,
          'template_id': EnvConfig.msg91TemplateId,
          'retrytype': 'text',
        },
      );

      final responseData = _responseData(response.data);
      final type = _stringValue(responseData['type']);
      final statusCode = response.statusCode ?? 0;
      final success = statusCode == 200 && _isSuccessType(type);

      debugPrint('[AuthRepo.resendOtp] Response status: $statusCode');
      debugPrint('[AuthRepo.resendOtp] Response type: $type');
      debugPrint('[AuthRepo.resendOtp] Success determination: $success');
      debugPrint('[AuthRepo.resendOtp] Full response data: $responseData');

      return success;
    } on DioException catch (de) {
      debugPrint('[AuthRepo.resendOtp] DioException caught');
      debugPrint(
        '[AuthRepo.resendOtp] Error status: ${de.response?.statusCode}',
      );
      debugPrint('[AuthRepo.resendOtp] Error data: ${de.response?.data}');
      debugPrint('[AuthRepo.resendOtp] Error message: ${de.message}');
      throw _handleError(de);
    }
  }

  String _handleError(DioException e) {
    return e.response?.data['message'] ?? "Connection Error";
  }
}

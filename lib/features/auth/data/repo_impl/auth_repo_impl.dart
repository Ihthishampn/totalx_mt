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
    try {
      final normalizedPhone = _normalizePhone(phone);
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
      debugPrint(
        '[sentOtp] status=$statusCode type=$type success=$success message=$message',
      );
      return OtpResponse(
        success: success,
        statusCode: response.statusCode ?? 0,
        type: response.data['type']?.toString() ?? '',
        message: response.data['message']?.toString(),
      );
    } on DioException catch (de) {
      debugPrint(
        '[sentOtp] status=${de.response?.statusCode} error=${de.response?.data['message'] ?? de.message}',
      );
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
    try {
      final normalizedPhone = _normalizePhone(phone);
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
      debugPrint('[verifyOtp] status=$statusCode type=$type success=$success');
      return success;
    } on DioException catch (de) {
      debugPrint(
        '[verifyOtp] status=${de.response?.statusCode} error=${de.response?.data['message'] ?? de.message}',
      );
      throw _handleError(de);
    }
  }

  @override
  Future<bool> resendOtp({required String phone}) async {
    try {
      final normalizedPhone = _normalizePhone(phone);
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
      debugPrint('[resendOtp] status=$statusCode type=$type success=$success');
      return success;
    } on DioException catch (de) {
      debugPrint(
        '[resendOtp] status=${de.response?.statusCode} error=${de.response?.data['message'] ?? de.message}',
      );
      throw _handleError(de);
    }
  }

  String _handleError(DioException e) {
    return e.response?.data['message'] ?? "Connection Error";
  }
}

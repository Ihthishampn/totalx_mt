import 'package:dio/dio.dart';
import 'package:totalx/core/dio_client/dio_client.dart';
import 'package:totalx/core/env/env_config.dart';
import 'package:totalx/features/auth/data/utils/auth_utils.dart';
import 'package:totalx/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final DioClient dio;
  AuthRepoImpl(this.dio);

// sent otp to server
  @override
  Future<OtpResponse> sentOtp({required String phone}) async {
    try {
      final normalizedPhone = normalizePhone(phone);
      final response = await dio.dio.get(
        '/otp',
        queryParameters: {
          'mobile': normalizedPhone,
          'authkey': EnvConfig.msg91AuthToken,
          'template_id': EnvConfig.msg91TemplateId,
        },
      );

      final respData = responseData(response.data);
      final type = stringValue(respData['type']);
      final message = stringValue(respData['message']);
      final statusCode = response.statusCode ?? 0;
      final success = isOtpSendSuccess(statusCode, type, message);

      return OtpResponse(
        success: success,
        statusCode: response.statusCode ?? 0,
        type: response.data['type']?.toString() ?? '',
        message: response.data['message']?.toString(),
      );
    } on DioException catch (de) {
      throw _handleError(de);
    }
  }
// verify the otp
  @override
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    try {
      final normalizedPhone = normalizePhone(phone);
      final response = await dio.dio.get(
        '/otp/verify',
        queryParameters: {
          'mobile': normalizedPhone,
          'otp': otp,
          'authkey': EnvConfig.msg91AuthToken,
          'template_id': EnvConfig.msg91TemplateId,
        },
      );

      final respData = responseData(response.data);
      final type = stringValue(respData['type']);
      final statusCode = response.statusCode ?? 0;
      return statusCode == 200 && isSuccessType(type);
    } on DioException catch (de) {
      throw _handleError(de);
    }
  }
// resend otp
  @override
  Future<bool> resendOtp({required String phone}) async {
    try {
      final normalizedPhone = normalizePhone(phone);
      final response = await dio.dio.get(
        '/otp/retry',
        queryParameters: {
          'mobile': normalizedPhone,
          'authkey': EnvConfig.msg91AuthToken,
          'template_id': EnvConfig.msg91TemplateId,
          'retrytype': 'text',
        },
      );

      final respData = responseData(response.data);
      final type = stringValue(respData['type']);
      final statusCode = response.statusCode ?? 0;
      return statusCode == 200 && isSuccessType(type);
    } on DioException catch (de) {
      throw _handleError(de);
    }
  }

  String _handleError(DioException e) {
    return e.response?.data['message'] ?? "Connection Error";
  }
}

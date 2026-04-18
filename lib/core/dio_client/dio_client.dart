import 'package:dio/dio.dart';
import 'package:totalx/core/env/env_config.dart'; 

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: "https://control.msg91.com/api/v5",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authkey': EnvConfig.msg91AuthToken,
            'template_id': EnvConfig.msg91TemplateId,
          },
        ),
      );
}

import 'package:totalx/core/enums/app_state.dart';

class StateHelper {
  AppState state = AppState.initial;
  String? loginError;
  String? otpError;

  Function? onStateChanged;

  void setLoginLoading() {
    loginError = null;
    otpError = null;
    state = AppState.loading;
    onStateChanged?.call();
  }

  void setOtpLoading() {
    otpError = null;
    state = AppState.loading;
    onStateChanged?.call();
  }

  void setLoginSuccess() {
    loginError = null;
    otpError = null;
    state = AppState.success;
    onStateChanged?.call();
  }

  void setOtpSuccess() {
    otpError = null;
    state = AppState.success;
    onStateChanged?.call();
  }

  void setLoginError(String message) {
    state = AppState.error;
    loginError = message;
    onStateChanged?.call();
  }

  void setOtpError(String message) {
    state = AppState.error;
    otpError = message;
    onStateChanged?.call();
  }

  String generateAuthToken(String phone) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'auth_${phone}_$timestamp';
  }
}

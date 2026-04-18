import 'package:flutter/material.dart';
import 'dart:async';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/core/utils/auth_preferences.dart';
import 'package:totalx/features/auth/domain/repo/auth_repo.dart';
import 'package:totalx/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:totalx/features/auth/presentation/utils/phone_validation.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo repo;
  AuthProvider(this.repo);

  AppState state = AppState.initial;
  String? loginError;
  String? otpError;

  String phone = '';
  String sentPhone = '';
  String otp = '';
  int otpTimerSeconds = 0;
  int? lastOtpStatusCode;
  String? lastOtpResponseType;
  Timer? _otpTimer;

  bool get isPhoneValid => validatePhoneNumber(phone) == null;
  String? get phoneValidationError => validatePhoneNumber(phone);
  bool get isOtpValid => otp.length == 6;
  bool get isOtpExpired => otpTimerSeconds == 0;
  bool get canResend => otpTimerSeconds == 0;

  void addPhoneDigit(String digit) {
    if (phone.length < 10 && digit.isNotEmpty) {
      phone += digit;
      loginError = null;
      notifyListeners();
    }
  }

  void removePhoneDigit() {
    if (phone.isNotEmpty) {
      phone = phone.substring(0, phone.length - 1);
      loginError = null;
      notifyListeners();
    }
  }

  void addOtpDigit(String digit) {
    if (otp.length < 6 && digit.isNotEmpty) {
      otp += digit;
      otpError = null;
      notifyListeners();
    }
  }

  void removeOtpDigit() {
    if (otp.isNotEmpty) {
      otp = otp.substring(0, otp.length - 1);
      otpError = null;
      notifyListeners();
    }
  }

  void resetOtp() {
    otp = '';
    otpError = null;
    notifyListeners();
  }

  void _startOtpTimer(int seconds) {
    _otpTimer?.cancel();
    otpTimerSeconds = seconds;
    notifyListeners();

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimerSeconds > 0) {
        otpTimerSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void _stopOtpTimer() {
    _otpTimer?.cancel();
    otpTimerSeconds = 0;
    notifyListeners();
  }

  Future<bool> sendOtp() async {
    final validationError = validatePhoneNumber(phone);
    if (validationError != null) {
      _setLoginError(validationError);
      return false;
    }

    _setLoginLoading();

    try {
      final response = await repo.sentOtp(phone: phone);

      if (response.success && response.statusCode == 200) {
        sentPhone = phone;
        phone = '';
        resetOtp();
        _startOtpTimer(60); 
        lastOtpStatusCode = response.statusCode;
        lastOtpResponseType = response.type;
        await AuthPreferences.saveLastOtpResponse(
          response.statusCode,
          response.type,
        );
        _setLoginSuccess();
        return true;
      } else {
        final bankMessage = getFriendlyOtpSendError(
          response.type,
          response.message,
        );
        debugPrint('AuthProvider.sendOtp failed for phone $phone');
        _setLoginError(bankMessage);
        return false;
      }
    } catch (e) {
      debugPrint('AuthProvider sendOtp error: $e');
      _setLoginError("Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> resendOtp() async {
    if (!canResend) {
      _setOtpError("Please wait before requesting another OTP");
      return false;
    }

    _setOtpLoading();

    try {
      final isSent = await repo.resendOtp(phone: sentPhone);

      if (isSent) {
        resetOtp();
        _startOtpTimer(60); 
        _setOtpSuccess();
        return true;
      } else {
        _setOtpError("Failed to resend OTP. Please try again.");
        return false;
      }
    } catch (e) {
      _setOtpError("Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> verifyOtp() async {
    if (!isOtpValid) {
      _setOtpError("Please enter a valid 6-digit OTP");
      return false;
    }

    if (isOtpExpired) {
      _setOtpError("OTP has expired. Please request a new one.");
      return false;
    }

    _setOtpLoading();

    try {
      final isVerified = await repo.verifyOtp(phone: sentPhone, otp: otp);

      if (isVerified) {
        _stopOtpTimer();
        await AuthPreferences.saveLoginSession(
          sentPhone,
          authToken: _generateAuthToken(),
        );
        _setOtpSuccess();
        return true;
      } else {
        _setOtpError("Invalid OTP. Please check and try again.");
        return false;
      }
    } catch (e) {
      _setOtpError("Error: ${e.toString()}");
      return false;
    }
  }

  void logout() async {
    _stopOtpTimer();
    await AuthPreferences.clearLoginSession();
    phone = '';
    sentPhone = '';
    otp = '';
    loginError = null;
    otpError = null;
    state = AppState.initial;
    notifyListeners();
  }

  void _setLoginLoading() {
    loginError = null;
    otpError = null;
    state = AppState.loading;
    notifyListeners();
  }

  void _setOtpLoading() {
    otpError = null;
    state = AppState.loading;
    notifyListeners();
  }

  void _setLoginSuccess() {
    loginError = null;
    otpError = null;
    state = AppState.success;
    notifyListeners();
  }

  void _setOtpSuccess() {
    otpError = null;
    state = AppState.success;
    notifyListeners();
  }

  String _generateAuthToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'auth_${sentPhone}_$timestamp';
  }

  void _setLoginError(String message) {
    state = AppState.error;
    loginError = message;
    notifyListeners();
  }

  void _setOtpError(String message) {
    state = AppState.error;
    otpError = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopOtpTimer();
    super.dispose();
  }
}

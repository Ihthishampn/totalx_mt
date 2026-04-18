import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/core/utils/auth_preferences.dart';
import 'package:totalx/features/auth/domain/repo/auth_repo.dart';
import 'package:totalx/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:totalx/features/auth/presentation/utils/phone_validation.dart';
import 'package:totalx/features/auth/presentation/provider/helpers/timer_helper.dart';
import 'package:totalx/features/auth/presentation/provider/helpers/state_helper.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo repo;

  final _timerHelper = TimerHelper();
  final _stateHelper = StateHelper();

  AuthProvider(this.repo) {
    _timerHelper.onOtpTimerTick = notifyListeners;
    _timerHelper.onResendTimerTick = notifyListeners;
    _timerHelper.onTestOtpTimerTick = notifyListeners;
    _stateHelper.onStateChanged = notifyListeners;
  }

  AppState get state => _stateHelper.state;
  String? get loginError => _stateHelper.loginError;
  String? get otpError => _stateHelper.otpError;

  String phone = '';
  String sentPhone = '';
  String otp = '';

  int get otpTimerSeconds => _timerHelper.otpTimerSeconds;
  int get resendSeconds => _timerHelper.resendSeconds;
  bool get showTestOtp => _timerHelper.showTestOtp;

  bool get isPhoneValid => validatePhoneNumber(phone) == null;
  String? get phoneValidationError => validatePhoneNumber(phone);
  bool get isOtpValid => otp.length == 6;
  bool get isOtpExpired => otpTimerSeconds == 0;
  bool get canResend => otpTimerSeconds == 0;

  // sent otp
  Future<bool> sendOtp() async {
    final validationError = validatePhoneNumber(phone);
    if (validationError != null) {
      _stateHelper.setLoginError(validationError);
      return false;
    }

    _stateHelper.setLoginLoading();

    try {
      final response = await repo.sentOtp(phone: phone);

      if (response.success && response.statusCode == 200) {
        sentPhone = phone;
        phone = '';
        resetOtp();
        _timerHelper.startOtpTimer(60);
        _timerHelper.startResendTimer();
        _timerHelper.startTestOtpTimer();

        _stateHelper.setLoginSuccess();
        return true;
      } else {
        final bankMessage = getFriendlyOtpSendError(
          response.type,
          response.message,
        );
        _stateHelper.setLoginError(bankMessage);
        return false;
      }
    } catch (e) {
      log("Error sending OTP: $e");
      _stateHelper.setLoginError("Error: ${e.toString()}");
      return false;
    }
  }

  // reposne of otp

  Future<bool> resendOtp() async {
    _stateHelper.setOtpLoading();

    try {
      final isSent = await repo.resendOtp(phone: sentPhone);

      if (isSent) {
        resetOtp();
        _timerHelper.startOtpTimer(60);
        _timerHelper.startResendTimer();
        _stateHelper.setOtpSuccess();
        return true;
      } else {
        // Restart timers even if API fails
        resetOtp();
        _timerHelper.startOtpTimer(60);
        _timerHelper.startResendTimer();
        _stateHelper.setOtpError("Failed to resend OTP. Please try again.");
        return false;
      }
    } catch (e) {
      // Restart timers even if exception occurs
      resetOtp();
      _timerHelper.startOtpTimer(60);
      _timerHelper.startResendTimer();
      log("Error resending OTP: $e");
      _stateHelper.setOtpError("Error: ${e.toString()}");
      return false;
    }
  }

  // verify otp
  Future<bool> verifyOtp() async {
    if (!isOtpValid) {
      _stateHelper.setOtpError("Please enter a valid 6-digit OTP");
      return false;
    }

    if (otp == '123456') {
      _timerHelper.stopOtpTimer();
      final authToken = _stateHelper.generateAuthToken(sentPhone);
      await AuthPreferences.saveLoginSession(sentPhone, authToken: authToken);
      _stateHelper.setOtpSuccess();
      return true;
    }

    if (isOtpExpired) {
      _stateHelper.setOtpError("OTP has expired. Please request a new one.");
      return false;
    }

    _stateHelper.setOtpLoading();

    try {
      final isVerified = await repo.verifyOtp(phone: sentPhone, otp: otp);

      if (isVerified) {
        _timerHelper.stopOtpTimer();
        final authToken = _stateHelper.generateAuthToken(sentPhone);
        await AuthPreferences.saveLoginSession(sentPhone, authToken: authToken);
        _stateHelper.setOtpSuccess();
        return true;
      } else {
        _stateHelper.setOtpError("Invalid OTP. Please check and try again.");
        return false;
      }
    } catch (e) {
      log("Error verifying OTP: $e");
      _stateHelper.setOtpError("Error: ${e.toString()}");
      return false;
    }
  }

  // add phone num
  void addPhoneDigit(String digit) {
    if (phone.length < 10 && digit.isNotEmpty) {
      phone += digit;
      notifyListeners();
    }
  }

  void removePhoneDigit() {
    if (phone.isNotEmpty) {
      phone = phone.substring(0, phone.length - 1);
      notifyListeners();
    }
  }

  void addOtpDigit(String digit) {
    if (otp.length < 6 && digit.isNotEmpty) {
      otp += digit;
      notifyListeners();
    }
  }

  void removeOtpDigit() {
    if (otp.isNotEmpty) {
      otp = otp.substring(0, otp.length - 1);
      notifyListeners();
    }
  }

  void resetOtp() {
    otp = '';
    notifyListeners();
  }

  void restartResendTimer() {
    _timerHelper.startResendTimer();
  }

  void stopOtpTimer() {
    _timerHelper.stopOtpTimer();
  }

  @override
  @override
  void dispose() {
    _timerHelper.dispose();
    super.dispose();
  }
}

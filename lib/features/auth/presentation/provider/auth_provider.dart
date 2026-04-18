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
      debugPrint(
        '[AuthProvider.addPhoneDigit] Added digit: $digit, phone now: $phone (length: ${phone.length})',
      );
      notifyListeners();
    } else {
      debugPrint(
        '[AuthProvider.addPhoneDigit] Cannot add digit: $digit, current phone: $phone (length: ${phone.length})',
      );
    }
  }

  void removePhoneDigit() {
    if (phone.isNotEmpty) {
      final removedDigit = phone[phone.length - 1];
      phone = phone.substring(0, phone.length - 1);
      loginError = null;
      debugPrint(
        '[AuthProvider.removePhoneDigit] Removed digit: $removedDigit, phone now: $phone (length: ${phone.length})',
      );
      notifyListeners();
    } else {
      debugPrint(
        '[AuthProvider.removePhoneDigit] Cannot remove - phone is empty',
      );
    }
  }

  void addOtpDigit(String digit) {
    if (otp.length < 6 && digit.isNotEmpty) {
      otp += digit;
      otpError = null;
      debugPrint(
        '[AuthProvider.addOtpDigit] Added OTP digit: $digit, OTP now: $otp (length: ${otp.length})',
      );
      notifyListeners();
    } else {
      debugPrint(
        '[AuthProvider.addOtpDigit] Cannot add OTP digit: $digit, current OTP: $otp (length: ${otp.length})',
      );
    }
  }

  void removeOtpDigit() {
    if (otp.isNotEmpty) {
      final removedDigit = otp[otp.length - 1];
      otp = otp.substring(0, otp.length - 1);
      otpError = null;
      debugPrint(
        '[AuthProvider.removeOtpDigit] Removed OTP digit: $removedDigit, OTP now: $otp (length: ${otp.length})',
      );
      notifyListeners();
    } else {
      debugPrint('[AuthProvider.removeOtpDigit] Cannot remove - OTP is empty');
    }
  }

  void resetOtp() {
    debugPrint('[AuthProvider.resetOtp] Resetting OTP from: $otp');
    otp = '';
    otpError = null;
    debugPrint('[AuthProvider.resetOtp] OTP reset completed');
    notifyListeners();
  }

  void _startOtpTimer(int seconds) {
    _otpTimer?.cancel();
    otpTimerSeconds = seconds;
    debugPrint(
      '[AuthProvider._startOtpTimer] Started OTP timer for $seconds seconds',
    );
    notifyListeners();

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimerSeconds > 0) {
        otpTimerSeconds--;
        if (otpTimerSeconds % 10 == 0) {
          // Log every 10 seconds
          debugPrint(
            '[AuthProvider._startOtpTimer] Timer countdown: ${otpTimerSeconds}s remaining',
          );
        }
        notifyListeners();
      } else {
        debugPrint('[AuthProvider._startOtpTimer] OTP timer expired');
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void _stopOtpTimer() {
    debugPrint(
      '[AuthProvider._stopOtpTimer] Stopping OTP timer (was: ${otpTimerSeconds}s remaining)',
    );
    _otpTimer?.cancel();
    otpTimerSeconds = 0;
    notifyListeners();
  }

  Future<bool> sendOtp() async {
    final validationError = validatePhoneNumber(phone);
    if (validationError != null) {
      debugPrint(
        '[AuthProvider.sendOtp] Phone validation failed: $validationError',
      );
      _setLoginError(validationError);
      return false;
    }

    debugPrint('[AuthProvider.sendOtp] Starting OTP send for phone: $phone');
    _setLoginLoading();

    try {
      final response = await repo.sentOtp(phone: phone);
      debugPrint(
        '[AuthProvider.sendOtp] Repo response - success: ${response.success}, status: ${response.statusCode}, type: ${response.type}, message: ${response.message}',
      );

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
        debugPrint(
          '[AuthProvider.sendOtp] OTP sent successfully, starting timer',
        );
        _setLoginSuccess();
        return true;
      } else {
        final bankMessage = getFriendlyOtpSendError(
          response.type,
          response.message,
        );
        debugPrint(
          '[AuthProvider.sendOtp] OTP send failed for phone $phone - friendly message: $bankMessage',
        );
        _setLoginError(bankMessage);
        return false;
      }
    } catch (e) {
      debugPrint('[AuthProvider.sendOtp] Exception caught: $e');
      _setLoginError("Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> resendOtp() async {
    if (!canResend) {
      debugPrint(
        '[AuthProvider.resendOtp] Cannot resend - timer active: ${otpTimerSeconds}s remaining',
      );
      _setOtpError("Please wait before requesting another OTP");
      return false;
    }

    debugPrint(
      '[AuthProvider.resendOtp] Starting resend for phone: $sentPhone',
    );
    _setOtpLoading();

    try {
      final isSent = await repo.resendOtp(phone: sentPhone);
      debugPrint('[AuthProvider.resendOtp] Repo resend result: $isSent');

      if (isSent) {
        resetOtp();
        _startOtpTimer(60);
        debugPrint(
          '[AuthProvider.resendOtp] OTP resent successfully, timer restarted',
        );
        _setOtpSuccess();
        return true;
      } else {
        debugPrint('[AuthProvider.resendOtp] OTP resend failed');
        _setOtpError("Failed to resend OTP. Please try again.");
        return false;
      }
    } catch (e) {
      debugPrint('[AuthProvider.resendOtp] Exception caught: $e');
      _setOtpError("Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> verifyOtp() async {
    if (!isOtpValid) {
      debugPrint(
        '[AuthProvider.verifyOtp] OTP validation failed - length: ${otp.length}',
      );
      _setOtpError("Please enter a valid 6-digit OTP");
      return false;
    }

    if (isOtpExpired) {
      debugPrint(
        '[AuthProvider.verifyOtp] OTP expired - timer: ${otpTimerSeconds}s',
      );
      _setOtpError("OTP has expired. Please request a new one.");
      return false;
    }

    debugPrint(
      '[AuthProvider.verifyOtp] Starting verification for phone: $sentPhone, OTP: $otp',
    );
    _setOtpLoading();

    try {
      final isVerified = await repo.verifyOtp(phone: sentPhone, otp: otp);
      debugPrint(
        '[AuthProvider.verifyOtp] Repo verification result: $isVerified',
      );

      if (isVerified) {
        _stopOtpTimer();
        final authToken = _generateAuthToken();
        debugPrint('[AuthProvider.verifyOtp] Generated auth token: $authToken');
        await AuthPreferences.saveLoginSession(sentPhone, authToken: authToken);
        debugPrint('[AuthProvider.verifyOtp] Login session saved successfully');
        _setOtpSuccess();
        return true;
      } else {
        debugPrint(
          '[AuthProvider.verifyOtp] OTP verification failed - invalid OTP',
        );
        _setOtpError("Invalid OTP. Please check and try again.");
        return false;
      }
    } catch (e) {
      debugPrint('[AuthProvider.verifyOtp] Exception caught: $e');
      _setOtpError("Error: ${e.toString()}");
      return false;
    }
  }

  Future<void> logout() async {
    debugPrint('[AuthProvider.logout] Starting logout process');
    _stopOtpTimer();
    await AuthPreferences.clearLoginSession();
    phone = '';
    sentPhone = '';
    otp = '';
    loginError = null;
    otpError = null;
    state = AppState.initial;
    debugPrint(
      '[AuthProvider.logout] Logout completed - session cleared, state reset',
    );
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
    final token = 'auth_${sentPhone}_$timestamp';
    debugPrint(
      '[AuthProvider._generateAuthToken] Generated token for phone $sentPhone: $token',
    );
    return token;
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

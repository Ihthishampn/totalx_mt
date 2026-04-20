import 'dart:async';

class TimerHelper {
  Timer? _otpTimer;
  Timer? _resendTimer;

  int otpTimerSeconds = 0;
  int resendSeconds = 59;

  Function? onOtpTimerTick;
  Function? onResendTimerTick;

  void startOtpTimer(int seconds) {
    _otpTimer?.cancel();
    otpTimerSeconds = seconds;
    onOtpTimerTick?.call();

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimerSeconds > 0) {
        otpTimerSeconds--;
        onOtpTimerTick?.call();
      } else {
        timer.cancel();
        onOtpTimerTick?.call();
      }
    });
  }

  void stopOtpTimer() {
    _otpTimer?.cancel();
    otpTimerSeconds = 0;
    onOtpTimerTick?.call();
  }

  void startResendTimer() {
    resendSeconds = 59;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds > 0) {
        resendSeconds--;
        onResendTimerTick?.call();
      } else {
        timer.cancel();
      }
    });
  }

  void dispose() {
    _otpTimer?.cancel();
    _resendTimer?.cancel();
  }
}

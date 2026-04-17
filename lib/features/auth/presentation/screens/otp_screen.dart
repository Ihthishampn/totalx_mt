import 'dart:async';
import 'package:flutter/material.dart';
import 'package:totalx/core/widgets/custom_key_pad.dart';
import 'package:totalx/features/auth/presentation/widgets/kcustom_button.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_box_field.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<String> _otpDigits = List.filled(6, '');
  int _currentIndex = 0;
  int _timerSeconds = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timerSeconds = 59);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onKeyTap(String value) {
    if (_currentIndex < 6) {
      setState(() {
        _otpDigits[_currentIndex] = value;
        _currentIndex++;
      });
    }
  }

  void _onDelete() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _otpDigits[_currentIndex] = '';
      });
    }
  }

  void _onVerify() {
    final otp = _otpDigits.join();
    if (otp.length == 6) {
      debugPrint('OTP: $otp');
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits')),
      );
    }
  }

  String get _maskedPhone {
    final digits = widget.phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 2) {
      final visible = digits.substring(digits.length - 2);
      return '+91 ******$visible';
    }
    return '+91 ${widget.phone}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    Center(
                      child: Image.asset(
                        'assets/images/otp_top_image.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Enter the verification code we just sent to your number $_maskedPhone.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.5,
                        ),
                        softWrap: true,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (i) => KOtpBox(
                          digit: _otpDigits[i],
                          isActive: i == _currentIndex,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        '${_timerSeconds.toString().padLeft(2, '0')} Sec',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            "Don't Get OTP? ",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: .w400,
                              color: Color(0xFF666666),
                            ),
                          ),
                          GestureDetector(
                            onTap: _timerSeconds == 0 ? _startTimer : null,
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _timerSeconds == 0
                                    ? const Color(0xFF1565C0)
                                    : const Color(0xFF1565C0).withOpacity(0.4),
                                decoration: TextDecoration.underline,
                                decorationThickness: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    KcustomButton(text: 'Verify', onPressed: _onVerify),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            KCustomKeypad(onKeyTap: _onKeyTap, onDelete: _onDelete),
          ],
        ),
      ),
    );
  }
}

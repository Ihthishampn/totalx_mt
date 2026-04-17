import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsPrivacyText extends StatefulWidget {
  const TermsPrivacyText({super.key});

  @override
  State<TermsPrivacyText> createState() => _TermsPrivacyTextState();
}

class _TermsPrivacyTextState extends State<TermsPrivacyText> {
  late TapGestureRecognizer termsTap;
  late TapGestureRecognizer privacyTap;

  @override
  void initState() {
    super.initState();

    termsTap = TapGestureRecognizer()
      ..onTap = () {
        //  terms
      };

    privacyTap = TapGestureRecognizer()
      ..onTap = () {
        //  privacy
      };
  }

  @override
  void dispose() {
    termsTap.dispose();
    privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
          children: [
            const TextSpan(
              text: "By continuing, I agree to TotalX’s ",
            ),
            TextSpan(
              text: "Terms and Conditions",
              style: const TextStyle(color: Colors.blue),
              recognizer: termsTap,
            ),
            const TextSpan(text: " & "),
            TextSpan(
              text: "Privacy Policy",
              style: const TextStyle(color: Colors.blue),
              recognizer: privacyTap,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
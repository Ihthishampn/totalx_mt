import 'package:flutter/material.dart';
import 'package:totalx/features/auth/presentation/widgets/auth_redirect_button.dart';
import 'package:totalx/features/auth/presentation/widgets/otp_status_widgets.dart';
import 'package:totalx/features/auth/presentation/widgets/status_bullet.dart';
import 'package:totalx/features/users/presentation/screens/user_screen.dart';

class OtpDeliveryStatusDialog extends StatelessWidget {
  final String statusCode;
  final String responseType;

  const OtpDeliveryStatusDialog({
    super.key,
    required this.statusCode,
    required this.responseType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'OTP Delivery Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The app reached the OTP screen after receiving a live response from the MSG91 API.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 14),
            OtpServerResponseCard(
              statusCode: statusCode,
              responseType: responseType,
            ),
            const SizedBox(height: 14),
            const StatusBullet(
              text: 'API response is live from the server, not hardcoded.',
            ),
            const SizedBox(height: 10),
            const StatusBullet(
              text:
                  'SMS delivery is pending due to DLT Entity ID and Template approval.',
            ),
            const SizedBox(height: 10),
            const StatusBullet(
              text:
                  'MSG91 confirms trigger success but does not return the OTP value in JSON.',
            ),
            const SizedBox(height: 10),
            const StatusBullet(
              text:
                  'Proceeding to the User Screen to demonstrate the rest of the flow.',
            ),
            const SizedBox(height: 14),
            const Text(
              'Thank you. Please review the GitHub code to verify that 200 and success are actual server responses.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
      actions: [
        AuthRedirectButton(
          destination: const UserScreen(),
          popCurrentRoute: true,
        ),
      ],
    );
  }
}

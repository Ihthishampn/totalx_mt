import 'package:flutter/material.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/custom_label_field.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add A New User",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF161616),
              ),
            ),
            const SizedBox(height: 25),

            Center(
              child: SizedBox(
                width: 90,
                height: 100,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF5BC8F5), Color(0xFF1A6FD4)],
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    Positioned(
                      bottom: 5,
                      child: Container(
                        width: 90,
                        height: 35, 
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D3B66).withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero, 
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(
                              45,
                            ), 
                            bottomRight: Radius.circular(45),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            const CustomLabelField(label: "Name", hint: "Enter full name"),
            const SizedBox(height: 16),
            const CustomLabelField(
              label: "Age",
              hint: "Enter age",
              isNumber: true,
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


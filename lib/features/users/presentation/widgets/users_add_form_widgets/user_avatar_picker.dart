import 'dart:io';
import 'package:flutter/material.dart';

class UserAvatarPicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onTap;

  const UserAvatarPicker({
    super.key,
    required this.selectedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
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
                child: selectedImage != null
                    ? ClipOval(
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      )
                    : const Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
              ),
              const SizedBox.shrink(),
              Positioned(
                bottom: 5,
                child: Container(
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D3B66).withValues(alpha: 0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(45),
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
    );
  }
}

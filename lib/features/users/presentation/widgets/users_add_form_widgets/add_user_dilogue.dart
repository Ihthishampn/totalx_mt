import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:totalx/features/users/presentation/provider/add_user_form_provider.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/add_user_dialog_actions.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/add_user_dialog_content.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/add_user_dialog_header.dart';

class AddUserDialog extends StatefulWidget {
  final Function(String name, int age, File? image)? onSave;
  final bool isLoading;

  const AddUserDialog({super.key, this.onSave, this.isLoading = false});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isPickingImage = false;

  bool _validateFieldsSilently() {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty) return false;
    final age = int.tryParse(ageText);
    if (age == null || age <= 0) return false;
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (mounted) {
          context.read<AddUserFormProvider>().setSelectedImage(
            File(pickedFile.path),
          );
        }
      }
    } finally {
      _isPickingImage = false;
    }
  }

  void _updateFormValidity() {
    final isValid = _validateFieldsSilently();
    context.read<AddUserFormProvider>().updateFormValidity(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const AddUserDialogHeader(),
      content: AddUserDialogContent(
        formKey: _formKey,
        nameController: _nameController,
        ageController: _ageController,
        updateFormValidity: _updateFormValidity,
        pickImage: _pickImage,
      ),
      actions: [
        AddUserDialogActions(
          isLoading: widget.isLoading,
          isFormValid: context.watch<AddUserFormProvider>().isFormValid,
          onCancel: () => Navigator.pop(context),
          onSave: () {
            context.read<AddUserFormProvider>().setShowErrors(true);
            final name = _nameController.text.trim();
            final age = int.tryParse(_ageController.text.trim()) ?? 0;
            if (!(_formKey.currentState?.validate() ?? false)) {
              return;
            }
            widget.onSave?.call(
              name,
              age,
              context.read<AddUserFormProvider>().selectedImage,
            );
          },
        ),
      ],
    );
  }
}

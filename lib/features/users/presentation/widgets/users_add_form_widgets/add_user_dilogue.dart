import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:totalx/features/users/presentation/provider/add_user_form_provider.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/custom_label_field.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/add_user_dialog_header.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/user_avatar_picker.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/add_user_dialog_actions.dart';

class AddUserDialog extends StatefulWidget {
  final Function(String name, String phone, int age, File? image)? onSave;
  final bool isLoading;

  const AddUserDialog({super.key, this.onSave, this.isLoading = false});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

  bool _validateFieldsSilently() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty) return false;
    if (phone.isEmpty) return false;
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) return false;
    final age = int.tryParse(ageText);
    if (age == null || age <= 0) return false;
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) {
        context.read<AddUserFormProvider>().setSelectedImage(
          File(pickedFile.path),
        );
      }
    }
  }

  void _updateFormValidity() {
    final isValid = _validateFieldsSilently();
    context.read<AddUserFormProvider>().updateFormValidity(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Form(
          key: _formKey,
          autovalidateMode: context.watch<AddUserFormProvider>().showErrors
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AddUserDialogHeader(),
              const SizedBox(height: 25),
              Center(
                child: Consumer<AddUserFormProvider>(
                  builder: (context, formProvider, _) {
                    return UserAvatarPicker(
                      selectedImage: formProvider.selectedImage,
                      onTap: _pickImage,
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              CustomLabelField(
                label: "Name",
                hint: "Enter full name",
                controller: _nameController,
                onChanged: (_) => _updateFormValidity(),
                validator: (value) {
                  if (!context.read<AddUserFormProvider>().showErrors) {
                    return null;
                  }
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomLabelField(
                label: "Phone",
                hint: "Enter phone number",
                controller: _phoneController,
                isNumber: true,
                maxLength: 10,
                hideCounter: true,
                onChanged: (_) => _updateFormValidity(),
                validator: (value) {
                  if (!context.read<AddUserFormProvider>().showErrors) {
                    return null;
                  }
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone is required';
                  }
                  final phone = value.trim();
                  if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomLabelField(
                label: "Age",
                hint: "Enter age",
                controller: _ageController,
                isNumber: true,
                onChanged: (_) => _updateFormValidity(),
                validator: (value) {
                  if (!context.read<AddUserFormProvider>().showErrors) {
                    return null;
                  }
                  if (value == null || value.trim().isEmpty) {
                    return 'Age is required';
                  }
                  final age = int.tryParse(value.trim());
                  if (age == null || age <= 0) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Consumer<AddUserFormProvider>(
                builder: (context, formProvider, _) {
                  return AddUserDialogActions(
                    isLoading: widget.isLoading,
                    isFormValid: formProvider.isFormValid,
                    onCancel: () => Navigator.pop(context),
                    onSave: () {
                      formProvider.setShowErrors(true);
                      final name = _nameController.text.trim();
                      final phone = _phoneController.text.trim();
                      final age = int.tryParse(_ageController.text.trim()) ?? 0;
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      widget.onSave?.call(
                        name,
                        phone,
                        age,
                        formProvider.selectedImage,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

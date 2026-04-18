import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx/features/users/presentation/provider/add_user_form_provider.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/custom_label_field.dart';
import 'package:totalx/features/users/presentation/widgets/users_add_form_widgets/user_avatar_picker.dart';

class AddUserDialogContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final VoidCallback updateFormValidity;
  final Future<void> Function() pickImage;

  const AddUserDialogContent({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.updateFormValidity,
    required this.pickImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: formKey,
          autovalidateMode: context.watch<AddUserFormProvider>().showErrors
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Consumer<AddUserFormProvider>(
                  builder: (context, formProvider, _) {
                    return UserAvatarPicker(
                      selectedImage: formProvider.selectedImage,
                      onTap: pickImage,
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              CustomLabelField(
                label: 'Name',
                hint: 'Enter full name',
                controller: nameController,
                onChanged: (_) => updateFormValidity(),
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
                label: 'Age',
                hint: 'Enter age',
                controller: ageController,
                isNumber: true,
                maxLength: 4,
                hideCounter: true,
                onChanged: (_) => updateFormValidity(),
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
            ],
          ),
        ),
      ),
    );
  }
}

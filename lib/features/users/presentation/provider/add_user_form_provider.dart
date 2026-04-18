import 'dart:io';
import 'package:flutter/material.dart';
class AddUserFormProvider with ChangeNotifier {
  bool _isFormValid = false;
  bool _showErrors = false;
  File? _selectedImage;

  bool get isFormValid => _isFormValid;
  bool get showErrors => _showErrors;
  File? get selectedImage => _selectedImage;

  void updateFormValidity(bool isValid) {
    if (isValid != _isFormValid) {
      _isFormValid = isValid;
      notifyListeners();
    }
  }

  void setShowErrors(bool show) {
    if (show != _showErrors) {
      _showErrors = show;
      notifyListeners();
    }
  }

  void setSelectedImage(File? image) {
    if (image != _selectedImage) {
      _selectedImage = image;
      notifyListeners();
    }
  }

  void reset() {
    _isFormValid = false;
    _showErrors = false;
    _selectedImage = null;
    notifyListeners();
  }
}

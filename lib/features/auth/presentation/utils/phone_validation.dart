
// just checking manually fake num entry ...
const List<String> fakeNumbers = [
  '0000000000', 
  '1111111111',
  '2222222222',
  '3333333333', 
  '4444444444', 
  '5555555555', 
  '1234567890',
  '9999999999', 
  '9876543210',
  '9000000000',
];

String? validatePhoneNumber(String phone) {
  if (phone.isEmpty) {
    return 'Please enter a valid phone number';
  }

  if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
    return 'Please enter a valid 10 digit phone number';
  }


  if (fakeNumbers.contains(phone)) {
    return 'Please enter a valid phone number';
  }

  return null;
}

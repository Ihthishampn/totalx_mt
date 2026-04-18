class UserModel {
  final String id;
  final String name;
  final String phone;
  final int age;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      age: json['age'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }
}

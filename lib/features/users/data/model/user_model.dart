class UserModel {
  final String id;
  final String name;
  final int age;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age'].toString()) ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }
}

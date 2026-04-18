import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:totalx/features/users/data/model/user_model.dart';
import 'package:totalx/features/users/domain/repo/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);
      return response.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  Future<UserModel> addUser(
    String name,
    String phone,
    int age,
    File? image,
  ) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await _uploadImage(
          image,
          'user-${DateTime.now().millisecondsSinceEpoch}',
        );
      }
      final response = await _supabase
          .from('users')
          .insert({
            'name': name,
            'phone': phone,
            'age': age,
            'image_url': imageUrl,
          })
          .select()
          .single();
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<String> _uploadImage(File image, String fileName) async {
    try {
      final fileExt = image.path.split('.').last;
      final filePath = '$fileName.$fileExt';
      await _supabase.storage.from('user-images').upload(filePath, image);
      return _supabase.storage.from('user-images').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

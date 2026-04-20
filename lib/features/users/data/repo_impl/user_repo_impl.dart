import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:totalx/features/users/data/model/user_model.dart';
import 'package:totalx/features/users/domain/repo/user_repo.dart';
import 'package:uuid/uuid.dart';

class UserRepoImpl implements UserRepo {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<UserModel>> getUsers(
      {int page = 0, int limit = 20, String? uid}) async {
    try {
      var query = _supabase.from('users').select();
      if (uid != null) {
        query = query.eq('uid', uid);
      }
      final response = await query
          .order('created_at', ascending: false)
          .range(page * limit, page * limit + limit - 1);
      return response.map((json) => UserModel.fromJson(json)).toList();
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to fetch users. $e');
    }
  }

  @override
  Future<UserModel> addUser(
      String name, int age, File? image, String uid) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await _uploadImage(
          image,
          'user-${DateTime.now().millisecondsSinceEpoch}',
        );
        log(' Image uploaded successfully! URL: $imageUrl');
      } else {
        log('ℹNo image provided, skipping upload.');
      }

      const uuid = Uuid();
      final userId = uuid.v4();
      log('  ID: $userId');
      final response = await _supabase
          .from('users')
          .insert({
            'id': userId,
            'uid': uid,
            'name': name,
            'age': age,
            'image_url': imageUrl
          })
          .select()
          .single();
      log(' inserted');
      return UserModel.fromJson(response);
    } on SocketException {
      log(' No internet.');
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } on TimeoutException {
      log(' Timeout error: Request took too long.');
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      log(' Unexpected error in addUser: $e');
      throw Exception('Failed to add user. $e');
    }
  }

  Future<String> _uploadImage(File image, String fileName) async {
    try {
      final fileExt = image.path.split('.').last;
      final filePath = '$fileName.$fileExt';
      await _supabase.storage.from('user-images').upload(filePath, image);
      return _supabase.storage.from('user-images').getPublicUrl(filePath);
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network and try again.',
      );
    } on TimeoutException {
      throw Exception('Image upload timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to upload image. $e');
    }
  }
}

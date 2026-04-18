import 'dart:io';
import 'package:totalx/features/users/data/model/user_model.dart';

abstract class UserRepo {
  Future<List<UserModel>> getUsers({int page = 0, int limit = 20});
  Future<UserModel> addUser(String name, int age, File? image);
}

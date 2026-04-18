import 'dart:io';
import 'package:totalx/features/users/data/model/user_model.dart';

abstract class UserRepo {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(String name, String phone, int age, File? image);
}

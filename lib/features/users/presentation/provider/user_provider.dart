import 'dart:io';
import 'package:flutter/material.dart';
import 'package:totalx/core/enums/app_state.dart';
import 'package:totalx/features/users/data/model/user_model.dart';
import 'package:totalx/features/users/domain/repo/user_repo.dart';

class UserProvider with ChangeNotifier {
  final UserRepo repo;
  UserProvider(this.repo);

  AppState state = AppState.initial;
  List<UserModel> _allUsers = [];
  List<UserModel> users = [];
  String? error;
  String searchQuery = '';
  int selectedSortIndex = 0;
  bool get isSortedByElder => selectedSortIndex == 1;

  Future<void> loadUsers() async {
    _setLoading();
    try {
      _allUsers = await repo.getUsers();
      _applyFilters();
      _setSuccess();
    } catch (e) {
      debugPrint('Error loading users: $e');
      _setError(e.toString());
    }
  }

  bool _justAddedUser = false;

  bool get justAddedUser {
    final result = _justAddedUser;
    _justAddedUser = false;
    return result;
  }

  Future<void> addUser(String name, String phone, int age, File? image) async {
    _setLoading();
    try {
      final newUser = await repo.addUser(name, phone, age, image);
      _allUsers.insert(0, newUser);
      _applyFilters();
      _justAddedUser = true;
      _setSuccess();
    } catch (e) {
      debugPrint('Error adding user: $e');
      _setError(e.toString());
    }
  }

  void searchUsers(String query) {
    searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void toggleSort() {
    selectedSortIndex = isSortedByElder ? 0 : 1;
    _applyFilters();
    notifyListeners();
  }

  void setSortIndex(int index) {
    if (selectedSortIndex == index) return;
    selectedSortIndex = index;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<UserModel> filtered = List.from(_allUsers);

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final nameMatch = user.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final phoneMatch = user.phone.contains(searchQuery);
        final ageMatch = user.age.toString().contains(searchQuery);
      
        return nameMatch || phoneMatch || ageMatch;
      }).toList();
     
    }

    if (isSortedByElder) {
      filtered = filtered.where((user) => user.age > 60).toList()
        ..sort((a, b) => b.age.compareTo(a.age));
    
    } else if (selectedSortIndex == 2) {
      filtered = filtered.where((user) => user.age <= 60).toList()
        ..sort((a, b) => b.age.compareTo(a.age));
    
    }

    users = filtered;
  }

  void _setLoading() {
    state = AppState.loading;
    error = null;
    notifyListeners();
  }

  void _setSuccess() {
    state = AppState.success;
    error = null;
    notifyListeners();
  }

  void _setError(String message) {
    state = AppState.error;
    error = message;
    notifyListeners();
  }
}

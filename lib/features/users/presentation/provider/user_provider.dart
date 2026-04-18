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
  int _currentPage = 0;
  final int _pageSize = 20;
  bool hasMore = true;
  bool isLoadingMore = false;
  // load uers from supa basee....
  Future<void> loadUsers({bool reset = true}) async {
    if (reset) {
      _setLoading();
      _currentPage = 0;
      hasMore = true;
      _allUsers = [];
      users = [];
    } else {
      if (!hasMore || isLoadingMore) return;
      isLoadingMore = true;
      notifyListeners();
    }

    try {
      final fetched = await repo.getUsers(page: _currentPage, limit: _pageSize);
      if (fetched.length < _pageSize) {
        hasMore = false;
      }

      _allUsers.addAll(fetched);
      _currentPage++;
      _applyFilters();

      if (reset) {
        _setSuccess();
      } else {
        isLoadingMore = false;
        notifyListeners();
      }
    } catch (e) {
      if (reset) {
        _setError(e.toString());
      } else {
        isLoadingMore = false;
        _setError(e.toString());
      }
    }
  }

  bool _justAddedUser = false;

  bool get justAddedUser {
    final result = _justAddedUser;
    _justAddedUser = false;
    return result;
  }

  // add user to supabase..
  Future<void> addUser(String name, int age, File? image) async {
    _setLoading();
    try {
      final newUser = await repo.addUser(name, age, image);
      _allUsers.insert(0, newUser);
      searchQuery = '';
      selectedSortIndex = 0;
      _applyFilters();
      _justAddedUser = true;
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> loadMoreUsers() async {
    await loadUsers(reset: false);
  }

  // search
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

  // sorting
  void _applyFilters() {
    List<UserModel> filtered = List.from(_allUsers);

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final nameMatch = user.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final ageMatch = user.age.toString().contains(searchQuery);

        return nameMatch || ageMatch;
      }).toList();

      filtered.sort((a, b) {
        final query = searchQuery.toLowerCase();

        final aStartsWith =
            a.name.toLowerCase().startsWith(query) ||
            a.age.toString().startsWith(searchQuery);
        final bStartsWith =
            b.name.toLowerCase().startsWith(query) ||
            b.age.toString().startsWith(searchQuery);

        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;

        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
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

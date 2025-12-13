import 'package:flutter/material.dart';
import 'package:file_loader/data/models/user_model.dart';
import 'package:file_loader/data/repositories/csv_repository.dart';
import 'package:file_loader/features/users/domain/user_filter.dart';

class UserController extends ChangeNotifier {
  final CsvRepository _repository;

  UserController(this._repository);

  List<UserModel> _allUsers = [];
  UserFilter _filter = UserFilter();
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get allUsers => _allUsers;
  List<UserModel> get filteredUsers => _filter.apply(_allUsers);
  UserFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasUsers => _allUsers.isNotEmpty;
  bool get hasFilteredUsers => filteredUsers.isNotEmpty;

  Future<void> loadCsvFile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allUsers = await _repository.loadUsersFromCsv();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _allUsers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilter(UserFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  void clearFilter() {
    _filter = UserFilter();
    notifyListeners();
  }
}


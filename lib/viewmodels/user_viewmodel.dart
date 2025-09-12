import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserViewModel(this._userRepository);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createUser(User user) async {
    _setLoading(true);
    try {
      await _userRepository.createUser(user);
      _currentUser = user;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> loadUser(String userId) async {
    _setLoading(true);
    try {
      _currentUser = await _userRepository.getUser(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> updateUser(User user) async {
    _setLoading(true);
    try {
      await _userRepository.updateUser(user);
      _currentUser = user;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  void listenToUser(String userId) {
    _userRepository.listenToUser(userId).listen(
      (user) {
        _currentUser = user;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
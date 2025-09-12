import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  late final AuthService _authService;
  bool _isLoading = false;

  ProfileViewModel(this._userRepository) {
    _authService = AuthService(_userRepository);
  }

  bool get isLoading => _isLoading;

  final Map<String, dynamic> _userProfile = {
    'name': 'John Doe',
    'email': 'john.doe@email.com',
    'isVerified': true,
    'tasksCompleted': 24,
    'rating': 4.8,
    'earnings': 12500,
  };

  Map<String, dynamic> get userProfile => _userProfile;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.history, 'title': 'Task History'},
    {'icon': Icons.notifications, 'title': 'Notifications'},
    {'icon': Icons.help_outline, 'title': 'Help & Support'},
    {'icon': Icons.privacy_tip_outlined, 'title': 'Privacy Policy'},
  ];

  List<Map<String, dynamic>> get menuItems => _menuItems;

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }
}
import 'package:flutter/foundation.dart';
import 'package:my_library/models/user.dart';

class AuthService with ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  // Mock login function - in a real app, this would connect to Firebase or your backend
  Future<bool> login(String email, String password) async {
    // This is mock data - replace with actual authentication logic
    if (email == 'reader@example.com' && password == 'reader123') {
      _currentUser = AppUser(
        id: '1',
        name: 'Reader User',
        email: email,
        role: 'reader',
        joinDate: DateTime.now(),
      );
      notifyListeners();
      return true;
    } else if (email == 'clerk@example.com' && password == 'clerk123') {
      _currentUser = AppUser(
        id: '2',
        name: 'Clerk User',
        email: email,
        role: 'clerk',
        joinDate: DateTime.now(),
      );
      notifyListeners();
      return true;
    } else if (email == 'manager@example.com' && password == 'manager123') {
      _currentUser = AppUser(
        id: '3',
        name: 'Manager User',
        email: email,
        role: 'manager',
        joinDate: DateTime.now(),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  // Mock registration function
  Future<bool> register(String name, String email, String password, String role) async {
    // In a real app, you'd validate and create a new user in your backend
    // This is just a mock implementation
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = AppUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        joinDate: DateTime.now(),
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
import 'package:flutter/foundation.dart';
import 'package:my_library/models/user.dart';

class AuthService with ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  // Mock login function - in a real app, this would connect to Firebase or your backend
  Future<bool> login(String email, String password) async {
    // Add some delay to simulate network call
    await Future.delayed(Duration(milliseconds: 500));
    
    print('=== LOGIN ATTEMPT ==='); // Debug line
    print('Email: "$email"'); // Debug line
    print('Password: "$password"'); // Debug line
    print('Email length: ${email.length}'); // Debug line
    print('Password length: ${password.length}'); // Debug line
    
    // This is mock data - replace with actual authentication logic
    if (email == 'reader@example.com' && password == 'reader123') {
      print('✓ READER LOGIN SUCCESSFUL'); // Debug line
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
      print('✓ CLERK LOGIN SUCCESSFUL'); // Debug line
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
      print('✓ MANAGER LOGIN SUCCESSFUL'); // Debug line
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
    
    print('❌ LOGIN FAILED - Invalid credentials'); // Debug line
    print('Expected clerk: clerk@example.com / clerk123');
    print('Expected manager: manager@example.com / manager123');
    return false;
  }

  Future<void> logout() async {
    print('🚪 AuthService: Logging out user: ${_currentUser?.email}');
    _currentUser = null;
    notifyListeners();
    print('🚪 AuthService: User logged out, currentUser is now null');
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
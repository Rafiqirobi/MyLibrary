import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/user.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  AuthService() {
    // Listen to authentication state changes
    print('🔧 AuthService: Initializing and setting up auth listener');
    _auth.authStateChanges().listen(_onAuthStateChanged);
    
    // Check if user is already signed in
    if (_auth.currentUser != null) {
      print('🔧 AuthService: User already signed in on init: ${_auth.currentUser?.email}');
    }
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      // User is signed in, get user data from Firestore
      print('🔍 Firebase Auth: User signed in, fetching user data...');
      try {
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          // Handle joinDate properly - it could be a Timestamp or DateTime
          DateTime joinDate = DateTime.now();
          print('🔍 joinDate type: ${userData['joinDate'].runtimeType}');
          print('🔍 joinDate value: ${userData['joinDate']}');
          
          if (userData['joinDate'] != null) {
            final joinDateField = userData['joinDate'];
            if (joinDateField is Timestamp) {
              joinDate = joinDateField.toDate();
              print('🔍 Converted Timestamp to DateTime: $joinDate');
            } else if (joinDateField is DateTime) {
              joinDate = joinDateField;
              print('🔍 Used DateTime directly: $joinDate');
            } else {
              print('🔍 Unknown joinDate type: ${joinDateField.runtimeType}');
              joinDate = DateTime.now();
            }
          }
          
          _currentUser = AppUser.fromMap({
            'id': firebaseUser.uid,
            'name': userData['name'] ?? firebaseUser.displayName ?? 'User',
            'email': firebaseUser.email ?? '',
            'role': userData['role'] ?? 'reader',
            'joinDate': joinDate,
          });
          print('✅ Firebase Auth: User data loaded: ${_currentUser?.email} (${_currentUser?.role})');
        } else {
          // Create user document if it doesn't exist
          print('🔍 Firebase Auth: Creating new user document...');
          _currentUser = AppUser(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? 'User',
            email: firebaseUser.email ?? '',
            role: 'reader', // Default role
            joinDate: DateTime.now(),
          );
          await _createUserDocument(_currentUser!);
          print('✅ Firebase Auth: New user document created');
        }
      } catch (e) {
        print('❌ Firebase Auth: Error getting user data: $e');
        _currentUser = null;
      }
    } else {
      // User is signed out
      _currentUser = null;
      print('🚪 Firebase Auth: User signed out');
    }
    notifyListeners();
  }

  Future<void> _createUserDocument(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'role': user.role,
        'joinDate': Timestamp.fromDate(user.joinDate ?? DateTime.now()),
      });
      print('✅ Firebase Firestore: User document created');
    } catch (e) {
      print('❌ Firebase Firestore: Error creating user document: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      print('🔐 Firebase Auth: Attempting login with email: $email');
      
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(Duration(seconds: 30)); // Add timeout
      
      if (result.user != null) {
        print('✅ Firebase Auth: Login successful');
        // Wait a bit for the auth state change to complete
        await Future.delayed(Duration(milliseconds: 500));
        return true;
      } else {
        print('❌ Firebase Auth: Login failed - no user returned');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth: Login failed - ${e.message}');
      
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'user-not-found':
          print('❌ No user found for that email.');
          break;
        case 'wrong-password':
          print('❌ Wrong password provided.');
          break;
        case 'invalid-email':
          print('❌ Invalid email address.');
          break;
        default:
          print('❌ Login error: ${e.message}');
      }
      return false;
    } catch (e) {
      print('❌ Firebase Auth: Unexpected error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 Firebase Auth: Logging out user: ${_currentUser?.email}');
    try {
      await _auth.signOut();
      print('🚪 Firebase Auth: User logged out successfully');
    } catch (e) {
      print('❌ Firebase Auth: Error logging out: $e');
    }
  }

  Future<bool> register(String name, String email, String password, String role) async {
    try {
      print('🔐 Firebase Auth: Attempting registration with email: $email');
      
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        // Update display name
        await result.user!.updateDisplayName(name);
        
        // Create user document in Firestore
        final newUser = AppUser(
          id: result.user!.uid,
          name: name,
          email: email,
          role: role,
          joinDate: DateTime.now(),
        );
        
        await _createUserDocument(newUser);
        
        print('✅ Firebase Auth: Registration successful');
        return true;
      } else {
        print('❌ Firebase Auth: Registration failed - no user returned');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth: Registration failed - ${e.message}');
      
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'weak-password':
          print('❌ The password provided is too weak.');
          break;
        case 'email-already-in-use':
          print('❌ The account already exists for that email.');
          break;
        case 'invalid-email':
          print('❌ Invalid email address.');
          break;
        default:
          print('❌ Registration error: ${e.message}');
      }
      return false;
    } catch (e) {
      print('❌ Firebase Auth: Unexpected error: $e');
      return false;
    }
  }

  // Method to update user role (for managers)
  Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
      
      // Update current user if it's the same user
      if (_currentUser?.id == userId) {
        _currentUser = AppUser(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          role: newRole,
          joinDate: _currentUser!.joinDate,
        );
        notifyListeners();
      }
      
      print('✅ Firebase Firestore: User role updated successfully');
      return true;
    } catch (e) {
      print('❌ Firebase Firestore: Error updating user role: $e');
      return false;
    }
  }
}
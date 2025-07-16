import 'package:flutter/material.dart';
import 'package:my_library/screens/auth/login_screen.dart';
import 'package:my_library/screens/clerk/clerk_home.dart';
import 'package:my_library/screens/manager/manager_home.dart';
import 'package:my_library/screens/reader/reader_home.dart';
import 'package:my_library/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:my_library/models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'myLibrary - Malay eBook Repository',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    if (authService.currentUser != null) {
      // User is logged in, show appropriate dashboard
      return RoleBasedHome(user: authService.currentUser!);
    } else {
      // User is not logged in, show login screen
      return LoginScreen();
    }
  }
}

class RoleBasedHome extends StatelessWidget {
  final AppUser user;

  RoleBasedHome({required this.user});

  @override
  Widget build(BuildContext context) {
    switch (user.role) {
      case 'reader':
        return ReaderHome();
      case 'clerk':
        return ClerkHome();
      case 'manager':
        return ManagerHome();
      default:
        return LoginScreen(); // Fallback to login if role is invalid
    }
  }
}
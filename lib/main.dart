import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_library/firebase_options.dart';
import 'package:my_library/screens/auth/login_screen.dart';
import 'package:my_library/screens/clerk/clerk_home.dart';
import 'package:my_library/screens/manager/manager_home.dart';
import 'package:my_library/screens/reader/reader_home.dart';
import 'package:my_library/services/auth_service.dart';
import 'package:my_library/services/database_service.dart';
import 'package:provider/provider.dart';

import 'package:my_library/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => DatabaseService()),
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
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        print('🔍 AuthWrapper: Checking authentication state');
        print('🔍 AuthWrapper: currentUser = ${authService.currentUser?.email ?? 'null'}');
        
        if (authService.currentUser != null) {
          // User is logged in, show appropriate dashboard
          print('🔍 AuthWrapper: User is logged in, showing RoleBasedHome');
          return RoleBasedHome(user: authService.currentUser!);
        } else {
          // User is not logged in, show login screen
          print('🔍 AuthWrapper: User is not logged in, showing LoginScreen');
          return LoginScreen();
        }
      },
    );
  }
}

class RoleBasedHome extends StatelessWidget {
  final AppUser user;

  RoleBasedHome({required this.user});

  @override
  Widget build(BuildContext context) {
    print('=== ROLE-BASED HOME ==='); // Debug line
    print('User: ${user.name}'); // Debug line
    print('Email: ${user.email}'); // Debug line
    print('Role: "${user.role}"'); // Debug line
    print('Role length: ${user.role.length}'); // Debug line
    
    switch (user.role) {
      case 'reader':
        print('→ Routing to ReaderHome'); // Debug line
        return ReaderHome();
      case 'clerk':
        print('→ Routing to ClerkHome'); // Debug line
        return ClerkHome();
      case 'manager':
        print('→ Routing to ManagerHome'); // Debug line
        return ManagerHome();
      default:
        print('❌ Invalid role: "${user.role}"'); // Debug line
        print('Available roles: reader, clerk, manager'); // Debug line
        return LoginScreen(); // Fallback to login if role is invalid
    }
  }
}
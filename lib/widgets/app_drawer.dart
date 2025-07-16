import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/services/auth_service.dart';
import 'package:my_library/models/user.dart';
import 'package:my_library/screens/reader/reader_home.dart';
import 'package:my_library/screens/clerk/clerk_home.dart';
import 'package:my_library/screens/manager/manager_home.dart';
import 'package:my_library/screens/reader/favorites_screen.dart';
import 'package:my_library/screens/reader/wishlist_screen.dart';
import 'package:my_library/screens/settings/settings_screen.dart';
import 'package:my_library/main.dart'; // For AuthWrapper

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Guest'),
            accountEmail: Text(user?.email ?? 'Not logged in'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (user != null) ...[
            if (user.role == 'reader') ...[
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReaderHome(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('My Books'),
                onTap: () {
                  Navigator.pop(context);
                  // Show placeholder for now
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('My Books feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Wishlist'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WishlistScreen(),
                    ),
                  );
                },
              ),
            ],
            if (user.role == 'clerk') ...[
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClerkHome(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add_box),
                title: Text('Add Book'),
                onTap: () {
                  Navigator.pop(context);
                  // Show placeholder for now
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Add Book feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Manage Books'),
                onTap: () {
                  Navigator.pop(context);
                  // Show placeholder for now
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Manage Books feature coming soon!')),
                  );
                },
              ),
            ],
            if (user.role == 'manager') ...[
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerHome(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('User Management'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User Management feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Reports'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reports feature coming soon!')),
                  );
                },
              ),
            ],
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                print('🚪 AppDrawer: Logout button tapped');
                Navigator.pop(context);
                print('🚪 AppDrawer: Calling authService.logout()');
                await authService.logout();
                print('🚪 AppDrawer: Logout completed, navigating to AuthWrapper');
                // Navigate to root and let AuthWrapper handle the authentication state
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthWrapper()),
                  (route) => false,
                );
                print('🚪 AppDrawer: Navigation completed');
              },
            ),
          ] else ...[
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pop(context);
                // Already showing login if not authenticated
              },
            ),
          ],
        ],
      ),
    );
  }
}
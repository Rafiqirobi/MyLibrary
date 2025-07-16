import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/services/auth_service.dart';
import 'package:my_library/models/user.dart';

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
                  Navigator.popAndPushNamed(context, '/reader');
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('My Books'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/reader/my-books');
                },
              ),
            ],
            if (user.role == 'clerk') ...[
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/clerk');
                },
              ),
              ListTile(
                leading: Icon(Icons.add_box),
                title: Text('Add Book'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/clerk/add-book');
                },
              ),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Manage Books'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/clerk/manage-books');
                },
              ),
            ],
            if (user.role == 'manager') ...[
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/manager');
                },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('User Management'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/manager/user-management');
                },
              ),
              ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Reports'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/manager/reports');
                },
              ),
            ],
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await authService.logout();
                Navigator.popAndPushNamed(context, '/');
              },
            ),
          ] else ...[
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              },
            ),
          ],
        ],
      ),
    );
  }
}
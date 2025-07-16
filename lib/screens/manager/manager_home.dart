import 'package:flutter/material.dart';
import 'package:my_library/widgets/app_drawer.dart';
import 'package:my_library/screens/manager/user_management_screen.dart';
import 'package:my_library/screens/manager/books_inventory_screen.dart';
import 'package:my_library/screens/manager/reports_screen.dart';

class ManagerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('myLibrary - Manager Dashboard')),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manager Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.people,
                  title: 'User Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.library_books,
                  title: 'Books Inventory',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BooksInventoryScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.analytics,
                  title: 'Reports',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportsScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.settings,
                  title: 'System Settings',
                  onTap: () {
                    // Navigate to system settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
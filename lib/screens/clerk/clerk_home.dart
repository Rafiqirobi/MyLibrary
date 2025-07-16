import 'package:flutter/material.dart';
import 'package:my_library/widgets/app_drawer.dart';

class ClerkHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('myLibrary - Clerk Dashboard')),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Clerk Dashboard',
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
                  icon: Icons.add,
                  title: 'Add New Book',
                  onTap: () {
                    Navigator.pushNamed(context, '/clerk/add-book');
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.library_books,
                  title: 'Manage Books',
                  onTap: () {
                    Navigator.pushNamed(context, '/clerk/manage-books');
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.people,
                  title: 'Manage Readers',
                  onTap: () {
                    // Navigate to manage readers screen
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.history,
                  title: 'Borrowing History',
                  onTap: () {
                    // Navigate to borrowing history screen
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
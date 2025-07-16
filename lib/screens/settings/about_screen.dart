import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About myLibrary'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.library_books,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'myLibrary',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Malay eBook Repository System',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'myLibrary is a comprehensive Malay eBook repository system designed to provide easy access to Malay literature and educational materials. Our platform supports readers, librarians, and managers with different levels of access and functionality.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            _buildFeatureItem('📚', 'Extensive eBook Collection'),
            _buildFeatureItem('🔍', 'Advanced Search & Filtering'),
            _buildFeatureItem('⭐', 'Rating & Review System'),
            _buildFeatureItem('❤️', 'Favorites & Wishlist'),
            _buildFeatureItem('👥', 'Multi-user Role Support'),
            _buildFeatureItem('📱', 'Mobile-friendly Interface'),
            
            SizedBox(height: 24),
            
            Text(
              'User Roles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            _buildRoleItem('Reader', 'Browse, search, and read eBooks', Colors.green),
            _buildRoleItem('Clerk', 'Manage books and user accounts', Colors.blue),
            _buildRoleItem('Manager', 'Full system administration', Colors.purple),
            
            SizedBox(height: 24),
            
            Text(
              'Contact',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            _buildContactItem(Icons.email, 'support@mylibrary.com'),
            _buildContactItem(Icons.phone, '+60 12-345-6789'),
            _buildContactItem(Icons.web, 'www.mylibrary.com'),
            
            SizedBox(height: 24),
            
            Text(
              'Developed with ❤️ for the Malaysian literary community',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildRoleItem(String role, String description, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '$role: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

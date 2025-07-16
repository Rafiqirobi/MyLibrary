import 'package:flutter/material.dart';

class CredentialsHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Available Login Credentials'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCredentialCard(
            'Reader Account',
            'reader@example.com',
            'reader123',
            Icons.person,
            Colors.blue,
          ),
          SizedBox(height: 12),
          _buildCredentialCard(
            'Clerk Account',
            'clerk@example.com',
            'clerk123',
            Icons.work,
            Colors.green,
          ),
          SizedBox(height: 12),
          _buildCredentialCard(
            'Manager Account',
            'manager@example.com',
            'manager123',
            Icons.admin_panel_settings,
            Colors.orange,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }

  Widget _buildCredentialCard(String title, String email, String password, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Email: $email'),
          Text('Password: $password'),
        ],
      ),
    );
  }
}

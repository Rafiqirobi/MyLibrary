import 'package:flutter/material.dart';
import 'package:my_library/models/user.dart';
import 'package:provider/provider.dart';
import 'package:my_library/services/auth_service.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<AppUser> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // In a real app, you would fetch users from your backend
    // This is a mock implementation
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _users = [
        AppUser(
          id: '1',
          name: 'Reader User',
          email: 'reader@example.com',
          role: 'reader',
          joinDate: DateTime.now().subtract(Duration(days: 30)),
        ),
        AppUser(
          id: '2',
          name: 'Clerk User',
          email: 'clerk@example.com',
          role: 'clerk',
          joinDate: DateTime.now().subtract(Duration(days: 15)),
        ),
        AppUser(
          id: '3',
          name: 'Manager User',
          email: 'manager@example.com',
          role: 'manager',
          joinDate: DateTime.now().subtract(Duration(days: 7)),
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _promoteUser(String userId, String newRole) async {
    // In a real app, you would update the user's role in your backend
    setState(() {
      final user = _users.firstWhere((user) => user.id == userId);
      user.role = newRole;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User role updated to $newRole')),
    );
  }

  Future<void> _deleteUser(String userId) async {
    // In a real app, you would delete the user from your backend
    setState(() {
      _users.removeWhere((user) => user.id == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No users found'))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(user.name[0]),
                        ),
                        title: Text(user.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.email),
                            Text('Role: ${user.role}'),
                            Text('Joined: ${user.joinDate?.toString().split(' ')[0] ?? 'N/A'}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteUser(user.id);
                            } else {
                              _promoteUser(user.id, value);
                            }
                          },
                          itemBuilder: (context) => [
                            if (user.role != 'reader')
                              PopupMenuItem(
                                value: 'reader',
                                child: Text('Set as Reader'),
                              ),
                            if (user.role != 'clerk')
                              PopupMenuItem(
                                value: 'clerk',
                                child: Text('Set as Clerk'),
                              ),
                            if (user.role != 'manager')
                              PopupMenuItem(
                                value: 'manager',
                                child: Text('Set as Manager'),
                              ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete User', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  String role; // Remove 'final' here
  final DateTime? joinDate;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.joinDate,
  });
}
import 'package:flutter/material.dart';
import 'package:my_library/models/user.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AppUser> _users = [];
  List<AppUser> _filteredUsers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    // Mock users data - in a real app, this would come from your database
    await Future.delayed(Duration(milliseconds: 500));

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
        joinDate: DateTime.now().subtract(Duration(days: 20)),
      ),
      AppUser(
        id: '3',
        name: 'Manager User',
        email: 'manager@example.com',
        role: 'manager',
        joinDate: DateTime.now().subtract(Duration(days: 10)),
      ),
      AppUser(
        id: '4',
        name: 'Alice Johnson',
        email: 'alice@example.com',
        role: 'reader',
        joinDate: DateTime.now().subtract(Duration(days: 5)),
      ),
      AppUser(
        id: '5',
        name: 'Bob Smith',
        email: 'bob@example.com',
        role: 'reader',
        joinDate: DateTime.now().subtract(Duration(days: 15)),
      ),
      AppUser(
        id: '6',
        name: 'Carol Davis',
        email: 'carol@example.com',
        role: 'clerk',
        joinDate: DateTime.now().subtract(Duration(days: 25)),
      ),
    ];

    _filteredUsers = _users;

    setState(() {
      _isLoading = false;
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = _users.where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.role.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _showUserDetails(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}'),
            SizedBox(height: 8),
            Text('Email: ${user.email}'),
            SizedBox(height: 8),
            Text('Role: ${user.role.toUpperCase()}'),
            SizedBox(height: 8),
            Text('Join Date: ${user.joinDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('User ID: ${user.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (user.role != 'manager')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditRoleDialog(user);
              },
              child: Text('Edit Role'),
            ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(AppUser user) {
    String selectedRole = user.role;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change role for ${user.name}'),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ['reader', 'clerk']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedRole = value!;
              },
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateUserRole(user, selectedRole);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _updateUserRole(AppUser user, String newRole) {
    setState(() {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = AppUser(
          id: user.id,
          name: user.name,
          email: user.email,
          role: newRole,
          joinDate: user.joinDate,
        );
        _filterUsers(_searchController.text);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.name}\'s role updated to ${newRole.toUpperCase()}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteUser(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeWhere((u) => u.id == user.id);
                _filterUsers(_searchController.text);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.name} deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'manager':
        return Colors.purple;
      case 'clerk':
        return Colors.blue;
      case 'reader':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterUsers,
                    decoration: InputDecoration(
                      labelText: 'Search users...',
                      hintText: 'Enter name, email, or role',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Users: ${_filteredUsers.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          _buildRoleLegend('Manager', Colors.purple),
                          SizedBox(width: 8),
                          _buildRoleLegend('Clerk', Colors.blue),
                          SizedBox(width: 8),
                          _buildRoleLegend('Reader', Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getRoleColor(user.role),
                            child: Text(
                              user.name.split(' ').map((n) => n[0]).take(2).join().toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.email),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(user.role),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Joined: ${user.joinDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'details':
                                  _showUserDetails(user);
                                  break;
                                case 'edit':
                                  if (user.role != 'manager') {
                                    _showEditRoleDialog(user);
                                  }
                                  break;
                                case 'delete':
                                  if (user.role != 'manager') {
                                    _deleteUser(user);
                                  }
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'details',
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline),
                                    SizedBox(width: 8),
                                    Text('View Details'),
                                  ],
                                ),
                              ),
                              if (user.role != 'manager')
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Edit Role'),
                                    ],
                                  ),
                                ),
                              if (user.role != 'manager')
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRoleLegend(String role, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          role,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

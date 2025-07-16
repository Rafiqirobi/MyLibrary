import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/models/user.dart';
import 'package:my_library/services/database_service.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = true;
  
  List<Book> _books = [];
  List<AppUser> _users = [];
  
  // Report data
  Map<String, int> _categoryData = {};
  Map<String, int> _languageData = {};
  Map<String, int> _userRoleData = {};
  
  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load books
      _books = await _databaseService.getBooks();
      
      // Mock user data - in a real app, this would come from your database
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

      // Calculate category distribution
      _categoryData = {};
      for (var book in _books) {
        _categoryData[book.category] = (_categoryData[book.category] ?? 0) + 1;
      }

      // Calculate language distribution
      _languageData = {};
      for (var book in _books) {
        _languageData[book.language] = (_languageData[book.language] ?? 0) + 1;
      }

      // Calculate user role distribution
      _userRoleData = {};
      for (var user in _users) {
        _userRoleData[user.role] = (_userRoleData[user.role] ?? 0) + 1;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading report data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(String title, Map<String, int> data, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...data.entries.map((entry) {
              final percentage = (entry.value / data.values.fold(0, (a, b) => a + b) * 100).toStringAsFixed(1);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: entry.value / data.values.fold(0, (a, b) => a + b),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${entry.value} ($percentage%)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBooksCard() {
    final sortedBooks = List<Book>.from(_books);
    sortedBooks.sort((a, b) => (b.totalCopies - b.availableCopies).compareTo(a.totalCopies - a.availableCopies));
    final topBooks = sortedBooks.take(5).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Popular Books (by borrowed copies)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...topBooks.asMap().entries.map((entry) {
              final index = entry.key;
              final book = entry.value;
              final borrowedCopies = book.totalCopies - book.availableCopies;
              
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'by ${book.author}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$borrowedCopies borrowed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUsersCard() {
    final sortedUsers = List<AppUser>.from(_users);
    sortedUsers.sort((a, b) => (b.joinDate ?? DateTime.now()).compareTo(a.joinDate ?? DateTime.now()));
    final recentUsers = sortedUsers.take(5).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Users',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...recentUsers.map((user) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: _getRoleColor(user.role),
                      child: Text(
                        user.name.split(' ').map((n) => n[0]).take(2).join().toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final totalBooks = _books.length;
    final totalUsers = _users.length;
    final totalCopies = _books.fold(0, (sum, book) => sum + book.totalCopies);
    final borrowedCopies = _books.fold(0, (sum, book) => sum + (book.totalCopies - book.availableCopies));

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadReportData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Overview Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Books',
                    totalBooks.toString(),
                    Icons.library_books,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    totalUsers.toString(),
                    Icons.people,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatCard(
                    'Total Copies',
                    totalCopies.toString(),
                    Icons.content_copy,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatCard(
                    'Borrowed Copies',
                    borrowedCopies.toString(),
                    Icons.book_online,
                    Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Distribution Charts
            Row(
              children: [
                Expanded(
                  child: _buildDistributionCard(
                    'Books by Category',
                    _categoryData,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDistributionCard(
                    'Books by Language',
                    _languageData,
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: _buildDistributionCard(
                    'Users by Role',
                    _userRoleData,
                    Colors.purple,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTopBooksCard(),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Recent Users
            _buildRecentUsersCard(),
          ],
        ),
      ),
    );
  }
}

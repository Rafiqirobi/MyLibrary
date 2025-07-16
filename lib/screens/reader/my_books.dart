import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/widgets/book_card.dart';
import 'package:my_library/screens/reader/book_detail_screen.dart';
// Make sure BookDetailScreen is defined in book_detail.dart and the import path is correct.

class MyBooksScreen extends StatefulWidget {
  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  List<Book> _borrowedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBorrowedBooks();
  }

  Future<void> _loadBorrowedBooks() async {
    // In a real app, you would fetch the user's borrowed books
    // This is a mock implementation
    final db = Provider.of<DatabaseService>(context, listen: false);
    final allBooks = await db.getBooks();
    setState(() {
      _borrowedBooks = allBooks.take(3).toList(); // Mock: first 3 books as borrowed
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Borrowed Books')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _borrowedBooks.isEmpty
              ? Center(child: Text('You haven\'t borrowed any books yet'))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _borrowedBooks.length,
                  itemBuilder: (context, index) {
                    final book = _borrowedBooks[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          book.coverUrl,
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.book),
                        ),
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        trailing: Text('Due: ${DateTime.now().add(Duration(days: 14)).toString().split(' ')[0]}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(book: book),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
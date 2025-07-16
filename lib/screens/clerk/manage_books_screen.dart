import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/screens/clerk/add_book_screen.dart';
import 'package:my_library/screens/clerk/edit_book_screen.dart';

class ManageBooksScreen extends StatefulWidget {
  @override
  _ManageBooksScreenState createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final books = await db.getBooks();
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  Future<void> _deleteBook(String id) async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    await db.deleteBook(id);
    setState(() {
      _books.removeWhere((book) => book.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Book deleted successfully')),
    );
  }

  void _showBookDetails(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${book.author}'),
            Text('Category: ${book.category}'),
            Text('Language: ${book.language}'),
            Text('Pages: ${book.pages}'),
            Text('Published: ${book.publishDate.year}'),
            Text('Copies: ${book.availableCopies}/${book.totalCopies}'),
            Text('Available: ${book.isAvailable ? 'Yes' : 'No'}'),
            SizedBox(height: 8),
            Text('Description:'),
            Text(book.description, style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBookScreen(book: book),
                ),
              ).then((_) => _loadBooks());
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Books'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookScreen(),
                ),
              ).then((_) => _loadBooks()); // Refresh when returning
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? Center(child: Text('No books available'))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Dismissible(
                      key: Key(book.id),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this book?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        _deleteBook(book.id);
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(
                            book.coverUrl,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.book),
                          ),
                          title: Text(book.title),
                          subtitle: Text('${book.author} • ${book.availableCopies}/${book.totalCopies} available'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookScreen(book: book),
                                ),
                              ).then((_) => _loadBooks()); // Refresh when returning
                            },
                          ),
                          onTap: () {
                            // Show book details in a dialog or navigate to detail screen
                            _showBookDetails(book);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
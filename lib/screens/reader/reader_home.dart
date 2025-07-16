import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/widgets/app_drawer.dart';
import 'package:my_library/widgets/book_card.dart';
import 'package:my_library/screens/reader/book_detail_screen.dart';

class ReaderHome extends StatefulWidget {
  @override
  _ReaderHomeState createState() => _ReaderHomeState();
}

class _ReaderHomeState extends State<ReaderHome> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    try {
      final db = Provider.of<DatabaseService>(context, listen: false);
      final books = await db.getBooks();
      
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _books = books;
          _filteredBooks = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading books: ${e.toString()}')),
        );
      }
    }
  }

  void _searchBooks(String query) {
    if (mounted) {
      setState(() {
        if (query.isEmpty) {
          _filteredBooks = _books;
        } else {
          _filteredBooks = _books.where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase()) ||
              book.category.toLowerCase().contains(query.toLowerCase())).toList();
        }
      });
    }
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: _searchBooks,
                decoration: InputDecoration(
                  labelText: 'Search books',
                  hintText: 'Search by title, author, or category...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              SizedBox(height: 16),
              Text(
                'Search by:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showFilterDialog('title');
                    },
                    child: Text('Title'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showFilterDialog('author');
                    },
                    child: Text('Author'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showFilterDialog('category');
                    },
                    child: Text('Category'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(String filterType) {
    showDialog(
      context: context,
      builder: (context) {
        String query = '';
        return AlertDialog(
          title: Text('Search by ${filterType.toUpperCase()}'),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: InputDecoration(
              labelText: 'Enter ${filterType}',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _searchBooks('');
              },
              child: Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _filterBooks(filterType, query);
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _filterBooks(String filterType, String query) {
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _filteredBooks = _books;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        switch (filterType) {
          case 'title':
            _filteredBooks = _books.where((book) =>
                book.title.toLowerCase().contains(query.toLowerCase())).toList();
            break;
          case 'author':
            _filteredBooks = _books.where((book) =>
                book.author.toLowerCase().contains(query.toLowerCase())).toList();
            break;
          case 'category':
            _filteredBooks = _books.where((book) =>
                book.category.toLowerCase().contains(query.toLowerCase())).toList();
            break;
          default:
            _filteredBooks = _books;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myLibrary - Malay eBooks'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchBottomSheet,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _searchBooks,
              decoration: InputDecoration(
                hintText: 'Search by title, author, or category...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchBooks('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Books grid
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No books found'
                                  : 'No books match your search',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (_searchController.text.isNotEmpty) ...[
                              SizedBox(height: 8),
                              Text(
                                'Try searching for different keywords',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailScreen(book: book),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;

  BookSearchDelegate(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? books
        : books.where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            query = book.title;
            showResults(context);
          },
        );
      },
    );
  }
}
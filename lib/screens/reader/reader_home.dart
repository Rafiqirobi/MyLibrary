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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadBooks();
    }
  }

  Future<void> _loadBooks() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final books = await db.getBooks();
    setState(() {
      _books = books;
      _filteredBooks = books;
      _isLoading = false;
    });
  }

  void _searchBooks(String query) {
    setState(() {
      _filteredBooks = _books.where((book) =>
          book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myLibrary - Malay eBooks'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(_books),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredBooks.isEmpty
              ? Center(child: Text('No books found'))
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
import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/services/database_service.dart';

class BooksInventoryScreen extends StatefulWidget {
  @override
  _BooksInventoryScreenState createState() => _BooksInventoryScreenState();
}

class _BooksInventoryScreenState extends State<BooksInventoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _selectedLanguage = 'All';
  String _sortBy = 'title';

  final List<String> _categories = ['All', 'Novel', 'Epik', 'Sejarah', 'Biografi', 'Science Fiction'];
  final List<String> _languages = ['All', 'Malay', 'English', 'Chinese', 'Tamil'];
  final List<String> _sortOptions = ['title', 'author', 'publishDate', 'totalCopies'];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await _databaseService.getBooks();
      setState(() {
        _books = books;
        _filteredBooks = books;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading books: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _applyFilters() {
    List<Book> filtered = _books;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((book) =>
          book.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((book) => book.category == _selectedCategory).toList();
    }

    // Apply language filter
    if (_selectedLanguage != 'All') {
      filtered = filtered.where((book) => book.language == _selectedLanguage).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'author':
        filtered.sort((a, b) => a.author.compareTo(b.author));
        break;
      case 'publishDate':
        filtered.sort((a, b) => b.publishDate.compareTo(a.publishDate));
        break;
      case 'totalCopies':
        filtered.sort((a, b) => b.totalCopies.compareTo(a.totalCopies));
        break;
    }

    setState(() {
      _filteredBooks = filtered;
    });
  }

  void _showBookDetails(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Author: ${book.author}'),
              SizedBox(height: 8),
              Text('Category: ${book.category}'),
              SizedBox(height: 8),
              Text('Language: ${book.language}'),
              SizedBox(height: 8),
              Text('Pages: ${book.pages}'),
              SizedBox(height: 8),
              Text('Published: ${book.publishDate.year}'),
              SizedBox(height: 8),
              Text('Total Copies: ${book.totalCopies}'),
              SizedBox(height: 8),
              Text('Available Copies: ${book.availableCopies}'),
              SizedBox(height: 8),
              Text('Status: ${book.isAvailable ? 'Available' : 'Not Available'}'),
              SizedBox(height: 8),
              Text('Description: ${book.description}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditCopiesDialog(book);
            },
            child: Text('Edit Copies'),
          ),
        ],
      ),
    );
  }

  void _showEditCopiesDialog(Book book) {
    final TextEditingController totalCopiesController = TextEditingController(
      text: book.totalCopies.toString(),
    );
    final TextEditingController availableCopiesController = TextEditingController(
      text: book.availableCopies.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Copies - ${book.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: totalCopiesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Copies',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: availableCopiesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Available Copies',
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
              final int? totalCopies = int.tryParse(totalCopiesController.text);
              final int? availableCopies = int.tryParse(availableCopiesController.text);

              if (totalCopies != null && availableCopies != null) {
                if (availableCopies <= totalCopies) {
                  Navigator.pop(context);
                  _updateBookCopies(book, totalCopies, availableCopies);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Available copies cannot exceed total copies'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter valid numbers'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _updateBookCopies(Book book, int totalCopies, int availableCopies) async {
    try {
      final updatedBook = Book(
        id: book.id,
        title: book.title,
        author: book.author,
        description: book.description,
        genre: book.genre,
        language: book.language,
        coverUrl: book.coverUrl,
        fileUrl: book.fileUrl,
        publishDate: book.publishDate,
        pages: book.pages,
        isAvailable: book.isAvailable,
        totalCopies: totalCopies,
        availableCopies: availableCopies,
      );

      await _databaseService.updateBook(updatedBook);
      _loadBooks();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book copies updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalBooks = _books.length;
    final availableBooks = _books.where((book) => book.isAvailable).length;
    final totalCopies = _books.fold(0, (sum, book) => sum + book.totalCopies);
    final availableCopies = _books.fold(0, (sum, book) => sum + book.availableCopies);

    return Scaffold(
      appBar: AppBar(
        title: Text('Books Inventory'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Stats Cards
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          'Total Books',
                          totalBooks.toString(),
                          Icons.library_books,
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildStatsCard(
                          'Available Books',
                          availableBooks.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildStatsCard(
                          'Total Copies',
                          totalCopies.toString(),
                          Icons.content_copy,
                          Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _buildStatsCard(
                          'Available Copies',
                          availableCopies.toString(),
                          Icons.inventory,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search and Filters
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => _applyFilters(),
                        decoration: InputDecoration(
                          labelText: 'Search books...',
                          hintText: 'Enter title or author',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                items: _categories.map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                  _applyFilters();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField<String>(
                                value: _selectedLanguage,
                                items: _languages.map((language) => DropdownMenuItem(
                                  value: language,
                                  child: Text(language),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLanguage = value!;
                                  });
                                  _applyFilters();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Language',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField<String>(
                                value: _sortBy,
                                items: _sortOptions.map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option.replaceAll('_', ' ').toUpperCase()),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _sortBy = value!;
                                  });
                                  _applyFilters();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Sort By',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Results Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${_filteredBooks.length} of ${_books.length} books',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _loadBooks,
                        tooltip: 'Refresh',
                      ),
                    ],
                  ),
                ),
                // Books List
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.book,
                              color: Colors.grey[600],
                            ),
                          ),
                          title: Text(
                            book.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('by ${book.author}'),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      book.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      book.language,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Copies: ${book.availableCopies}/${book.totalCopies}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: book.isAvailable ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  book.isAvailable ? 'Available' : 'Not Available',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _showBookDetails(book),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

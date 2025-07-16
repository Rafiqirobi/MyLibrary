import 'package:my_library/models/book.dart';

class DatabaseService {
  // Mock database - replace with actual Firestore or other database implementation
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'Hikayat Hang Tuah',
      author: 'Anonymous',
      description: 'Kisah epik Hang Tuah dan Laksamana Melaka',
      category: 'Epik',
      language: 'Malay',
      coverUrl: 'https://example.com/hangtuah.jpg',
      fileUrl: 'https://example.com/hangtuah.pdf',
      publishDate: DateTime(1800),
      pages: 200,
      isAvailable: true,
      totalCopies: 5,
      availableCopies: 3,
    ),
    Book(
      id: '2',
      title: 'Salina',
      author: 'A. Samad Said',
      description: 'Novel klasik tentang kehidupan di Singapura tahun 1950-an',
      category: 'Novel',
      language: 'Malay',
      coverUrl: 'https://example.com/salina.jpg',
      fileUrl: 'https://example.com/salina.pdf',
      publishDate: DateTime(1961),
      pages: 350,
      isAvailable: true,
      totalCopies: 3,
      availableCopies: 1,
    ),
  ];

  Future<List<Book>> getBooks() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    return _books;
  }

  Future<Book?> getBookById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addBook(Book book) async {
    await Future.delayed(Duration(seconds: 1));
    _books.add(book);
  }

  Future<void> updateBook(Book updatedBook) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
    }
  }

  Future<void> deleteBook(String id) async {
    await Future.delayed(Duration(seconds: 1));
    _books.removeWhere((book) => book.id == id);
  }

  Future<List<Book>> searchBooks(String query) async {
    await Future.delayed(Duration(milliseconds: 800));
    return _books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
import 'package:my_library/models/book.dart';
import 'package:my_library/models/review.dart';
import 'package:my_library/models/favorite.dart';

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

  // Storage for reviews, favorites, and wishlist
  final List<Review> _reviews = [];
  final List<Favorite> _favorites = [];
  final List<Wishlist> _wishlist = [];

  Future<List<Book>> getBooks() async {
    // Simulate network delay - reduced for better development experience
    await Future.delayed(Duration(milliseconds: 300));
    return _books;
  }

  Future<Book?> getBookById(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addBook(Book book) async {
    await Future.delayed(Duration(milliseconds: 300));
    _books.add(book);
  }

  Future<void> updateBook(Book updatedBook) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
    }
  }

  Future<void> deleteBook(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    _books.removeWhere((book) => book.id == id);
  }

  Future<List<Book>> searchBooks(String query) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Review methods
  Future<List<Review>> getReviewsForBook(String bookId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _reviews.where((review) => review.bookId == bookId).toList();
  }

  Future<Review?> getUserReviewForBook(String userId, String bookId) async {
    await Future.delayed(Duration(milliseconds: 200));
    try {
      return _reviews.firstWhere((review) => review.userId == userId && review.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addReview(Review review) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Remove existing review from same user for same book
    _reviews.removeWhere((r) => r.userId == review.userId && r.bookId == review.bookId);
    _reviews.add(review);
  }

  Future<void> updateReview(Review updatedReview) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _reviews.indexWhere((r) => r.id == updatedReview.id);
    if (index != -1) {
      _reviews[index] = updatedReview;
    }
  }

  Future<double> getAverageRating(String bookId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final bookReviews = _reviews.where((review) => review.bookId == bookId).toList();
    if (bookReviews.isEmpty) return 0.0;
    final totalRating = bookReviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / bookReviews.length;
  }

  // Favorites methods
  Future<List<Favorite>> getUserFavorites(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _favorites.where((fav) => fav.userId == userId).toList();
  }

  Future<bool> isFavorite(String userId, String bookId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _favorites.any((fav) => fav.userId == userId && fav.bookId == bookId);
  }

  Future<void> addToFavorites(Favorite favorite) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Check if already exists
    if (!_favorites.any((fav) => fav.userId == favorite.userId && fav.bookId == favorite.bookId)) {
      _favorites.add(favorite);
    }
  }

  Future<void> removeFromFavorites(String userId, String bookId) async {
    await Future.delayed(Duration(milliseconds: 300));
    _favorites.removeWhere((fav) => fav.userId == userId && fav.bookId == bookId);
  }

  // Wishlist methods
  Future<List<Wishlist>> getUserWishlist(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _wishlist.where((wish) => wish.userId == userId).toList();
  }

  Future<bool> isInWishlist(String userId, String bookId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _wishlist.any((wish) => wish.userId == userId && wish.bookId == bookId);
  }

  Future<void> addToWishlist(Wishlist wishlistItem) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Check if already exists
    if (!_wishlist.any((wish) => wish.userId == wishlistItem.userId && wish.bookId == wishlistItem.bookId)) {
      _wishlist.add(wishlistItem);
    }
  }

  Future<void> removeFromWishlist(String userId, String bookId) async {
    await Future.delayed(Duration(milliseconds: 300));
    _wishlist.removeWhere((wish) => wish.userId == userId && wish.bookId == bookId);
  }

  Future<void> moveFromWishlistToFavorites(String userId, String bookId) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Remove from wishlist
    _wishlist.removeWhere((wish) => wish.userId == userId && wish.bookId == bookId);
    // Add to favorites
    final favorite = Favorite(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      bookId: bookId,
      addedAt: DateTime.now(),
    );
    if (!_favorites.any((fav) => fav.userId == userId && fav.bookId == bookId)) {
      _favorites.add(favorite);
    }
  }
}
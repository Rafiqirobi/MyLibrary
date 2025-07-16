import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/models/favorite.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/services/auth_service.dart';
import 'package:my_library/widgets/book_card.dart';
import 'package:my_library/screens/reader/book_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Book> _favoriteBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.id ?? '';

    try {
      final favorites = await db.getUserFavorites(userId);
      final List<Book> favoriteBooks = [];
      
      for (final fav in favorites) {
        final book = await db.getBookById(fav.bookId);
        if (book != null) {
          favoriteBooks.add(book);
        }
      }

      setState(() {
        _favoriteBooks = favoriteBooks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorites: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add books to your favorites to see them here',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                  itemCount: _favoriteBooks.length,
                  itemBuilder: (context, index) {
                    final book = _favoriteBooks[index];
                    return BookCard(
                      book: book,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailScreen(book: book),
                          ),
                        ).then((_) {
                          // Refresh favorites when returning from detail screen
                          _loadFavorites();
                        });
                      },
                    );
                  },
                ),
    );
  }
}

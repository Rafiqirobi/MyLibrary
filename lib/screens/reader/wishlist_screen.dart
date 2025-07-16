import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/services/auth_service.dart';
import 'package:my_library/widgets/book_card.dart';
import 'package:my_library/screens/reader/book_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Book> _wishlistBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.id ?? '';

    try {
      final wishlist = await db.getUserWishlist(userId);
      final List<Book> wishlistBooks = [];
      
      for (final wish in wishlist) {
        final book = await db.getBookById(wish.bookId);
        if (book != null) {
          wishlistBooks.add(book);
        }
      }

      setState(() {
        _wishlistBooks = wishlistBooks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading wishlist: ${e.toString()}')),
      );
    }
  }

  Future<void> _moveToFavorites(Book book) async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.id ?? '';

    try {
      await db.moveFromWishlistToFavorites(userId, book.id);
      await _loadWishlist(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${book.title} moved to favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWishlist,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _wishlistBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Your wishlist is empty',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add books to your wishlist to see them here',
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
                  itemCount: _wishlistBooks.length,
                  itemBuilder: (context, index) {
                    final book = _wishlistBooks[index];
                    return Stack(
                      children: [
                        BookCard(
                          book: book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailScreen(book: book),
                              ),
                            ).then((_) {
                              // Refresh wishlist when returning from detail screen
                              _loadWishlist();
                            });
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: PopupMenuButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) {
                              if (value == 'move_to_favorites') {
                                _moveToFavorites(book);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'move_to_favorites',
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite),
                                    SizedBox(width: 8),
                                    Text('Move to Favorites'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/models/review.dart';
import 'package:my_library/models/favorite.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/services/auth_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isLoading = true;
  bool _isFavorite = false;
  bool _isInWishlist = false;
  double _averageRating = 0.0;
  List<Review> _reviews = [];
  Review? _userReview;
  
  // Review form controllers
  final _reviewController = TextEditingController();
  double _userRating = 5.0;
  bool _isSubmittingReview = false;

  @override
  void initState() {
    super.initState();
    _loadBookDetails();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadBookDetails() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.id ?? '';

    try {
      // Load all details in parallel
      final results = await Future.wait([
        db.getReviewsForBook(widget.book.id),
        db.getUserReviewForBook(userId, widget.book.id),
        db.getAverageRating(widget.book.id),
        db.isFavorite(userId, widget.book.id),
        db.isInWishlist(userId, widget.book.id),
      ]);

      setState(() {
        _reviews = results[0] as List<Review>;
        _userReview = results[1] as Review?;
        _averageRating = results[2] as double;
        _isFavorite = results[3] as bool;
        _isInWishlist = results[4] as bool;
        _isLoading = false;
        
        // If user has existing review, populate the form
        if (_userReview != null) {
          _reviewController.text = _userReview!.comment;
          _userRating = _userReview!.rating;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading book details: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.id ?? '';

    try {
      if (_isFavorite) {
        await db.removeFromFavorites(userId, widget.book.id);
        setState(() {
          _isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        final favorite = Favorite(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          bookId: widget.book.id,
          addedAt: DateTime.now(),
        );
        await db.addToFavorites(favorite);
        setState(() {
          _isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleWishlist() async {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.id ?? '';

    try {
      if (_isInWishlist) {
        await db.removeFromWishlist(userId, widget.book.id);
        setState(() {
          _isInWishlist = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from wishlist')),
        );
      } else {
        final wishlistItem = Wishlist(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          bookId: widget.book.id,
          addedAt: DateTime.now(),
        );
        await db.addToWishlist(wishlistItem);
        setState(() {
          _isInWishlist = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to wishlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    setState(() {
      _isSubmittingReview = true;
    });

    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser!;

    try {
      final review = Review(
        id: _userReview?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        bookId: widget.book.id,
        userId: user.id,
        userName: user.name,
        rating: _userRating,
        comment: _reviewController.text.trim(),
        createdAt: DateTime.now(),
      );

      if (_userReview != null) {
        await db.updateReview(review);
      } else {
        await db.addReview(review);
      }

      // Reload the reviews and rating
      await _loadBookDetails();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_userReview != null ? 'Review updated' : 'Review submitted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmittingReview = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
          IconButton(
            icon: Icon(_isInWishlist ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleWishlist,
            tooltip: _isInWishlist ? 'Remove from wishlist' : 'Add to wishlist',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookInfo(),
                  SizedBox(height: 20),
                  _buildActionButtons(),
                  SizedBox(height: 20),
                  _buildRatingSection(),
                  SizedBox(height: 20),
                  _buildReviewForm(),
                  SizedBox(height: 20),
                  _buildReviewsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildBookInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'book-cover-${widget.book.id}',
                  child: Container(
                    width: 120,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: Icon(Icons.book, size: 60, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'by ${widget.book.author}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text(widget.book.category)),
                          Chip(label: Text(widget.book.language)),
                          Chip(label: Text('${widget.book.pages} pages')),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ...List.generate(5, (index) => Icon(
                            index < _averageRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          )),
                          SizedBox(width: 8),
                          Text(
                            _averageRating > 0 ? '${_averageRating.toStringAsFixed(1)} (${_reviews.length} reviews)' : 'No reviews yet',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              widget.book.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(_isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFavorite ? Colors.red : Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _toggleWishlist,
            icon: Icon(_isInWishlist ? Icons.bookmark : Icons.bookmark_border),
            label: Text(_isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isInWishlist ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Rating',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(5, (index) => Icon(
                  index < _averageRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                )),
                SizedBox(width: 16),
                Text(
                  _averageRating > 0 ? '${_averageRating.toStringAsFixed(1)} out of 5' : 'No ratings yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (_reviews.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Based on ${_reviews.length} review${_reviews.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userReview != null ? 'Update Your Review' : 'Write a Review',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Text('Rating'),
            SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(5, (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _userRating = index + 1.0;
                    });
                  },
                  child: Icon(
                    index < _userRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                )),
                SizedBox(width: 16),
                Text('${_userRating.toInt()} out of 5 stars'),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Your Review',
                hintText: 'Share your thoughts about this book...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmittingReview ? null : _submitReview,
                child: _isSubmittingReview
                    ? CircularProgressIndicator()
                    : Text(_userReview != null ? 'Update Review' : 'Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews (${_reviews.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            if (_reviews.isEmpty)
              Text(
                'No reviews yet. Be the first to review this book!',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ...(_reviews.map((review) => _buildReviewItem(review)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(review.userName[0].toUpperCase()),
                radius: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ...List.generate(5, (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  )),
                  SizedBox(width: 4),
                  Text('${review.rating.toInt()}/5'),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            review.comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

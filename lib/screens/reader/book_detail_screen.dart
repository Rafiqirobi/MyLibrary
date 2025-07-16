import 'package:flutter/material.dart';
import 'package:my_library/models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'book-cover-${book.id}',
                child: Image.network(
                  book.coverUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.book, size: 100),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'by ${book.author}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Chip(label: Text(book.category)),
                SizedBox(width: 8),
                Chip(label: Text(book.language)),
                SizedBox(width: 8),
                Chip(label: Text('${book.pages} pages')),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(book.description),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 4),
                Text('Published: ${book.publishDate.year}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.library_books, size: 16),
                SizedBox(width: 4),
                Text('Available: ${book.availableCopies}/${book.totalCopies}'),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement borrow functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Book borrowed successfully')),
                  );
                },
                icon: Icon(Icons.download),
                label: Text('Borrow This Book'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
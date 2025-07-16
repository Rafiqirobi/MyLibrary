class Book {
  final String id;
  final String title;
  final String author;
  final String? penerbit; // Publisher
  final String description;
  final String genre; // Changed from category to genre
  final String language; // Malay/English
  final String coverUrl;
  final String fileUrl;
  final DateTime publishDate;
  final int pages;
  final bool isAvailable;
  final int totalCopies;
  final int availableCopies;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.penerbit,
    required this.description,
    required this.genre,
    required this.language,
    this.coverUrl = '',
    this.fileUrl = '',
    required this.publishDate,
    required this.pages,
    required this.isAvailable,
    this.totalCopies = 1,
    this.availableCopies = 1,
  });

  // For backward compatibility, add a getter for category
  String get category => genre;

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      penerbit: map['penerbit'],
      description: map['description'] ?? '',
      genre: map['genre'] ?? map['category'] ?? '', // Support both field names
      language: map['language'] ?? 'Malay',
      coverUrl: map['coverUrl'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      publishDate: map['publishDate']?.toDate() ?? DateTime.now(),
      pages: map['pages'] ?? 0,
      isAvailable: map['isAvailable'] ?? false,
      totalCopies: map['totalCopies'] ?? 1,
      availableCopies: map['availableCopies'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'penerbit': penerbit,
      'description': description,
      'genre': genre,
      'category': genre, // For backward compatibility
      'language': language,
      'coverUrl': coverUrl,
      'fileUrl': fileUrl,
      'publishDate': publishDate,
      'pages': pages,
      'isAvailable': isAvailable,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
    };
  }
}
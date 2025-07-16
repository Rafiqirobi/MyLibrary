class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
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
    required this.description,
    required this.category,
    required this.language,
    required this.coverUrl,
    required this.fileUrl,
    required this.publishDate,
    required this.pages,
    required this.isAvailable,
    required this.totalCopies,
    required this.availableCopies,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
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
      'description': description,
      'category': category,
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
class Favorite {
  final String id;
  final String userId;
  final String bookId;
  final DateTime addedAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.addedAt,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      addedAt: map['addedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'addedAt': addedAt,
    };
  }
}

class Wishlist {
  final String id;
  final String userId;
  final String bookId;
  final DateTime addedAt;

  Wishlist({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.addedAt,
  });

  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      addedAt: map['addedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'addedAt': addedAt,
    };
  }
}

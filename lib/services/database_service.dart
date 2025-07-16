import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/book.dart';
import 'package:my_library/models/review.dart';
import 'package:my_library/models/favorite.dart';
import 'package:my_library/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Comprehensive Malay books database
  final List<Book> _books = [
    // ========== ROMANTIK (10 books) ==========
    Book(
      id: "MB001",
      title: "Rahsia Cinta Di Balik Tabir",
      author: "Aina Sofiya",
      penerbit: "Cinta Abadi Press",
      description: "Kisah cinta terlarang antara seorang penari dengan pewaris syarikat besar yang penuh liku-liku.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 210,
      isAvailable: true,
    ),
    Book(
      id: "MB002",
      title: "Hujan Dan Angin",
      author: "Hafiz Hamidun",
      penerbit: "Bunga Raya Media",
      description: "Cinta segitiga antara guru sekolah, doktor dan nelayan di sebuah kampung nelayan Terengganu.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 180,
      isAvailable: true,
    ),
    Book(
      id: "MB003",
      title: "Bukan Cinta Biasa",
      author: "Siti Nurhaliza",
      penerbit: "Kasih Karya",
      description: "Kisah cinta antara penyanyi terkenal dengan jurugambar perang yang penuh pengorbanan.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 195,
      isAvailable: true,
    ),
    Book(
      id: "MB004",
      title: "Cinta Kedua",
      author: "Amirul Hafiz",
      penerbit: "Cinta Abadi Press",
      description: "Seorang duda menemui cinta baharu selepas kehilangan isterinya dalam kemalangan.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 220,
      isAvailable: true,
    ),
    Book(
      id: "MB005",
      title: "Surat Untuk Sarah",
      author: "Marzuki Ali",
      penerbit: "Bunga Raya Media",
      description: "Kisah cinta jarak jauh melalui surat-menyurat antara dua sahabat sejak kecil.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2023),
      pages: 175,
      isAvailable: true,
    ),
    Book(
      id: "MB006",
      title: "Cinta Kontrak",
      author: "Dalia Faris",
      penerbit: "Kasih Karya",
      description: "Perkahwinan kontrak antara CEO muda dengan gadis kampung berubah menjadi cinta sejati.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 240,
      isAvailable: true,
    ),
    Book(
      id: "MB007",
      title: "Bunga-Bunga Cinta",
      author: "Nurul Syafiqah",
      penerbit: "Cinta Abadi Press",
      description: "Kisah cinta antara penjual bunga dengan pelukis jalanan di tengah kesibukan Kuala Lumpur.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 190,
      isAvailable: true,
    ),
    Book(
      id: "MB008",
      title: "Hati Yang Terluka",
      author: "Ahmad Faisal",
      penerbit: "Bunga Raya Media",
      description: "Doktor wanita yang patah hati belajar untuk mencintai lagi setelah bertemu dengan pesakit istimewa.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2018),
      pages: 205,
      isAvailable: true,
    ),
    Book(
      id: "MB009",
      title: "Janji Di Pantai Merdeka",
      author: "Siti Zaleha",
      penerbit: "Kasih Karya",
      description: "Janji masa kecil di pantai membawa dua kekasih bertemu semula setelah 15 tahun berpisah.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 165,
      isAvailable: true,
    ),
    Book(
      id: "MB010",
      title: "Cinta Dalam Diam",
      author: "Zahid Samad",
      penerbit: "Cinta Abadi Press",
      description: "Kisah cinta senyap antara dua jiran yang malu-malu tetapi saling menyayangi.",
      genre: "Romantik",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 155,
      isAvailable: true,
    ),

    // ========== SERAM (10 books) ==========
    Book(
      id: "MB011",
      title: "Rumah Kosong Di Jalan Lama",
      author: "Jalil Ahmad",
      penerbit: "Kabus Malam Publications",
      description: "Sekeluarga pindah ke rumah lama yang menyimpan rahsia mengerikan dari era penjajahan Jepun.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 230,
      isAvailable: true,
    ),
    Book(
      id: "MB012",
      title: "Pontianak Kampung Seberang",
      author: "Dahlia Ariffin",
      penerbit: "Gerimis Kematian Books",
      description: "Legenda pontianak bangkit ketika pembangunan projek perumahan baru menggali kubur lama.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 275,
      isAvailable: true,
    ),
    Book(
      id: "MB013",
      title: "Jeritan Malam Jumaat",
      author: "Ismail Kassim",
      penerbit: "Misteri Nusantara",
      description: "Ritual kuno di sebuah kampung terpencil membangkitkan entiti jahat setiap malam Jumaat.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 190,
      isAvailable: true,
    ),
    Book(
      id: "MB014",
      title: "Korban Pertama",
      author: "Nadia Hashim",
      penerbit: "Kabus Malam Publications",
      description: "Siri kematian misteri di asrama sekolah berasrama penuh mengikut urutan ritual kuno.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 210,
      isAvailable: true,
    ),
    Book(
      id: "MB015",
      title: "Paku Di Dalam Dinding",
      author: "Rahim Abdullah",
      penerbit: "Gerimis Kematian Books",
      description: "Pasangan muda menemui paku-paku berkarat di dinding rumah baru mereka dengan tulisan misteri.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2018),
      pages: 185,
      isAvailable: true,
    ),
    Book(
      id: "MB016",
      title: "Taman Yang Hilang",
      author: "Siti Aishah",
      penerbit: "Misteri Nusantara",
      description: "Seorang kanak-kanak hilang di taman perumahan yang sebenarnya tidak wujud dalam peta.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2023),
      pages: 200,
      isAvailable: true,
    ),
    Book(
      id: "MB017",
      title: "Bisikan Dari Bilik Bawah Tanah",
      author: "Hafizuddin",
      penerbit: "Kabus Malam Publications",
      description: "Bilik rahsia ditemui di bawah rumah lama, memancarkan suara bisikan pada waktu malam.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 225,
      isAvailable: true,
    ),
    Book(
      id: "MB018",
      title: "Kain Kafan Berdarah",
      author: "Dalia Faris",
      penerbit: "Gerimis Kematian Books",
      description: "Kain kafan muncul secara misteri di hadapan rumah mereka yang akan mati dalam masa 7 hari.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 240,
      isAvailable: true,
    ),
    Book(
      id: "MB019",
      title: "Jangan Pandang Belakang",
      author: "Zulkifli Yusof",
      penerbit: "Misteri Nusantara",
      description: "Legenda hantu wanita berambut panjang yang memburu mereka yang berpaling di jalan sunyi.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 195,
      isAvailable: true,
    ),
    Book(
      id: "MB020",
      title: "Bayangan Di Tingkat Tiga",
      author: "Nurul Ain",
      penerbit: "Kabus Malam Publications",
      description: "Penghuni bangunan flat lama diganggu oleh bayangan yang hanya muncul di foto tetapi tidak kelihatan secara langsung.",
      genre: "Seram",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 215,
      isAvailable: true,
    ),

    // ========== KOMEDI (10 books) ==========
    Book(
      id: "MB021",
      title: "Gila-Gila Kampus",
      author: "Zul Pak Mat",
      penerbit: "Ketawa Kencang Media",
      description: "Hidup sekumpulan pelajar universiti yang sentiasa terjebak dalam situasi lucu dan tidak masuk akal.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 150,
      isAvailable: true,
    ),
    Book(
      id: "MB022",
      title: "Kisah Si Luncai",
      author: "Pak Pandir Moden",
      penerbit: "Jenaka Karya",
      description: "Versi moden kisah Si Luncai yang bijak tetapi selalu tersalah faham dalam segala situasi.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 120,
      isAvailable: true,
    ),
    Book(
      id: "MB023",
      title: "Kampung Pisang",
      author: "Mat Jenin",
      penerbit: "Hati Gembira Press",
      description: "Kehidupan harian penduduk kampung yang penuh dengan kejadian kelakar dan tidak disengajakan.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 135,
      isAvailable: true,
    ),
    Book(
      id: "MB024",
      title: "Cikgu Man, Human Kan?",
      author: "Azlan Komedi",
      penerbit: "Ketawa Kencang Media",
      description: "Pengalaman mengajar guru baru di sekolah menengah yang penuh dengan pelajar bermasalah tetapi lucu.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2023),
      pages: 165,
      isAvailable: true,
    ),
    Book(
      id: "MB025",
      title: "Keluarga Kelakar",
      author: "Piah HaHa",
      penerbit: "Jenaka Karya",
      description: "Situasi harian sebuah keluarga yang setiap anggotanya mempunyai personaliti unik dan menggelikan hati.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 140,
      isAvailable: true,
    ),
    Book(
      id: "MB026",
      title: "Jiran Oh Jiran",
      author: "Kak Teh Ketawa",
      penerbit: "Hati Gembira Press",
      description: "Konflik dan kisah lucu antara jiran tetangga di sebuah taman perumahan.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 155,
      isAvailable: true,
    ),
    Book(
      id: "MB027",
      title: "Geng Motor Kaki Ayam",
      author: "Abam Gilo",
      penerbit: "Ketawa Kencang Media",
      description: "Pengembaraan sekumpulan remaja kampung yang memiliki motor buruk tetapi penuh dengan semangat.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2018),
      pages: 175,
      isAvailable: true,
    ),
    Book(
      id: "MB028",
      title: "Cinta Ala Kampung",
      author: "Along Jambu",
      penerbit: "Jenaka Karya",
      description: "Kisah cinta lucu antara pemuda kampung dengan gadis bandar yang datang bercuti.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 160,
      isAvailable: true,
    ),
    Book(
      id: "MB029",
      title: "Tolong! Aku Ghostwriter",
      author: "Dinsman",
      penerbit: "Hati Gembira Press",
      description: "Pengalaman kelakar seorang penulis hantu yang terpaksa menulis buku untuk orang terkenal yang tidak pandai menulis.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 185,
      isAvailable: true,
    ),
    Book(
      id: "MB030",
      title: "Kantin Sekolahku Oh Kantin",
      author: "Pak Belang",
      penerbit: "Ketawa Kencang Media",
      description: "Drama dan komedi di sebalik tabir kantin sekolah dengan pelbagai karakter unik.",
      genre: "Komedi",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 145,
      isAvailable: true,
    ),

    // ========== THRILLER/JENAYAH (10 books) ==========
    Book(
      id: "MB031",
      title: "Pembunuhan Di Hotel Puri",
      author: "Shah Reza",
      penerbit: "Detektif Melayu Books",
      description: "Siri pembunuhan misteri di hotel warisan Melaka dengan petunjuk berlatarbelakangkan sejarah.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 290,
      isAvailable: true,
    ),
    Book(
      id: "MB032",
      title: "Nadi Hitam",
      author: "Ismail Kassim",
      penerbit: "Nadi Gerak Publications",
      description: "Detektif wanita menyiasat sindiket dadah yang menggunakan kaedah pengedaran unik melalui hospital.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 320,
      isAvailable: true,
    ),
    Book(
      id: "MB033",
      title: "Mangsa Yang Hilang",
      author: "Ameer Khan",
      penerbit: "Pemburu Misteri",
      description: "Siri kehilangan gadis muda dengan satu-satunya petunjuk adalah sekeping foto lama.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 275,
      isAvailable: true,
    ),
    Book(
      id: "MB034",
      title: "Kod Rahsia Bukit Kepong",
      author: "Rahim Razak",
      penerbit: "Detektif Melayu Books",
      description: "Dokumen rahsia zaman darurat membawa kepada konspirasi pembunuhan moden.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 310,
      isAvailable: true,
    ),
    Book(
      id: "MB035",
      title: "Dendam Malam Raya",
      author: "Sofia Hani",
      penerbit: "Nadi Gerak Publications",
      description: "Pembunuhan berantai berlaku setiap malam raya dengan motif yang tidak diketahui.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 285,
      isAvailable: true,
    ),
    Book(
      id: "MB036",
      title: "Pencuri Identiti",
      author: "Farid Aziz",
      penerbit: "Pemburu Misteri",
      description: "Seorang wanita bangun dari koma mendapati hidupnya telah diambil alih oleh orang lain.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 265,
      isAvailable: true,
    ),
    Book(
      id: "MB037",
      title: "Tanda Tangan Merah",
      author: "Nadia Omar",
      penerbit: "Detektif Melayu Books",
      description: "Peguam muda menyiasat kes pembunuhan di mana setiap mangsa meninggalkan tanda tangan darah.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2023),
      pages: 295,
      isAvailable: true,
    ),
    Book(
      id: "MB038",
      title: "Anak Sungai Yang Bisu",
      author: "Rizal Man",
      penerbit: "Nadi Gerak Publications",
      description: "Mayat yang muncul di sungai kecil membongkar rahsia kampung yang telah disembunyikan selama 30 tahun.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2018),
      pages: 250,
      isAvailable: true,
    ),
    Book(
      id: "MB039",
      title: "Mimpi Ngeri",
      author: "Dalia Faris",
      penerbit: "Pemburu Misteri",
      description: "Lelaki yang menderita insomnia teruk mendapati mimpi buruknya sebenarnya adalah ingatan yang dipadamkan.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 280,
      isAvailable: true,
    ),
    Book(
      id: "MB040",
      title: "Saksi Mata",
      author: "Shah Reza",
      penerbit: "Detektif Melayu Books",
      description: "Seorang saksi utama kes rasuah besar ditemui mati sehari sebelum perbicaraan dengan bukti yang menghilang.",
      genre: "Thriller/Jenayah",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 315,
      isAvailable: true,
    ),

    // ========== SEJARAH (10 books) ==========
    Book(
      id: "MB041",
      title: "Hang Tuah: Fakta vs Mitos",
      author: "Prof. Ahmad Murad",
      penerbit: "Warisan Nusantara",
      description: "Kajian mendalam tentang figura lagenda Hang Tuah berdasarkan dokumen sejarah Portugis dan Melayu.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 380,
      isAvailable: true,
    ),
    Book(
      id: "MB042",
      title: "Pattani: Kerajaan Yang Hilang",
      author: "Dr. Zainal Abidin",
      penerbit: "Zaman Silam Press",
      description: "Sejarah kerajaan Melayu Pattani dan hubungannya dengan Kesultanan Melayu Melaka sebelum penjajahan Siam.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 420,
      isAvailable: true,
    ),
    Book(
      id: "MB043",
      title: "Jejak Portugis di Melaka",
      author: "Isabel Cardoso",
      penerbit: "Pustaka Raja",
      description: "Kesan peninggalan Portugis di Melaka berdasarkan arkib dan artifak yang jarang dilihat orang ramai.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2018),
      pages: 350,
      isAvailable: true,
    ),
    Book(
      id: "MB044",
      title: "Perang Naning",
      author: "Rashid Maidin",
      penerbit: "Warisan Nusantara",
      description: "Perjuangan Dato' Dol Said dan penduduk Naning menentang penjajah British pada tahun 1830-an.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 290,
      isAvailable: true,
    ),
    Book(
      id: "MB045",
      title: "Sultan Mahmud Mangkat Dijulang",
      author: "Prof. Siti Hajar",
      penerbit: "Zaman Silam Press",
      description: "Analisis sejarah kematian kontroversi Sultan Mahmud Shah dari Melaka berdasarkan sumber primer.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2017),
      pages: 410,
      isAvailable: true,
    ),
    Book(
      id: "MB046",
      title: "Sejarah Emas Tanah Melayu",
      author: "Dr. Harith Fadzilah",
      penerbit: "Pustaka Raja",
      description: "Kegemilangan ekonomi Tanah Melayu sebagai pengeluar timah dan getah terbesar dunia suatu masa dahulu.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 360,
      isAvailable: true,
    ),
    Book(
      id: "MB047",
      title: "Tok Janggut: Pahlawan Rakyat",
      author: "Wan Ahmad Farid",
      penerbit: "Warisan Nusantara",
      description: "Biografi lengkap pejuang kemerdekaan Kelantan yang menentang penjajahan British pada 1915.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2020),
      pages: 320,
      isAvailable: true,
    ),
    Book(
      id: "MB048",
      title: "Kapal Karam di Perairan Terengganu",
      author: "Maritime Explorer",
      penerbit: "Zaman Silam Press",
      description: "Penemuan bangkai kapal kuno di perairan Terengganu yang membawa harta karun dan misteri sejarah.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2019),
      pages: 280,
      isAvailable: true,
    ),
    Book(
      id: "MB049",
      title: "Panglima Awang: Melayu Pertama Mengelilingi Dunia",
      author: "Prof. Ahmad Murad",
      penerbit: "Pustaka Raja",
      description: "Kajian tentang identiti sebenar anak kapal Magellan yang mungkin berasal dari Nusantara.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2021),
      pages: 340,
      isAvailable: true,
    ),
    Book(
      id: "MB050",
      title: "Bendera dan Jalur Gemilang",
      author: "Mohd Ali Rustam",
      penerbit: "Warisan Nusantara",
      description: "Sejarah terciptanya bendera Malaysia dan makna di sebalik setiap elemen rekaannya.",
      genre: "Sejarah",
      language: "Malay",
      publishDate: DateTime(2022),
      pages: 230,
      isAvailable: true,
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

  Future<void> updateBookAvailability(String bookId, bool isAvailable) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _books.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      final book = _books[index];
      _books[index] = Book(
        id: book.id,
        title: book.title,
        author: book.author,
        penerbit: book.penerbit,
        description: book.description,
        genre: book.genre,
        language: book.language,
        coverUrl: book.coverUrl,
        fileUrl: book.fileUrl,
        publishDate: book.publishDate,
        pages: book.pages,
        isAvailable: isAvailable,
        totalCopies: book.totalCopies,
        availableCopies: book.availableCopies,
      );
    }
  }

  // User management methods using Firestore
  Future<List<AppUser>> getUsers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AppUser.fromMap({
          'id': doc.id,
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'role': data['role'] ?? 'reader',
          'joinDate': data['joinDate']?.toDate(),
        });
      }).toList();
    } catch (e) {
      print('❌ DatabaseService: Error getting users: $e');
      return [];
    }
  }

  Future<AppUser?> getUserById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return AppUser.fromMap({
          'id': doc.id,
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'role': data['role'] ?? 'reader',
          'joinDate': data['joinDate']?.toDate(),
        });
      }
      return null;
    } catch (e) {
      print('❌ DatabaseService: Error getting user by ID: $e');
      return null;
    }
  }

  Future<void> updateUser(AppUser updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.id).update({
        'name': updatedUser.name,
        'email': updatedUser.email,
        'role': updatedUser.role,
        'joinDate': Timestamp.fromDate(updatedUser.joinDate ?? DateTime.now()),
      });
      print('✅ DatabaseService: User updated successfully');
    } catch (e) {
      print('❌ DatabaseService: Error updating user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
      print('✅ DatabaseService: User deleted successfully');
    } catch (e) {
      print('❌ DatabaseService: Error deleting user: $e');
    }
  }

  Future<List<AppUser>> searchUsers(String query) async {
    try {
      final users = await getUsers();
      return users.where((user) =>
          user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()) ||
          user.role.toLowerCase().contains(query.toLowerCase())).toList();
    } catch (e) {
      print('❌ DatabaseService: Error searching users: $e');
      return [];
    }
  }
}
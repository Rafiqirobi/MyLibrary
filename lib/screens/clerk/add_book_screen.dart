import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/models/book.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _pagesController = TextEditingController();
  final _languageController = TextEditingController();
  final _coverUrlController = TextEditingController();
  
  String _selectedCategory = 'Fiction';
  bool _isLoading = false;

  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Biography',
    'Technology',
    'Arts',
    'Religion',
    'Philosophy',
    'Literature',
    'Children',
    'Reference',
    'Epik',
    'Novel',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _descriptionController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _pagesController.dispose();
    _languageController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    
    final book = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      language: _languageController.text.trim().isEmpty ? 'Malay' : _languageController.text.trim(),
      coverUrl: _coverUrlController.text.trim().isEmpty ? 'https://via.placeholder.com/200x300?text=No+Cover' : _coverUrlController.text.trim(),
      fileUrl: 'https://example.com/books/${DateTime.now().millisecondsSinceEpoch}.pdf', // Mock file URL
      publishDate: DateTime(int.tryParse(_yearController.text.trim()) ?? DateTime.now().year),
      pages: int.tryParse(_pagesController.text.trim()) ?? 0,
      isAvailable: true,
      totalCopies: 1,
      availableCopies: 1,
    );

    try {
      await databaseService.addBook(book);
      
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book added successfully!')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Book Title *',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter book title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Author *',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter author name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _isbnController,
                  decoration: InputDecoration(
                    labelText: 'ISBN',
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category *',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _publisherController,
                  decoration: InputDecoration(
                    labelText: 'Publisher',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: InputDecoration(
                          labelText: 'Published Year',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _pagesController,
                        decoration: InputDecoration(
                          labelText: 'Pages',
                          prefixIcon: Icon(Icons.pages),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _languageController,
                  decoration: InputDecoration(
                    labelText: 'Language (default: Malay)',
                    prefixIcon: Icon(Icons.language),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _coverUrlController,
                  decoration: InputDecoration(
                    labelText: 'Cover Image URL (optional)',
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text('Add Book', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

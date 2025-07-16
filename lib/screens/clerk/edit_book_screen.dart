import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_library/services/database_service.dart';
import 'package:my_library/models/book.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  
  EditBookScreen({required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _pagesController;
  late TextEditingController _languageController;
  late TextEditingController _coverUrlController;
  late TextEditingController _totalCopiesController;
  late TextEditingController _availableCopiesController;
  
  late String _selectedCategory;
  late bool _isAvailable;
  bool _isLoading = false;

  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    
    // Initialize categories list
    _categories = [
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
    
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _descriptionController = TextEditingController(text: widget.book.description);
    _pagesController = TextEditingController(text: widget.book.pages.toString());
    _languageController = TextEditingController(text: widget.book.language);
    _coverUrlController = TextEditingController(text: widget.book.coverUrl);
    _totalCopiesController = TextEditingController(text: widget.book.totalCopies.toString());
    _availableCopiesController = TextEditingController(text: widget.book.availableCopies.toString());
    
    // Set the selected category, with fallback to first category if not found
    _selectedCategory = _categories.contains(widget.book.category) 
        ? widget.book.category 
        : _categories.first;
    _isAvailable = widget.book.isAvailable;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _pagesController.dispose();
    _languageController.dispose();
    _coverUrlController.dispose();
    _totalCopiesController.dispose();
    _availableCopiesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    
    final updatedBook = Book(
      id: widget.book.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      language: _languageController.text.trim(),
      coverUrl: _coverUrlController.text.trim(),
      fileUrl: widget.book.fileUrl, // Keep original file URL
      publishDate: widget.book.publishDate, // Keep original publish date
      pages: int.tryParse(_pagesController.text.trim()) ?? 0,
      isAvailable: _isAvailable,
      totalCopies: int.tryParse(_totalCopiesController.text.trim()) ?? 1,
      availableCopies: int.tryParse(_availableCopiesController.text.trim()) ?? 1,
    );

    try {
      await databaseService.updateBook(updatedBook);
      
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book updated successfully!')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
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
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _pagesController,
                  decoration: InputDecoration(
                    labelText: 'Pages',
                    prefixIcon: Icon(Icons.pages),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _languageController,
                  decoration: InputDecoration(
                    labelText: 'Language',
                    prefixIcon: Icon(Icons.language),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _coverUrlController,
                  decoration: InputDecoration(
                    labelText: 'Cover Image URL',
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalCopiesController,
                        decoration: InputDecoration(
                          labelText: 'Total Copies',
                          prefixIcon: Icon(Icons.inventory),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _availableCopiesController,
                        decoration: InputDecoration(
                          labelText: 'Available Copies',
                          prefixIcon: Icon(Icons.check_circle_outline),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SwitchListTile(
                  title: Text('Book Available'),
                  subtitle: Text(_isAvailable ? 'Book is available for borrowing' : 'Book is not available'),
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
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
                        child: Text('Update Book', style: TextStyle(fontSize: 18)),
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

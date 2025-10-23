import 'package:flutter/material.dart';
import '../models/book.dart';

// Widget: Displays a compact book cover image
class BookCoverImage extends StatelessWidget {
  final Book book;

  const BookCoverImage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Image.asset(
        book.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.book, size: 48, color: Colors.grey)),
          );
        },
      ),
    );
  }
}

// Widget: Displays the full details for a single book
class BookDetailCard extends StatelessWidget {
  final Book book;

  const BookDetailCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 300,
            width: 200,
            child: BookCoverImage(book: book),
          ),
          const SizedBox(height: 24),
          Text(
            book.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'by ${book.author}',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const Divider(height: 32),
          Text(
            book.description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
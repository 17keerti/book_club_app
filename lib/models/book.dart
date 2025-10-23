// Data Model: Defines the structure for a single Book object
class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String description; 

  const Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
  });
  
  @override
  String toString() {
    return 'Book(title: $title, author: $author)';
  }
}
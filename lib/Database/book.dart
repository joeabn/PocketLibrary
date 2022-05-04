class Book {
  final int? id;
  final String title;
  final String author;
  final String genre;
  final int bookmark;
  final String path;

  const Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.bookmark,
    required this.path,
    this.id,
  });
}
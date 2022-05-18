class Book {
  int? id;
  String title;
  String? author;
  String? genre;
  int? bookmark;
  String path;

  Book({
    required this.title,
    required this.path,
    this.author,
    this.genre,
    this.bookmark,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'bookmark': bookmark,
      'path': path,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    var book = Book(
        title: map['title'],
        author: map['author'],
        genre: map['genre'],
        bookmark: map['bookmark'],
        path: map['path'],
        id: map['id']);
    return book;
  }
}
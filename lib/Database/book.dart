class Book {
  int? id;
  String title;
  String? author;
  String? genre;
  int bookmark;
  String path;
  String? isbn;
  String? imagePath;
  bool isCurrent;

  Book({
    required this.title,
    required this.path,
    this.author,
    this.genre,
    this.id,
    this.isCurrent = false,
    this.bookmark = 0,
    this.isbn,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'bookmark': bookmark,
      'path': path,
      'isCurrent': isCurrent ? 1 : 0,
      'isbn': isbn,
      'imagePath': imagePath
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    var book = Book(
        title: map['title'],
        author: map['author'],
        genre: map['genre'],
        bookmark: map['bookmark'],
        path: map['path'],
        isCurrent: map['isCurrent'] == 1 ? true : false,
        isbn: map['isbn'],
        imagePath: map['imagePath'],
        id: map['id']);
    return book;
  }
}
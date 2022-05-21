enum BookCoverSize {
  small,
  medium,
  large,
}

class BookCoverService {
  static const baseURl = "https://covers.openlibrary.org/b/isbn/";

  static String getBookCoverPathByISBN(String isbn, BookCoverSize size) {
    String pathParam = isbn;

    switch (size) {
      case BookCoverSize.small:
        pathParam += "-S";
        break;
      case BookCoverSize.medium:
        pathParam += "-M";
        break;
      case BookCoverSize.large:
        pathParam += "-L";
        break;
    }
    pathParam += ".jpg";
    return (baseURl + pathParam);
  }
}

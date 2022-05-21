enum bookCoverSize {
  small,
  medium,
  large,
}

class BookCoverService {
  static const baseURl = "https://covers.openlibrary.org/b/isbn/";

  static String getBookCoverPathByISBN(String isbn, bookCoverSize size) {
    String pathParam = isbn;

    switch (size) {
      case bookCoverSize.small:
        pathParam += "-S";
        break;
      case bookCoverSize.medium:
        pathParam += "-M";
        break;
      case bookCoverSize.large:
        pathParam += "-L";
        break;
    }
    pathParam += ".jpg";
    return (baseURl + pathParam);
  }
}

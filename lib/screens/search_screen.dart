import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Database/DatabaseContext.dart';
import '../Database/book.dart';
import '../widgets/network_book_image.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  List<Book> books = [];
  late String SearchKeyword;

  // _SearchScreen(this.SearchKeyword);

  Future<List<Book>> fetchBooks() async {
    final DatabaseHandler _db = DatabaseHandler();
    books = await _db.getBooks();
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SearchKeyword),
      ),
      body: FutureBuilder<List>(
        future: fetchBooks(),
        initialData: const [],
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, int position) {
                    final item = snapshot.data![position];
                    //get your item data here ...
                    return Card(
                      child: ListTile(
                        leading: NetworkBookImage(imagePath: item.imagePath),
                        title: Text(item.title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailsScreen(book: item);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pocket_library/screens/add_book_screen.dart';
import 'package:pocket_library/screens/reading_screen.dart';
import 'package:pocket_library/widgets/continue_reading_card.dart';

import '../Database/DatabaseContext.dart';
import '../Database/book.dart';
import '../constants.dart';
import '../widgets/book_card.dart';
import '../widgets/book_rating.dart';
import '../widgets/drawer.dart';
import '../widgets/two_side_rounded_button.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Book> books = [];
  Book? currentBook;
  final DatabaseHandler _db = DatabaseHandler();

  int i = 0;

  @override
  void initState() {
    fetchBooks();
    fetchCurrentBook();
  }

  Future<void> fetchBooks() async {
    var dbbooks = await _db.getBooks();
    setState(() {
      books = dbbooks;
    });
    if (i == 0) {
      books.forEach((Book book) {
        print(book.title);
        print(book.isCurrent);
        print(book.bookmark);
      });
      i++;
    }
  }

  Future<void> fetchCurrentBook() async {
    currentBook = await _db.getCurrentBook();
  }

  List<Widget> getBookWidgets() {
    List<Widget> widgets = [];

    books.forEach((Book book) {
      var bookCard = BookCard(
        image: book.imagePath ?? "assets/images/book-1.png",
        title: book.title,
        author: book.author,
        rating: 4.9,
        pressDetails: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailsScreen(book: book);
              },
            ),
          );
        },
        pressRead: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ReadingScreen(book: book);
              },
            ),
          );
        },
      );

      widgets = [...widgets, bookCard];
    });
    return widgets;
  }

  addColumn() async {
    final DatabaseHandler _db = DatabaseHandler();
    _db.addColumn();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: kRedColor,
        elevation: 0,
        /*    actions: [
            IconButton(
              onPressed: addColumn, icon: const Icon(Icons.add))]
      */
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/main_page_bg.png"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  if (books.length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium,
                          children: const [
                            TextSpan(text: "What are you \nreading "),
                            TextSpan(
                                text: "today?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: getBookWidgets(),
                      ),
                    )
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headlineMedium,
                            children: const [
                              TextSpan(text: "Best of the "),
                              TextSpan(
                                text: "day",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        wideBookCard(size, context),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headlineMedium,
                            children: const [
                              TextSpan(text: "Continue "),
                              TextSpan(
                                text: "reading...",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        if (currentBook != null) ...[
                          const SizedBox(height: 20),
                          ContinueReadingCard(book: currentBook!)
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddBookScreen();
              },
            ),
          );
        },
        backgroundColor: kRedColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Container wideBookCard(Size size, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: const Text(
                      "New York Time Best For 11th March 2020",
                      style: TextStyle(
                        fontSize: 9,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  Text(
                    "How To Win \nFriends &  Influence",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text(
                    "Gary Venchuk",
                    style: const TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: BookRating(score: 4.9),
                        ),
                        Expanded(
                          child: Text(
                            "When the earth was flat and everyone wanted to win the game of the best and people….",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/book-3.png",
              width: size.width * .37,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Read",
                radious: 24,
                press: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

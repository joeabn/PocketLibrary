import 'package:flutter/material.dart';
import 'package:pocket_library/Database/book.dart';
import 'package:pocket_library/screens/reading_screen.dart';

import '../constants.dart';
import 'network_book_image.dart';

class ContinueReadingCard extends StatelessWidget {
  final Book book;

  const ContinueReadingCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ReadingScreen(book: book);
              },
            ),
          );
        },
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38.5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 33,
                color: const Color(0xFFD3D3D3).withOpacity(.84),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(38.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                book.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (book.author != null)
                                Text(
                                  book.author!,
                                  style: TextStyle(
                                    color: kLightBlackColor,
                                  ),
                                ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Chapter 7 of 10",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: kLightBlackColor,
                                      ),
                                    )),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        NetworkBookImage(
                            imagePath: book.imagePath, width: 55, height: 90),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 7,
                  width: size.width * .65,
                  decoration: BoxDecoration(
                    color: kProgressIndicator,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

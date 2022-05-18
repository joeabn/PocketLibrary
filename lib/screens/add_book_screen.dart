import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as dartPath;
import 'package:path_provider/path_provider.dart';
import 'package:pocket_library/screens/reading_screen.dart';

import '../Database/DatabaseContext.dart';
import '../Database/book.dart';
import '../widgets/rounded_button.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBookScreen> {
  String _fileName = "";
  String _filePath = "";

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);

    print(result.files.first.size);
    print(result.files.first.path);
    var filePath = result.files.first.path;
    final DatabaseHandler _db = DatabaseHandler();

    if (filePath != null) {
      Book newFile = await _saveFile(filePath, result.files.first.name);
      _fileName = result.files.first.name;
      _filePath = newFile.path;
      var books = await _db.getBooks();
      print(books.first.id);
      print(books.first.path);
      print(books.first.title);
      print(books.first.bookmark);
    }
  }

  Future<Book> _saveFile(String filePath, String fileName) async {
    final DatabaseHandler _db = DatabaseHandler();

    var path = await _getAppDirectory();
    print("copying to file ${path.toString()}");
    File oldFile = File(filePath);
    print("old path is : ${oldFile.path}");
    var basNameWithExtension = dartPath.basename(oldFile.path);
    print("new path is : ${path.toString()}/$basNameWithExtension");
    //
    // File fileCopy = await oldFile.copy(path.toString());
    Book book = Book(
        title: fileName, author: "", genre: "", bookmark: 0, path: filePath);

    await _db.insertBook(book);
    return book;
  }

  Future<String> _getAppDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    const folderName = "books";

    final path = Directory("${appDocDir.absolute}/$folderName");

    if ((await path.exists())) {
      print("exist");
    } else {
      print("not exist");
      // await path.create(recursive: true);
    }
    return path.path;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
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

              children: [
                SizedBox(height: size.height * .1),
                RoundedButton(text: "Import File", press: _pickFile),
                FlatButton(onPressed: () {
                  print(_fileName);
                  print(_filePath);
                  Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) {
                          return ReadingScreen(
                              book: Book(
                                  title: _fileName,
                                  author: "Joe",
                                  genre: "Tragedy",
                                  bookmark: 3,
                                  path: _filePath));
                        },
                      ));
                }, child: const Text("read"))
              ],
            )));
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Database/DatabaseContext.dart';
import '../Database/book.dart';
import '../services/book_cover_service.dart';
import '../services/cloud_storage_service.dart';
import '../widgets/book_form.dart';
import '../widgets/book_upload_tile.dart';
import 'home_screen.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  _uploadBookState createState() => _uploadBookState();
}

class _uploadBookState extends State<AddBookScreen> {
  UploadTask? _uploadTask;

  String _fileName = "";

  String _filePath = "";

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadFile(File? file, String fileName) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
      return null;
    }
    _fileName = fileName;
    return await CloudStorageService.uploadFile(file, fileName);
  }

  /// A new string is uploaded to storage.
  UploadTask uploadString() {
    const String putStringText =
        'This upload has been generated using the putString method! Check the metadata too!';

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('flutter-tests')
        .child('/put-string-example.txt');

    // Start upload of putString
    return ref.putString(
      putStringText,
      metadata: SettableMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'example': 'putString'},
      ),
    );
  }

  /// Handles the user pressing the PopupMenuItem item.
  Future<void> handleUploadPressed() async {
    final filePickerResult = (await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['pdf']))
        ?.files
        .first;

    var newFile = File(filePickerResult?.path ?? "");
    UploadTask? task = await uploadFile(newFile, filePickerResult?.name ?? "");

    if (task != null) {
      setState(() {
        _uploadTask = task;
      });
    }
  }

  Future<String> _downloadLink(Reference ref) async {
    final link = await ref.getDownloadURL();
    return link;
  }

  Future<void> _clearCurrentTask() async {
    var downloadLink = await _downloadLink(_uploadTask!.snapshot.ref);
    await CloudStorageService.deleteFile(downloadLink);
    setState(() {
      _uploadTask = null;
    });
  }

  Future<void> addBookToDb(Book book) async {
    final DatabaseHandler _db = DatabaseHandler();
    book.path = await _downloadLink(_uploadTask!.snapshot.ref);

    if (book.isbn != null) {
      book.imagePath = BookCoverService.getBookCoverPathByISBN(
          book.isbn!, BookCoverSize.medium);
    }

    await _db.insertBook(book);

    var books = await _db.getBooks();
    books.forEach((Book book) {
      print(book.id);
      print(book.path);
      print(book.author);
      print(book.genre);
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Storage Example App'),
          actions: [
            _uploadTask == null
                ? IconButton(
                    onPressed: handleUploadPressed, icon: const Icon(Icons.add))
                : IconButton(
                    onPressed: _clearCurrentTask,
                    icon: const Icon(Icons.delete))
          ],
        ),
        body: _uploadTask == null
            ? const Center(
                child: Text("Press the '+' button to add a new file."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: 1,
                      child: BookUploadTile(
                        task: _uploadTask!,
                        title: _fileName,
                        onDismissed: () => _clearCurrentTask(),
                      )),
                  Expanded(flex: 8, child: BookForm(submitForm: addBookToDb))
                ],
              ));
  }
}

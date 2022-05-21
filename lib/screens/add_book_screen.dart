import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as dartPath;
import 'package:path_provider/path_provider.dart';
import 'package:pocket_library/Utils/validator.dart';
import 'package:pocket_library/screens/reading_screen.dart';
import 'package:pocket_library/widgets/rounded_text_field.dart';

import '../Database/DatabaseContext.dart';
import '../Database/book.dart';
import '../services/cloud_storage_service.dart';
import '../widgets/rounded_button.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  _uploadBookState createState() => _uploadBookState();
}

class _AddBookState extends State<AddBookScreen> {
  String _fileName = "";
  String _filePath =
      "https://firebasestorage.googleapis.com/v0/b/pocketlibrary-3872c.appspot.com/o/flutter-tests%2Fsome-image.pdf?alt=media&token=ee752154-8116-4cd6-bbf2-fe75ad565d87";

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

  Future<String> _uploadDocumentToCloud(Book book) async {
    var file = File(book.path);

    var uploadTask = await CloudStorageService.uploadFile(file, book.title);
    // uploadTask.whenComplete(() =>)
    // uploadTask.snapshot.ref
    return "";
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
                FlatButton(
                    onPressed: () {
                      print(_fileName);
                      print(_filePath);
                      Navigator.push(context, MaterialPageRoute(
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
                    },
                    child: const Text("read"))
              ],
            )));
  }
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

  void _removeTaskAtIndex() {
    setState(() {
      _uploadTask = null;
    });
  }

  Future<String> _downloadLink(Reference ref) async {
    final link = await ref.getDownloadURL();
    return link;
  }

  void _clearTasks() {
    setState(() {
      _uploadTask = null;
    });
  }

  Future<void> addBookToDb(String title, String? author, String? genre) async {
    final DatabaseHandler _db = DatabaseHandler();
    var filePath = await _downloadLink(_uploadTask!.snapshot.ref);

    Book book =
        new Book(title: title, path: filePath, author: author, genre: genre);
    await _db.insertBook(book);

    var books = await _db.getBooks();
    books.forEach((Book book) {
      print(book.id);
      print(book.path);
      print(book.author);
      print(book.genre);
    });
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
                    onPressed: _clearTasks, icon: const Icon(Icons.delete))
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
                      child: UploadTaskListTile(
                          task: _uploadTask!,
                          onDismissed: () => _removeTaskAtIndex(),
                          onSaveBookClick: () async {
                            _filePath =
                                await _downloadLink(_uploadTask!.snapshot.ref);

                            Navigator.push(context, MaterialPageRoute(
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
                          })),
                  Expanded(flex: 8, child: BookForm(submitForm: addBookToDb))
                ],
              ));
  }
}

/// Displays the current state of a single UploadTask.
class UploadTaskListTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const UploadTaskListTile({
    Key? key,
    required this.task,
    required this.onDismissed,
    required this.onSaveBookClick,
  }) : super(key: key);

  /// The [UploadTask].
  final UploadTask task;

  /// Triggered when the user dismisses the task from the list.
  final VoidCallback onDismissed;

  /// Triggered when the user presses the "link" button on a completed upload task.
  final VoidCallback onSaveBookClick;

  /// Displays the current transferred bytes of the task.
  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (
        BuildContext context,
        AsyncSnapshot<TaskSnapshot> asyncSnapshot,
      ) {
        Widget subtitle = const Text('---');
        TaskSnapshot? snapshot = asyncSnapshot.data;
        TaskState? state = snapshot?.state;

        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is FirebaseException &&
              // ignore: cast_nullable_to_non_nullable
              (asyncSnapshot.error as FirebaseException).code == 'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            // ignore: avoid_print
            print(asyncSnapshot.error);
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null) {
          subtitle = Text('$state: ${_bytesTransferred(snapshot)} bytes sent');
        }

        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: ($) => onDismissed(),
          child: Container(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Upload Task #${task.hashCode}'),
                    subtitle: subtitle,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (state == TaskState.running)
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: task.pause,
                          ),
                        if (state == TaskState.running)
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: task.cancel,
                          ),
                        if (state == TaskState.paused)
                          IconButton(
                            icon: const Icon(Icons.file_upload),
                            onPressed: task.resume,
                          ),
                        if (state == TaskState.success)
                          IconButton(
                            icon: const Icon(Icons.link),
                            onPressed: onSaveBookClick,
                          ),
                      ],
                    ),
                  ))),
        );
      },
    );
  }
}

class BookForm extends StatelessWidget {
  final Future<void> Function(String, String?, String?) submitForm;
  final _formKey = GlobalKey<FormState>();

  final _focusTitle = FocusNode();
  final _focusAuthor = FocusNode();
  final _focusGenre = FocusNode();

  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();
  final _genreTextController = TextEditingController();

  BookForm({Key? key, required this.submitForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 15.0),
                          RoundedTextField(
                              textHint: "Title",
                              editingController: _titleTextController,
                              focusNode: _focusTitle),
                          const SizedBox(height: 15.0),
                          RoundedTextField(
                              textHint: "Author",
                              editingController: _authorTextController,
                              focusNode: _focusAuthor),
                          // const SizedBox(height: 15.0),
                          // RoundedTextField(textHint: "Genre",
                          //     editingController: _genreTextController,
                          //     focusNode: _focusGenre),
                          const SizedBox(height: 15.0),
                          RoundedTextField(
                            textHint: "ISBN",
                            editingController: _genreTextController,
                            focusNode: _focusGenre,
                            validator: (value) =>
                                Validator.validateISBN(isbn: value),
                          ),
                          const SizedBox(height: 20.0),
                          RoundedButton(
                              text: "Save Book",
                              press: () async {
                                _focusTitle.unfocus();
                                _focusAuthor.unfocus();
                                _focusGenre.unfocus();
                                print(_formKey.currentState!.validate());
                                // await submitForm(
                                //     _titleTextController.text,
                                //     _authorTextController.text,
                                //     _genreTextController.text
                                // );
                              })
                        ])))));
    /*GestureDetector(
          onTap: () {
            _focusTitle.unfocus();
            _focusAuthor.unfocus();
            _focusGenre.unfocus();
          },
          child:
      );*/
  }
}

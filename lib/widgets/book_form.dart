import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_library/widgets/rounded_button.dart';
import 'package:pocket_library/widgets/rounded_text_field.dart';

import '../Database/book.dart';
import '../Utils/validator.dart';

class BookForm extends StatelessWidget {
  final Future<void> Function(Book book) submitForm;
  final _formKey = GlobalKey<FormState>();

  final _focusTitle = FocusNode();
  final _focusAuthor = FocusNode();
  final _focusGenre = FocusNode();
  final _focusIsbn = FocusNode();

  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();
  final _genreTextController = TextEditingController();
  final _isbnTextController = TextEditingController();

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
                              focusNode: _focusTitle,
                              validator: (value) =>
                                  Validator.required(name: value)),
                          const SizedBox(height: 15.0),
                          RoundedTextField(
                              textHint: "Author",
                              editingController: _authorTextController,
                              focusNode: _focusAuthor),
                          const SizedBox(height: 15.0),
                          RoundedTextField(
                              textHint: "Genre",
                              editingController: _genreTextController,
                              focusNode: _focusGenre),
                          const SizedBox(height: 15.0),
                          RoundedTextField(
                            textHint: "ISBN",
                            editingController: _isbnTextController,
                            focusNode: _focusIsbn,
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
                                if (_formKey.currentState!.validate()) {
                                  await submitForm(Book(
                                      title: _titleTextController.text,
                                      path: "",
                                      genre: _genreTextController.text,
                                      author: _authorTextController.text,
                                      isbn: _isbnTextController.text));
                                }
                              })
                        ])))));
  }
}

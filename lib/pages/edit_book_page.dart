import 'package:flutter/material.dart';
import '../db/database.dart';
import '../model/book.dart';
import '../widget/book_form_widget.dart';

class AddEditBookPage extends StatefulWidget {
  final Book? book;

  const AddEditBookPage({
    Key? key,
    this.book,
  }) : super(key: key);

  @override
  State<AddEditBookPage> createState() => _AddEditbookPageState();
}

class _AddEditbookPageState extends State<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String image;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.book?.title ?? '';
    description = widget.book?.description ?? '';
    image = widget.book?.image ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: BookFormWidget(
            title: title,
            description: description,
            image: image,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedImage: (image) => setState(() => this.image = image),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.lightBlueAccent,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdatebook,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdatebook() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.book != null;

      if (isUpdating) {
        await updatebook();
      } else {
        await addbook();
      }

      Navigator.of(context).pop();
    }
  }

  Future updatebook() async {
    final book = widget.book!.copy(
      title: title,
      description: description,
      image: image,
    );

    await BooksDatabase.instance.update(book);
  }

  Future addbook() async {
    final book = Book(
      title: title,
      description: description,
      image: image,
      createdTime: DateTime.now(),
    );

    await BooksDatabase.instance.create(book);
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';
import '../model/book.dart';
import '../pages/edit_book_page.dart';

class BookDetailPage extends StatefulWidget {
  final int BookId;

  const BookDetailPage({
    Key? key,
    required this.BookId,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Book book;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshBook();
  }

  Future refreshBook() async {
    setState(() => isLoading = true);

    book = await BooksDatabase.instance.readBook(widget.BookId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // get image from image link
                    Image.network(book.image),
                    const SizedBox(height: 10),
                    Text(
                      book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(book.createdTime),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      color: Colors.lightBlue,
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditBookPage(book: book),
        ));

        refreshBook();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.lightBlue,
        onPressed: () async {
          await BooksDatabase.instance.delete(widget.BookId);

          Navigator.of(context).pop();
        },
      );
}

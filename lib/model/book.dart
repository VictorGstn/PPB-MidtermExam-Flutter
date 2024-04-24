final String tableBooks = 'books';

class BookFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, image, time
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final String image = 'image';
}

class Book {
  final int? id;
  final String title;
  final String description;
  final String image;
  final DateTime createdTime;

  const Book({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.image,
  });

  static Book fromJson(Map<String, Object?> json) => Book(
        id: json[BookFields.id] as int?,
        title: json[BookFields.title] as String,
        description: json[BookFields.description] as String,
        image: json[BookFields.image] as String,
        createdTime: DateTime.parse(json[BookFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        BookFields.id: id,
        BookFields.title: title,
        BookFields.description: description,
        BookFields.image: image,
        BookFields.time: createdTime.toIso8601String(),
      };

  Book copy({
    int? id,
    String? title,
    String? description,
    String? image,
    DateTime? createdTime,
  }) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        createdTime: createdTime ?? this.createdTime,
      );
}

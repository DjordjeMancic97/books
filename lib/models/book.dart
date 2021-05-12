class Book {
  dynamic description;
  String title;
  int image;
  List subjects;
  List mainCharacters;
  String key;

  Book({
    this.description,
    this.title,
    this.image,
    this.subjects,
    this.mainCharacters,
    this.key,
  });

  Book.json(Map<String, dynamic> json) {
    this.title = json['title'];
    this.description = json['description'] != null
        ? json['description'].length <= 2
            ? json['description']['value']
            : json['description']
        : 'No description provided';

    this.image = json['covers'].first ?? 0;
    this.subjects = json['subjects'];
    this.mainCharacters = json['subject_people'];
    this.key = json['key'];
  }
}

class BookResult {
  String title;
  String link;
  int image;
  List authorNames;
  List searchPhrases;
  BookResult({
    this.title,
    this.link,
    this.image,
    this.authorNames,
    this.searchPhrases,
  });

  BookResult.fromJson(Map<String, dynamic> json)
      : this.title = json['title'],
        this.link = json['key'],
        // this.image = json['isbn'].first ?? '';
        this.image = json['cover_i'] ?? 0,
        this.authorNames = json['author_name'],
        this.searchPhrases = json['text'];

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'key': this.link,
      'cover_i': this.image,
      'author_name': this.authorNames,
      'text': this.searchPhrases,
    };
  }
}

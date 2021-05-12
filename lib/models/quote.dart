class Quote {
  String quote;
  String author;

  Quote(this.quote, this.author);

  Quote.fromJson(Map<String, dynamic> json)
      : this.quote = json['text'],
        this.author = json['author'];
}

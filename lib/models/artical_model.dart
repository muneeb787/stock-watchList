class Article {
  String source;
  //String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  //String content;

  Article({
    required this.source,
    //required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    //required this.content
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: json['source'],
      //author: json['authors']['0'],
      title: json['title'],
      description: json['summary'],
      url: json['url'],
      urlToImage: json['banner_image'] ?? '',
      publishedAt: json['time_published'],
      //content: json['content'] as String,
    );
  }
}

class NewsModel {
  final int id;
  final String title;
  final String description;
  final String content;
  final String? image;
  final String? url;
  final String? source;
  final String? category;
  final String publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.image,
    this.url,
    this.source,
    this.category,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      image: json['image'],
      url: json['url'],
      source: json['source']?.toString(),
      category: json['category']?.toString(),
      publishedAt: json['published_at'] ?? '',
    );
  }
}
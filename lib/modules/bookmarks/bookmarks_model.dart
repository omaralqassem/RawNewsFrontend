class BookmarkModel {
  final int id;
  final int newsId;
  final String title;
  final String description;
  final String? source;
  final String publishedAt;

  BookmarkModel({
    required this.id,
    required this.newsId,
    required this.title,
    required this.description,
    this.source,
    required this.publishedAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    final news = json['news'] ?? json;
    return BookmarkModel(
      id: json['id'] ?? 0,
      newsId: news['id'] ?? 0,
      title: news['title'] ?? '',
      description: news['description'] ?? '',
      source: news['source']?.toString(),
      publishedAt: news['published_at'] ?? '',
    );
  }

  void operator [](String other) {}
}
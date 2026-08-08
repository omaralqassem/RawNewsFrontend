class BookmarkModel {
  final int id;
  final int articleId;
  final String articleTitle;
  final String articleSource;
  final String articleUrl;
  final String createdAt;

  BookmarkModel({
    required this.id,
    required this.articleId,
    required this.articleTitle,
    required this.articleSource,
    required this.articleUrl,
    required this.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] ?? 0,
      articleId: json['article_id'] ?? 0,
      articleTitle: json['article_title'] ?? '',
      articleSource: json['article_source'] ?? '',
      articleUrl: json['article_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
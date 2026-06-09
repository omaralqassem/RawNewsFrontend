class NewsClusterModel {
  final String id;
  final String title;
  final String category;
  final DateTime publishedAt;
  final String smartSummary;
  final String neutralConsensus;
  final List<SourceArticleModel> articles;

  NewsClusterModel({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedAt,
    required this.smartSummary,
    required this.neutralConsensus,
    required this.articles,
  });
}

class SourceArticleModel {
  final String id;
  final String sourceName;
  final String author;
  final String originalUrl;
  final String fullText;
  final double biasScore;
  final String biasLabel;
  final String comparativeExcerpt;

  SourceArticleModel({
    required this.id,
    required this.sourceName,
    required this.author,
    required this.originalUrl,
    required this.fullText,
    required this.biasScore,
    required this.biasLabel,
    required this.comparativeExcerpt,
  });
}

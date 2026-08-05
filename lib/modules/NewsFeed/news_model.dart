class NewsModel {
  final int id;
  final String title;
  final String? content;
  final String sourceName;
  final String publishedAt;
  final String? url;
  final int? clusterId;
  final double? reliabilityScore;
  final double? neutralityScore;

  NewsModel({
    required this.id,
    required this.title,
    this.content,
    required this.sourceName,
    required this.publishedAt,
    this.url,
    this.clusterId,
    this.reliabilityScore,
    this.neutralityScore,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'],
      sourceName: json['source_name'] ?? '',
      publishedAt: json['published_at'] ?? '',
      url: json['url'],
      clusterId: json['cluster_id'],
      reliabilityScore: json['reliability_score']?.toDouble(),
      neutralityScore: json['neutrality_score']?.toDouble(),
    );
  }
}
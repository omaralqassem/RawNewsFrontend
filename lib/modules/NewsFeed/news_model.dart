class NewsModel {
  final int id;
  final String url;
  final String title;
  final String sourceName;
  final String publishedAt;
  final double reliabilityScore;
  final double neutralityScore;
  final bool verified;
  final String statementType;
  final String attributionLabel;
  final String propagandaLabel;
  final int clusterId;
  final String? content;

  NewsModel({
    required this.id,
    required this.url,
    required this.title,
    required this.sourceName,
    required this.publishedAt,
    required this.reliabilityScore,
    required this.neutralityScore,
    required this.verified,
    required this.statementType,
    required this.attributionLabel,
    required this.propagandaLabel,
    required this.clusterId,
    this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      sourceName:
          json['source_name']?.toString() ??
          json['source']?.toString() ??
          'Web Source',
      publishedAt: json['published_at']?.toString() ?? '',
      reliabilityScore: (json['reliability_score'] as num?)?.toDouble() ?? 0.0,
      neutralityScore: (json['neutrality_score'] as num?)?.toDouble() ?? 0.0,
      verified: json['verified'] == true,
      statementType: json['statement_type']?.toString() ?? 'reporting',
      attributionLabel:
          json['attribution_label']?.toString() ?? 'unsupported_claim',
      propagandaLabel: json['propaganda_label']?.toString() ?? 'Error',
      clusterId: json['cluster_id'] is int
          ? json['cluster_id']
          : int.tryParse(json['cluster_id']?.toString() ?? '0') ?? 0,
      content: json['content']?.toString() ?? json['summary']?.toString(),
    );
  }
}

class ClusterModel {
  final int clusterId;
  final String? summary;
  final List<NewsModel> articles;

  ClusterModel({
    required this.clusterId,
    this.summary,
    required this.articles,
  });

  factory ClusterModel.fromJson(Map<String, dynamic> json) {
    return ClusterModel(
      clusterId: json['cluster_id'] != null 
          ? int.tryParse(json['cluster_id'].toString()) ?? 0 
          : 0,
      summary: json['summary']?.toString(),
      articles: (json['articles'] as List? ?? [])
          .map((a) => NewsModel.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}

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
  final bool? verified;
  final String? statementType;
  final String? attributionLabel;
  final String? propagandaLabel;

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
    this.verified,
    this.statementType,
    this.attributionLabel,
    this.propagandaLabel,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      title: json['title']?.toString() ?? 'No Title',
      content: json['content']?.toString(),
      sourceName: (json['source_name'] ?? json['source']?['name'])?.toString() ?? 'Unknown Source',
      publishedAt: json['published_at']?.toString() ?? DateTime.now().toIso8601String(),
      url: json['url']?.toString(),
      clusterId: json['cluster_id'] != null ? int.tryParse(json['cluster_id'].toString()) : null,
      
      reliabilityScore: (json['reliability_score'] as num?)?.toDouble(),
      neutralityScore: (json['neutrality_score'] as num?)?.toDouble(),
      
      verified: json['verified'] == true || json['verified'] == 'true',
      statementType: json['statement_type']?.toString(),
      attributionLabel: json['attribution_label']?.toString(),
      propagandaLabel: json['propaganda_label']?.toString(),
    );
  }
}
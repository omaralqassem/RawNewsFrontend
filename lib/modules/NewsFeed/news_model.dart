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
  final String? propagandaLabel;   
  final String? statementType;     
  final String? attributionLabel; 

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
    this.propagandaLabel,
    this.statementType,
    this.attributionLabel,
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
      propagandaLabel: json['propaganda_label'],
      statementType: json['statement_type'],
      attributionLabel: json['attribution_label'],
    );
  }
}
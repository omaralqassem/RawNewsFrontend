import 'package:rawnes/modules/NewsFeed/news_model.dart';

class SearchResponseModel {
  final String query;
  final String timeWindow;
  final List<NewsClusterModel> clusters;

  SearchResponseModel({
    required this.query,
    required this.timeWindow,
    required this.clusters,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    List<NewsClusterModel> parsedClusters = [];

    if (json.containsKey('clusters') && json['clusters'] is List) {
      var clusterList = json['clusters'] as List;
      for (var item in clusterList) {
        if (item is Map) {
          try {
            parsedClusters.add(
              NewsClusterModel.fromJson(Map<String, dynamic>.from(item)),
            );
          } catch (e) {
            print("Error parsing cluster item: $e");
          }
        }
      }
    } else if ((json.containsKey('results') && json['results'] is List) ||
        (json.containsKey('data') && json['data'] is List)) {
      var rawResults = (json['results'] ?? json['data']) as List;
      List<NewsModel> articles = [];

      for (int i = 0; i < rawResults.length; i++) {
        if (rawResults[i] is Map) {
          try {
            var item = Map<String, dynamic>.from(rawResults[i]);

            item['id'] = item['id'] ?? (i + 1);
            item['source_name'] =
                item['source'] ?? item['source_name'] ?? 'Web Source';
            item['published_at'] =
                item['published_at'] ?? item['scraped_at'] ?? '';

            articles.add(NewsModel.fromJson(item));
          } catch (e) {
            print("Error parsing article item: $e");
          }
        }
      }

      if (articles.isNotEmpty) {
        parsedClusters.add(
          NewsClusterModel(
            clusterId: 1,
            summary:
                "AI aggregated ${articles.length} sources for this search query.",
            articles: articles,
          ),
        );
      }
    }

    return SearchResponseModel(
      query:
          json['query']?.toString() ??
          json['config']?['query']?.toString() ??
          '',
      timeWindow:
          json['time_window']?.toString() ??
          json['config']?['time_window']?.toString() ??
          '3d',
      clusters: parsedClusters,
    );
  }
}

class NewsClusterModel {
  final int clusterId;
  final String? summary;
  final List<NewsModel> articles;

  NewsClusterModel({
    required this.clusterId,
    this.summary,
    required this.articles,
  });

  factory NewsClusterModel.fromJson(Map<String, dynamic> json) {
    var rawArticles = json['articles'] as List? ?? [];
    List<NewsModel> parsedArticles = [];

    for (var a in rawArticles) {
      if (a is Map) {
        try {
          parsedArticles.add(NewsModel.fromJson(Map<String, dynamic>.from(a)));
        } catch (e) {
          print("Error parsing article inside cluster: $e");
        }
      }
    }

    int parsedClusterId = 0;
    if (json['cluster_id'] != null) {
      parsedClusterId = int.tryParse(json['cluster_id'].toString()) ?? 0;
    }

    return NewsClusterModel(
      clusterId: parsedClusterId,
      summary: json['summary']?.toString(),
      articles: parsedArticles,
    );
  }
}

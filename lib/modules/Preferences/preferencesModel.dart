class UserPreferences {
  List<String> preferredEntities;
  List<String> mutedSources;
  List<String> favoriteSources;
  String biasFilterMode;

  String defaultViewMode;
  bool showNewsTicker;
  List<String> newsTickerTopics;
  String summaryLength;
  bool isDarkMode;
  double fontSize;

  UserPreferences({
    required this.preferredEntities,
    required this.mutedSources,
    required this.favoriteSources,
    required this.biasFilterMode,
    required this.defaultViewMode,
    required this.showNewsTicker,
    required this.newsTickerTopics,
    required this.summaryLength,
    required this.isDarkMode,
    required this.fontSize,
  });

  factory UserPreferences.initial() {
    return UserPreferences(
      preferredEntities: ['الذكاء الاصطناعي', 'الشرق الأوسط'],
      mutedSources: [],
      favoriteSources: [],
      biasFilterMode: 'allow_all',
      defaultViewMode: 'neutral_text',
      showNewsTicker: true,
      newsTickerTopics: ['سياسة', 'اقتصاد'],
      summaryLength: 'medium',
      isDarkMode: false,
      fontSize: 14.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredEntities': preferredEntities,
      'mutedSources': mutedSources,
      'favoriteSources': favoriteSources,
      'biasFilterMode': biasFilterMode,
      'defaultViewMode': defaultViewMode,
      'showNewsTicker': showNewsTicker,
      'newsTickerTopics': newsTickerTopics,
      'summaryLength': summaryLength,
      'isDarkMode': isDarkMode,
      'fontSize': fontSize,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      preferredEntities: List<String>.from(json['preferredEntities'] ?? []),
      mutedSources: List<String>.from(json['mutedSources'] ?? []),
      favoriteSources: List<String>.from(json['favoriteSources'] ?? []),
      biasFilterMode: json['biasFilterMode'] ?? 'allow_all',
      defaultViewMode: json['defaultViewMode'] ?? 'neutral_text',
      showNewsTicker: json['showNewsTicker'] ?? true,
      newsTickerTopics: List<String>.from(json['newsTickerTopics'] ?? []),
      summaryLength: json['summaryLength'] ?? 'medium',
      isDarkMode: json['isDarkMode'] ?? false,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/modules/Preferences/preferencesModel.dart';

class PreferencesController extends GetxController {
  final rxPreferences = UserPreferences.initial().obs;

  List<String> get preferredEntities => rxPreferences.value.preferredEntities;
  List<String> get mutedSources => rxPreferences.value.mutedSources;
  List<String> get favoriteSources => rxPreferences.value.favoriteSources;
  String get biasFilterMode => rxPreferences.value.biasFilterMode;
  String get defaultViewMode => rxPreferences.value.defaultViewMode;
  bool get showNewsTicker => rxPreferences.value.showNewsTicker;
  List<String> get newsTickerTopics => rxPreferences.value.newsTickerTopics;
  String get summaryLength => rxPreferences.value.summaryLength;
  bool get isDarkMode => rxPreferences.value.isDarkMode;
  double get fontSize => rxPreferences.value.fontSize;

  @override
  void onInit() {
    super.onInit();
    _loadStoredPreferences();
  }

  void _loadStoredPreferences() {}

  void addPreferredEntity(String entity) {
    if (entity.trim().isEmpty) return;
    rxPreferences.update((val) {
      if (val != null && !val.preferredEntities.contains(entity)) {
        val.preferredEntities.add(entity);
      }
    });
    _savePreferences();
  }

  void removePreferredEntity(String entity) {
    rxPreferences.update((val) {
      if (val != null) {
        val.preferredEntities.remove(entity);
      }
    });
    _savePreferences();
  }

  void toggleMuteSource(String source) {
    rxPreferences.update((val) {
      if (val != null) {
        if (val.mutedSources.contains(source)) {
          val.mutedSources.remove(source);
        } else {
          val.mutedSources.add(source);
          val.favoriteSources.remove(source);
        }
      }
    });
    _savePreferences();
  }

  void toggleFavoriteSource(String source) {
    rxPreferences.update((val) {
      if (val != null) {
        if (val.favoriteSources.contains(source)) {
          val.favoriteSources.remove(source);
        } else {
          val.favoriteSources.add(source);
          val.mutedSources.remove(source);
        }
      }
    });
    _savePreferences();
  }

  void updateBiasFilterMode(String? value) {
    if (value == null) return;
    rxPreferences.update((val) {
      if (val != null) val.biasFilterMode = value;
    });
    _savePreferences();
  }

  void updateDefaultViewMode(String? value) {
    if (value == null) return;
    rxPreferences.update((val) {
      if (val != null) val.defaultViewMode = value;
    });
    _savePreferences();
  }

  void updateShowNewsTicker(bool value) {
    rxPreferences.update((val) {
      if (val != null) val.showNewsTicker = value;
    });
    _savePreferences();
  }

  void addTickerTopic(String topic) {
    if (topic.trim().isEmpty) return;
    rxPreferences.update((val) {
      if (val != null && !val.newsTickerTopics.contains(topic)) {
        val.newsTickerTopics.add(topic);
      }
    });
    _savePreferences();
  }

  void removeTickerTopic(String topic) {
    rxPreferences.update((val) {
      if (val != null) {
        val.newsTickerTopics.remove(topic);
      }
    });
    _savePreferences();
  }

  void updateSummaryLength(String? value) {
    if (value == null) return;
    rxPreferences.update((val) {
      if (val != null) val.summaryLength = value;
    });
    _savePreferences();
  }

  void toggleTheme(bool isDark) {
    rxPreferences.update((val) {
      if (val != null) val.isDarkMode = isDark;
    });
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    _savePreferences();
  }

  void updateFontSize(double size) {
    rxPreferences.update((val) {
      if (val != null) val.fontSize = size;
    });
    _savePreferences();
  }

  void _savePreferences() {
    final _ = rxPreferences.value.toJson();
  }
}

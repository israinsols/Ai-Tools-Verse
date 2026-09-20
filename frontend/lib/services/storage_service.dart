import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _bookmarksBox = 'bookmarks';
  static const String _recentSearchesBox = 'recent_searches';
  static const String _settingsBox = 'settings';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  List<String> getBookmarks() {
    final box = Hive.box(_bookmarksBox);
    final raw = box.get('ids', defaultValue: <String>[]);
    return List<String>.from(raw);
  }

  Future<void> addBookmark(String toolId) async {
    final box = Hive.box(_bookmarksBox);
    final ids = getBookmarks();
    if (!ids.contains(toolId)) {
      ids.add(toolId);
      await box.put('ids', ids);
    }
  }

  Future<void> removeBookmark(String toolId) async {
    final box = Hive.box(_bookmarksBox);
    final ids = getBookmarks();
    ids.remove(toolId);
    await box.put('ids', ids);
  }

  bool isBookmarked(String toolId) {
    return getBookmarks().contains(toolId);
  }

  List<String> getRecentSearches() {
    final box = Hive.box(_recentSearchesBox);
    final raw = box.get('queries', defaultValue: <String>[]);
    return List<String>.from(raw);
  }

  Future<void> addRecentSearch(String query) async {
    final box = Hive.box(_recentSearchesBox);
    final searches = getRecentSearches();
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 10) searches.removeLast();
    await box.put('queries', searches);
  }

  Future<void> clearRecentSearches() async {
    final box = Hive.box(_recentSearchesBox);
    await box.put('queries', <String>[]);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setSetting<T>(String key, T value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  Future<void> clearAll() async {
    await Hive.box(_bookmarksBox).clear();
    await Hive.box(_recentSearchesBox).clear();
    await Hive.box(_settingsBox).clear();
  }
}

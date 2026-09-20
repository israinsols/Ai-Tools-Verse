import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// Services
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Tools providers
final toolsProvider = FutureProvider<List<Tool>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getTools();
});

final trendingToolsProvider = FutureProvider<List<Tool>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getTrendingTools();
});

final featuredToolsProvider = FutureProvider<List<Tool>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getFeaturedTools();
});

final toolByIdProvider = FutureProvider.family<Tool, String>((ref, id) async {
  final api = ref.watch(apiServiceProvider);
  return api.getToolById(id);
});

// Categories providers
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getCategories();
});

final categoryToolsProvider = FutureProvider.family<List<Tool>, String>((ref, categoryId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getToolsByCategory(categoryId);
});

// Search provider with debounce
final searchQueryProvider = StateProvider<String>((ref) => '');

final debouncedSearchQueryProvider = StateProvider<String>((ref) => '');

class _SearchDebouncer {
  Timer? _timer;
  void run(void Function(String) action, String query) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () => action(query));
  }
  void dispose() => _timer?.cancel();
}

final _searchDebouncer = _SearchDebouncer();

final searchResultsProvider = FutureProvider<List<Tool>>((ref) async {
  final query = ref.watch(debouncedSearchQueryProvider);
  if (query.isEmpty) return [];
  final api = ref.watch(apiServiceProvider);
  return api.searchTools(query);
});

final searchDebounceProvider = Provider<void>((ref) {
  ref.listen<String>(searchQueryProvider, (prev, next) {
    _searchDebouncer.run((q) {
      ref.read(debouncedSearchQueryProvider.notifier).state = q;
    }, next);
  });
});

// Auth state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? role;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.userId,
    this.email,
    this.displayName,
    this.role,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? userId,
    String? email,
    String? displayName,
    String? role,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState()) {
    _loadToken();
  }

  void _loadToken() {
    final storage = _ref.read(storageServiceProvider);
    final token = storage.getSetting<String>('auth_token');
    if (token != null) {
      final userId = storage.getSetting<String>('user_id');
      final email = storage.getSetting<String>('user_email');
      final displayName = storage.getSetting<String>('user_display_name');
      final role = storage.getSetting<String>('user_role');

      _ref.read(apiServiceProvider).setAuthToken(token);

      state = AuthState(
        isAuthenticated: true,
        token: token,
        userId: userId,
        email: email,
        displayName: displayName,
        role: role,
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final api = _ref.read(apiServiceProvider);
    final result = await api.signIn(email: email, password: password);

    final token = result['token'] as String;
    final userId = result['id'] as String;
    final displayName = result['displayName'] as String?;
    final role = result['role'] as String?;

    api.setAuthToken(token);

    final storage = _ref.read(storageServiceProvider);
    await storage.setSetting('auth_token', token);
    await storage.setSetting('user_id', userId);
    await storage.setSetting('user_email', email);
    await storage.setSetting('user_display_name', displayName);
    await storage.setSetting('user_role', role);

    state = AuthState(
      isAuthenticated: true,
      token: token,
      userId: userId,
      email: email,
      displayName: displayName,
      role: role,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final api = _ref.read(apiServiceProvider);
    final result = await api.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );

    final token = result['token'] as String;
    final userId = result['id'] as String;
    final userDisplayName = result['displayName'] as String?;
    final role = result['role'] as String?;

    api.setAuthToken(token);

    final storage = _ref.read(storageServiceProvider);
    await storage.setSetting('auth_token', token);
    await storage.setSetting('user_id', userId);
    await storage.setSetting('user_email', email);
    await storage.setSetting('user_display_name', userDisplayName);
    await storage.setSetting('user_role', role);

    state = AuthState(
      isAuthenticated: true,
      token: token,
      userId: userId,
      email: email,
      displayName: userDisplayName,
      role: role,
    );
  }

  Future<void> signOut() async {
    final api = _ref.read(apiServiceProvider);
    await api.signOut();
    api.setAuthToken(null);

    final storage = _ref.read(storageServiceProvider);
    await storage.setSetting('auth_token', null);
    await storage.setSetting('user_id', null);
    await storage.setSetting('user_email', null);
    await storage.setSetting('user_display_name', null);
    await storage.setSetting('user_role', null);
    await storage.setSetting('remember_me', false);
    await storage.setSetting('remembered_email', null);
    await storage.setSetting('remembered_password', null);

    state = AuthState();
  }
}

// Bookmarks provider
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, List<String>>((ref) {
  return BookmarksNotifier(ref);
});

class BookmarksNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  BookmarksNotifier(this._ref) : super([]) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    final storage = _ref.read(storageServiceProvider);
    state = storage.getBookmarks();
  }

  void toggleBookmark(String toolId) {
    final storage = _ref.read(storageServiceProvider);
    if (state.contains(toolId)) {
      storage.removeBookmark(toolId);
      state = state.where((id) => id != toolId).toList();
    } else {
      storage.addBookmark(toolId);
      state = [...state, toolId];
    }
  }

  bool isBookmarked(String toolId) {
    return state.contains(toolId);
  }
}

// Recent searches provider
final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier(ref);
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  RecentSearchesNotifier(this._ref) : super([]) {
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    final storage = _ref.read(storageServiceProvider);
    state = storage.getRecentSearches();
  }

  void addSearch(String query) {
    final storage = _ref.read(storageServiceProvider);
    storage.addRecentSearch(query);
    state = storage.getRecentSearches();
  }

  void clearSearches() {
    final storage = _ref.read(storageServiceProvider);
    storage.clearRecentSearches();
    state = [];
  }
}

// Filter state
final selectedFilterProvider = StateProvider<String>((ref) => 'all');

// Reviews provider
final reviewsProvider = FutureProvider.family<List<dynamic>, String>((ref, toolId) async {
  final api = ref.watch(apiServiceProvider);
  return api.getReviews(toolId);
});

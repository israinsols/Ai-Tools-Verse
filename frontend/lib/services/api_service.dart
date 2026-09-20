import 'package:dio/dio.dart';
import '../models/models.dart';
import 'mock_data_service.dart';

class ApiService {
  static const String _baseUrl = bool.fromEnvironment('dart.vm.product')
      ? 'https://aiverse-api.onrender.com/v1'
      : 'http://192.168.18.14:3000/v1';

  late final Dio _dio;
  final MockDataService _mock = MockDataService();
  String? _authToken;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  void setAuthToken(String? token) {
    _authToken = token;
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  String? get authToken => _authToken;

  // Tools
  Future<List<Tool>> getTools({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
  }) async {
    try {
      final response = await _dio.get('/tools', queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (search != null) 'search': search,
        if (sortBy != null) 'sortBy': sortBy,
      });
      return (response.data['data'] as List)
          .map((json) => Tool.fromJson(json))
          .toList();
    } catch (_) {
      return _mock.getTools();
    }
  }

  Future<Tool> getToolById(String id) async {
    try {
      final response = await _dio.get('/tools/$id');
      return Tool.fromJson(response.data['data']);
    } catch (_) {
      final tool = _mock.getToolById(id);
      if (tool != null) return tool;
      throw Exception('Tool not found');
    }
  }

  Future<List<Tool>> getTrendingTools() async {
    try {
      final response = await _dio.get('/tools/trending');
      return (response.data['data'] as List)
          .map((json) => Tool.fromJson(json))
          .toList();
    } catch (_) {
      return _mock.getTrendingTools();
    }
  }

  Future<List<Tool>> getFeaturedTools() async {
    try {
      final response = await _dio.get('/tools/featured');
      return (response.data['data'] as List)
          .map((json) => Tool.fromJson(json))
          .toList();
    } catch (_) {
      return _mock.getFeaturedTools();
    }
  }

  Future<List<Tool>> getNewTools() async {
    try {
      final response = await _dio.get('/tools/new');
      return (response.data['data'] as List)
          .map((json) => Tool.fromJson(json))
          .toList();
    } catch (_) {
      return _mock.getNewTools();
    }
  }

  // Categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      return (response.data['data'] as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } catch (_) {
      return _mock.getCategories();
    }
  }

  Future<List<Tool>> getToolsByCategory(String categoryId) async {
    try {
      final response = await _dio.get('/categories/$categoryId/tools');
      return (response.data['data'] as List)
          .map((json) => Tool.fromJson(json))
          .toList();
    } catch (_) {
      return _mock.getToolsByCategory(categoryId);
    }
  }

  // Search
  Future<List<Tool>> searchTools(String query) async {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return _mock.getTools().where((t) {
      return t.name.toLowerCase().contains(q);
    }).toList();
  }

  // Auth
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/signin', data: {
        'email': email,
        'password': password,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _dio.post('/auth/signup', data: {
        'email': email,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _dio.post('/auth/signout');
    } catch (e) {
      // Ignore signout errors
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Bookmarks
  Future<List<String>> getBookmarks() async {
    try {
      final response = await _dio.get('/bookmarks');
      return List<String>.from(response.data['data']);
    } catch (_) {
      return [];
    }
  }

  Future<List<String>> addBookmark(String toolId) async {
    try {
      final response = await _dio.post('/bookmarks/$toolId');
      return List<String>.from(response.data['data']);
    } catch (_) {
      return [];
    }
  }

  Future<List<String>> removeBookmark(String toolId) async {
    try {
      final response = await _dio.delete('/bookmarks/$toolId');
      return List<String>.from(response.data['data']);
    } catch (_) {
      return [];
    }
  }

  // Reviews
  Future<List<dynamic>> getReviews(String toolId) async {
    try {
      final response = await _dio.get('/reviews/$toolId');
      return response.data['data'];
    } catch (_) {
      return [];
    }
  }

  Future<void> addReview(String toolId, Map<String, dynamic> review) async {
    try {
      await _dio.post('/reviews/$toolId', data: review);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  // Submit tool
  Future<void> submitTool(Map<String, dynamic> toolData) async {
    try {
      await _dio.post('/tools/submit', data: toolData);
    } catch (e) {
      throw Exception('Failed to submit tool: $e');
    }
  }

  // Upload image
  Future<String> uploadImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post('/upload', data: formData);
      return response.data['data']['url'];
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Admin - Pending tools
  Future<List<Tool>> getPendingTools() async {
    try {
      final response = await _dio.get('/tools/pending');
      final list = response.data['data'] as List;
      return list
          .map((json) => Tool.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('getPendingTools error: $e');
      return [];
    }
  }

  // Admin - Rejected tools
  Future<List<Tool>> getRejectedTools() async {
    try {
      final response = await _dio.get('/tools/rejected');
      final list = response.data['data'] as List;
      return list
          .map((json) => Tool.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('getRejectedTools error: $e');
      return [];
    }
  }

  // Admin - Stats
  Future<Map<String, dynamic>> getToolStats() async {
    try {
      final response = await _dio.get('/tools/stats');
      return response.data['data'];
    } catch (_) {
      return {'total': 0, 'approved': 0, 'pending': 0, 'rejected': 0};
    }
  }

  // Admin - Approve tool
  Future<void> approveTool(String toolId) async {
    try {
      await _dio.put('/tools/$toolId/approve');
    } catch (e) {
      throw Exception('Failed to approve tool: $e');
    }
  }

  // Admin - Reject tool
  Future<void> rejectTool(String toolId) async {
    try {
      await _dio.put('/tools/$toolId/reject');
    } catch (e) {
      throw Exception('Failed to reject tool: $e');
    }
  }

  // Notifications
  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications');
      final list = response.data['data'] as List;
      return list
          .map((json) => AppNotification.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await _dio.put('/notifications/$id/read');
    } catch (_) {}
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await _dio.put('/notifications/read-all');
    } catch (_) {}
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _dio.delete('/notifications/$id');
    } catch (_) {}
  }
}

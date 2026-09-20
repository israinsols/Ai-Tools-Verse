import 'package:flutter_test/flutter_test.dart';
import 'package:ai_tools_verse/services/mock_data_service.dart';

void main() {
  late MockDataService service;

  setUp(() {
    service = MockDataService();
  });

  group('MockDataService', () {
    test('getTools returns 17 tools', () {
      final tools = service.getTools();
      expect(tools.length, 17);
    });

    test('getTrendingTools returns only trending tools', () {
      final trending = service.getTrendingTools();
      expect(trending.isNotEmpty, true);
      for (final tool in trending) {
        expect(tool.isTrending, true);
      }
    });

    test('getFeaturedTools returns only featured tools', () {
      final featured = service.getFeaturedTools();
      expect(featured.isNotEmpty, true);
      for (final tool in featured) {
        expect(tool.isFeatured, true);
      }
    });

    test('getNewTools returns only new tools', () {
      final newTools = service.getNewTools();
      expect(newTools.isNotEmpty, true);
      for (final tool in newTools) {
        expect(tool.isNew, true);
      }
    });

    test('getToolById returns correct tool', () {
      final tool = service.getToolById('1');
      expect(tool, isNotNull);
      expect(tool!.name, 'ChatGPT');
    });

    test('getToolById returns null for unknown id', () {
      final tool = service.getToolById('999');
      expect(tool, isNull);
    });

    test('getCategories returns 9 categories', () {
      final cats = service.getCategories();
      expect(cats.length, 9);
    });

    test('getToolsByCategory returns matching tools', () {
      final tools = service.getToolsByCategory('1');
      for (final tool in tools) {
        expect(tool.categoryId, '1');
      }
    });

    test('searchTools by name', () {
      final results = service.searchTools('ChatGPT');
      expect(results.length, 1);
      expect(results[0].name, 'ChatGPT');
    });

    test('searchTools by name partial match', () {
      final results = service.searchTools('chat');
      expect(results.isNotEmpty, true);
      for (final tool in results) {
        expect(
          tool.name.toLowerCase().contains('chat'),
          true,
        );
      }
    });

    test('searchTools case insensitive', () {
      final results = service.searchTools('chatgpt');
      expect(results.length, 1);
    });

    test('searchTools returns empty for no match', () {
      final results = service.searchTools('xyznonexistent');
      expect(results, isEmpty);
    });

    test('searchTools returns empty for empty query', () {
      final results = service.searchTools('');
      expect(results, isEmpty);
    });
  });
}

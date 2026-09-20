import 'package:flutter_test/flutter_test.dart';
import 'package:ai_tools_verse/models/tool.dart';

void main() {
  group('Tool Model', () {
    test('fromJson parses valid JSON', () {
      final json = {
        'id': '1',
        'name': 'TestTool',
        'description': 'A test tool',
        'websiteUrl': 'https://test.com',
        'logoUrl': null,
        'categoryId': 'cat1',
        'tags': ['test', 'demo'],
        'pricingType': 'freemium',
        'rating': 4.5,
        'viewCount': 1000,
        'isVerified': true,
        'isFeatured': false,
        'isTrending': true,
        'isNew': false,
        'createdAt': '2024-01-01T00:00:00.000',
        'updatedAt': '2024-06-01T00:00:00.000',
      };

      final tool = Tool.fromJson(json);

      expect(tool.id, '1');
      expect(tool.name, 'TestTool');
      expect(tool.description, 'A test tool');
      expect(tool.websiteUrl, 'https://test.com');
      expect(tool.logoUrl, isNull);
      expect(tool.categoryId, 'cat1');
      expect(tool.tags, ['test', 'demo']);
      expect(tool.pricingType, PricingType.freemium);
      expect(tool.rating, 4.5);
      expect(tool.viewCount, 1000);
      expect(tool.isVerified, true);
      expect(tool.isFeatured, false);
      expect(tool.isTrending, true);
      expect(tool.isNew, false);
    });

    test('fromJson handles missing optional fields with defaults', () {
      final json = {
        'id': '2',
        'name': 'Minimal',
        'description': 'Minimal tool',
        'websiteUrl': 'https://min.com',
        'categoryId': 'cat1',
        'createdAt': '2024-01-01T00:00:00.000',
        'updatedAt': '2024-06-01T00:00:00.000',
      };

      final tool = Tool.fromJson(json);

      expect(tool.tags, isEmpty);
      expect(tool.pricingType, PricingType.free);
      expect(tool.rating, 0.0);
      expect(tool.viewCount, 0);
      expect(tool.isVerified, false);
      expect(tool.isFeatured, false);
      expect(tool.isTrending, false);
      expect(tool.isNew, false);
      expect(tool.logoUrl, isNull);
    });

    test('toJson serializes correctly', () {
      final tool = Tool(
        id: '1',
        name: 'Test',
        description: 'Desc',
        websiteUrl: 'https://test.com',
        categoryId: 'c1',
        tags: ['a'],
        pricingType: PricingType.paid,
        rating: 4.0,
        viewCount: 500,
        isVerified: true,
        isFeatured: true,
        isTrending: false,
        isNew: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 6, 1),
      );

      final json = tool.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test');
      expect(json['pricingType'], 'paid');
      expect(json['isVerified'], true);
      expect(json['isNew'], true);
      expect(json['createdAt'], isA<String>());
    });

    test('roundtrip fromJson -> toJson preserves data', () {
      final original = {
        'id': '5',
        'name': 'Roundtrip',
        'description': 'Test roundtrip',
        'websiteUrl': 'https://rt.com',
        'logoUrl': 'https://logo.png',
        'categoryId': 'c2',
        'tags': ['x', 'y'],
        'pricingType': 'free',
        'rating': 3.7,
        'viewCount': 999,
        'isVerified': false,
        'isFeatured': true,
        'isTrending': false,
        'isNew': true,
        'createdAt': '2024-03-15T10:30:00.000',
        'updatedAt': '2024-07-01T12:00:00.000',
      };

      final tool = Tool.fromJson(original);
      final serialized = tool.toJson();

      expect(serialized['id'], original['id']);
      expect(serialized['name'], original['name']);
      expect(serialized['tags'], original['tags']);
      expect(serialized['pricingType'], original['pricingType']);
      expect(serialized['isNew'], original['isNew']);
    });

    test('copyWith creates modified copy', () {
      final tool = Tool(
        id: '1',
        name: 'Original',
        description: 'Desc',
        websiteUrl: 'https://test.com',
        categoryId: 'c1',
        pricingType: PricingType.free,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 6, 1),
      );

      final copy = tool.copyWith(name: 'Modified', rating: 4.5);

      expect(copy.name, 'Modified');
      expect(copy.rating, 4.5);
      expect(copy.id, '1');
      expect(copy.description, 'Desc');
    });
  });

  group('PricingType', () {
    test('from name string matches enum', () {
      expect(PricingType.values.firstWhere((e) => e.name == 'free'), PricingType.free);
      expect(PricingType.values.firstWhere((e) => e.name == 'freemium'), PricingType.freemium);
      expect(PricingType.values.firstWhere((e) => e.name == 'paid'), PricingType.paid);
    });
  });
}

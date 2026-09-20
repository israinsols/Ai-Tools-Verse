import 'package:flutter_test/flutter_test.dart';
import 'package:ai_tools_verse/models/tool.dart';

void main() {
  test('Tool model basic creation', () {
    final tool = Tool(
      id: '1',
      name: 'Test',
      description: 'Desc',
      websiteUrl: 'https://test.com',
      categoryId: 'c1',
      pricingType: PricingType.free,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 1),
    );

    expect(tool.id, '1');
    expect(tool.name, 'Test');
    expect(tool.isNew, false);
    expect(tool.tags, isEmpty);
  });
}

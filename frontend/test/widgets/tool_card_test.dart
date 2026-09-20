import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_tools_verse/models/tool.dart';
import 'package:ai_tools_verse/widgets/tool_card.dart';

Tool _createTestTool({
  String name = 'TestTool',
  PricingType pricing = PricingType.freemium,
  double rating = 4.5,
}) {
  return Tool(
    id: '1',
    name: name,
    description: 'A test tool description',
    websiteUrl: 'https://test.com',
    categoryId: 'c1',
    tags: ['test', 'demo'],
    pricingType: pricing,
    rating: rating,
    viewCount: 1000,
    isVerified: true,
    isFeatured: false,
    isTrending: false,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 6, 1),
  );
}

void main() {
  group('ToolCard Widget', () {
    testWidgets('renders tool name', (tester) async {
      final tool = _createTestTool(name: 'MyTool');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('MyTool'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      final tool = _createTestTool();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('A test tool description'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows pricing badge for Freemium', (tester) async {
      final tool = _createTestTool(pricing: PricingType.freemium);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('Freemium'), findsOneWidget);
    });

    testWidgets('shows pricing badge for Paid', (tester) async {
      final tool = _createTestTool(pricing: PricingType.paid);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('Paid'), findsOneWidget);
    });

    testWidgets('shows pricing badge for Free', (tester) async {
      final tool = _createTestTool(pricing: PricingType.free);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('Free'), findsOneWidget);
    });

    testWidgets('shows rating', (tester) async {
      final tool = _createTestTool(rating: 4.7);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('4.7'), findsOneWidget);
    });

    testWidgets('shows tags', (tester) async {
      final tool = _createTestTool();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(tool: tool),
          ),
        ),
      );

      expect(find.text('#test'), findsOneWidget);
      expect(find.text('#demo'), findsOneWidget);
    });

    testWidgets('onTap callback fires', (tester) async {
      bool tapped = false;
      final tool = _createTestTool();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolCard(
              tool: tool,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ToolCard));
      expect(tapped, true);
    });
  });
}

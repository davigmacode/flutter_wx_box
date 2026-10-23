import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_border.dart';

void main() {
  group('WxBorder widget', () {
    testWidgets('renders child properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBorder(
              shape: RoundedRectangleBorder(),
              child: Text('Border Child'),
            ),
          ),
        ),
      );

      expect(find.text('Border Child'), findsOneWidget);
    });

    testWidgets('foreground border paints via CustomPaint foregroundPainter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBorder(
              isBackground: false,
              shape: RoundedRectangleBorder(),
              child: SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      final customPaintFinder = find.descendant(
        of: find.byType(WxBorder),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(customPaintFinder);
      expect(customPaint.painter, isNull);
      expect(customPaint.foregroundPainter, isNotNull);
    });

    testWidgets('background border paints via CustomPaint painter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBorder(
              isBackground: true,
              shape: RoundedRectangleBorder(),
              child: SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      final customPaintFinder = find.descendant(
        of: find.byType(WxBorder),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(customPaintFinder);
      expect(customPaint.painter, isNotNull);
      expect(customPaint.foregroundPainter, isNull);
    });

    testWidgets('applies clipping when clipBehavior != Clip.none', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBorder(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(),
              child: SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      expect(find.byType(ClipPath), findsOneWidget);
    });
  });

  group('WxBorderPainter', () {
    test('shouldRepaint returns true only when shape changes', () {
      final painter1 = WxBorderPainter(const RoundedRectangleBorder(), TextDirection.ltr);
      final painter2 = WxBorderPainter(const RoundedRectangleBorder(), TextDirection.ltr);
      final painter3 = WxBorderPainter(const CircleBorder(), TextDirection.ltr);

      expect(painter1.shouldRepaint(painter2), isFalse);
      expect(painter1.shouldRepaint(painter3), isTrue);
    });
  });
}

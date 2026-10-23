import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_box.dart';

void main() {
  group('WxAnimatedBox', () {
    testWidgets('animates width and height changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxAnimatedBox(
              duration: Duration(milliseconds: 300),
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Text('Animated Box'),
            ),
          ),
        ),
      );

      var size = tester.getSize(find.byType(WxBox));
      expect(size.width, 100);
      expect(size.height, 100);

      // Rebuild with new dimensions
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxAnimatedBox(
              duration: Duration(milliseconds: 300),
              width: 200,
              height: 200,
              color: Colors.red,
              child: Text('Animated Box'),
            ),
          ),
        ),
      );

      // Halfway through animation
      await tester.pump(const Duration(milliseconds: 150));
      size = tester.getSize(find.byType(WxBox));
      expect(size.width, greaterThan(100));
      expect(size.width, lessThan(200));

      // End of animation
      await tester.pumpAndSettle();
      size = tester.getSize(find.byType(WxBox));
      expect(size.width, 200);
      expect(size.height, 200);
    });

    testWidgets('WxAnimatedBox named constructors render properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: Column(
              children: [
                WxAnimatedBox.square(
                  size: 60,
                  child: Text('Square'),
                ),
                WxAnimatedBox.rectangle(
                  width: 80,
                  height: 40,
                  child: Text('Rect'),
                ),
                WxAnimatedBox.circle(
                  radius: 30,
                  child: Text('Circle'),
                ),
                WxAnimatedBox.stadium(
                  width: 100,
                  height: 40,
                  child: Text('Stadium'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Square'), findsOneWidget);
      expect(find.text('Rect'), findsOneWidget);
      expect(find.text('Circle'), findsOneWidget);
      expect(find.text('Stadium'), findsOneWidget);
    });
  });
}

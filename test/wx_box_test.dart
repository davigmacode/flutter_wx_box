import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_box.dart';

void main() {
  group('WxBox Widget', () {
    testWidgets('renders child and default properties', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(
              width: 100,
              height: 50,
              child: Text('Hello WxBox'),
            ),
          ),
        ),
      );

      expect(find.text('Hello WxBox'), findsOneWidget);
      final size = tester.getSize(find.byType(WxBox));
      expect(size.width, 100);
      expect(size.height, 50);
    });

    testWidgets('WxBox.square constructor sets equal width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox.square(
              size: 80,
              child: Text('Square'),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(WxBox));
      expect(size.width, 80);
      expect(size.height, 80);
    });

    testWidgets('WxBox.circle constructor sets diameter from radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox.circle(
              radius: 30,
              child: Text('Circle'),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(WxBox));
      expect(size.width, 60);
      expect(size.height, 60);
    });

    testWidgets('WxBox.rectangle and WxBox.stadium constructors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: Column(
              children: [
                WxBox.rectangle(
                  width: 120,
                  height: 40,
                  child: Text('Rectangle'),
                ),
                WxBox.stadium(
                  width: 150,
                  height: 50,
                  child: Text('Stadium'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Rectangle'), findsOneWidget);
      expect(find.text('Stadium'), findsOneWidget);
    });

    testWidgets('applies padding and margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(15),
              child: Text('Spaced'),
            ),
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
      expect(find.text('Spaced'), findsOneWidget);
    });

    testWidgets('applies alignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(
              width: 100,
              height: 100,
              alignment: Alignment.bottomRight,
              child: Text('Aligned'),
            ),
          ),
        ),
      );

      expect(find.byType(Align), findsOneWidget);
      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.bottomRight);
    });

    testWidgets('applies clipBehavior', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(
              clipBehavior: Clip.antiAlias,
              child: Text('Clipped'),
            ),
          ),
        ),
      );

      expect(find.byType(ClipPath), findsOneWidget);
    });

    testWidgets('renders elevation with RoundedRectangleBorder using PhysicalModel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(
              elevation: 4.0,
              elevationColor: Colors.black,
              child: Text('Elevated Rect'),
            ),
          ),
        ),
      );

      expect(find.byType(PhysicalModel), findsOneWidget);
      final physicalModel = tester.widget<PhysicalModel>(find.byType(PhysicalModel));
      expect(physicalModel.elevation, 4.0);
      expect(physicalModel.shadowColor, Colors.black);
    });

    testWidgets('renders elevation with CircleBorder using PhysicalShape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox.circle(
              radius: 40,
              elevation: 6.0,
              elevationColor: Colors.red,
              child: Text('Elevated Circle'),
            ),
          ),
        ),
      );

      expect(find.byType(PhysicalShape), findsOneWidget);
      final physicalShape = tester.widget<PhysicalShape>(find.byType(PhysicalShape));
      expect(physicalShape.elevation, 6.0);
      expect(physicalShape.shadowColor, Colors.red);
    });

    testWidgets('renders without child using LimitedBox when constraints unbounded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(),
          ),
        ),
      );

      expect(find.byType(LimitedBox), findsOneWidget);
    });

    testWidgets('renders gradient, shadows, and borders in DecoratedBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: WxBox(
              gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
              shadows: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              borderColor: Colors.green,
              borderWidth: 2,
              borderStyle: BorderStyle.solid,
              borderOffset: BorderSide.strokeAlignInside,
              child: Text('Decorated'),
            ),
          ),
        ),
      );

      expect(find.byType(DecoratedBox), findsOneWidget);
      final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = decoratedBox.decoration as ShapeDecoration;
      expect(decoration.gradient, isNotNull);
      expect(decoration.shadows, isNotNull);
    });

    test('debugFillProperties on WxBox', () {
      const box = WxBox(
        width: 100,
        height: 80,
        color: Colors.amber,
        elevation: 2.0,
      );
      final builder = DiagnosticPropertiesBuilder();
      box.debugFillProperties(builder);

      final descriptions = builder.properties.map((p) => p.name).toList();
      expect(descriptions, contains('width'));
      expect(descriptions, contains('height'));
      expect(descriptions, contains('color'));
      expect(descriptions, contains('elevation'));
    });
  });
}

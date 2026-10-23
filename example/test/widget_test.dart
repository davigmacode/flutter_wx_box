import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_box.dart';
import 'package:wx_box_example/main.dart';

void main() {
  testWidgets('WxBox example app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(WxBox), findsWidgets);
    expect(find.text('Rectangle Shape'), findsOneWidget);
  });
}

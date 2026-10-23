import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_border.dart';
import 'package:wx_box/wx_shape.dart';

void main() {
  group('createShapeBorder', () {
    test('returns default RoundedRectangleBorder when borderShape is null', () {
      final shape = createShapeBorder();
      expect(shape, isA<RoundedRectangleBorder>());
    });

    test('configures OutlinedBorder properties', () {
      final base = const RoundedRectangleBorder();
      final shape = createShapeBorder(
        borderShape: base,
        borderColor: Colors.red,
        borderWidth: 2.0,
        borderStyle: BorderStyle.solid,
        borderOffset: 1.0,
        borderRadius: BorderRadius.circular(8.0),
      );

      expect(shape, isA<RoundedRectangleBorder>());
      final rounded = shape as RoundedRectangleBorder;
      expect(rounded.side.color, Colors.red);
      expect(rounded.side.width, 2.0);
      expect(rounded.side.style, BorderStyle.solid);
      expect(rounded.side.strokeAlign, 1.0);
      expect(rounded.borderRadius, BorderRadius.circular(8.0));
    });

    test('overrides OutlinedBorder side with borderSide', () {
      const customSide = BorderSide(
        color: Colors.green,
        width: 3.0,
        style: BorderStyle.solid,
        strokeAlign: -1.0,
      );

      final shape = createShapeBorder(
        borderShape: const StadiumBorder(),
        borderSide: customSide,
      );

      expect(shape, isA<StadiumBorder>());
      final stadium = shape as StadiumBorder;
      expect(stadium.side.color, Colors.green);
      expect(stadium.side.width, 3.0);
      expect(stadium.side.strokeAlign, -1.0);
    });

    test('configures WxOutlinedBorder properties', () {
      final base = const WxRectangleBorder();
      final shape = createShapeBorder(
        borderShape: base,
        borderColor: Colors.blue,
        borderWidth: 4.0,
        borderOffset: 0.5,
        borderRadius: BorderRadius.circular(10.0),
      );

      expect(shape, isA<WxRectangleBorder>());
      final rect = shape as WxRectangleBorder;
      expect(rect.color, Colors.blue);
      expect(rect.width, 4.0);
      expect(rect.offset, 0.5);
      expect(rect.corners, BorderRadius.circular(10.0));
    });

    test('configures WxOutlinedBorder with borderSide fallback', () {
      const customSide = BorderSide(
        color: Colors.purple,
        width: 2.5,
        strokeAlign: 0.2,
      );

      final shape = createShapeBorder(
        borderShape: const WxRectangleBorder(),
        borderSide: customSide,
      );

      expect(shape, isA<WxRectangleBorder>());
      final rect = shape as WxRectangleBorder;
      expect(rect.color, Colors.purple);
      expect(rect.width, 2.5);
      expect(rect.offset, 0.2);
    });

    test('configures BeveledRectangleBorder and ContinuousRectangleBorder borderRadius', () {
      final beveled = createShapeBorder(
        borderShape: const BeveledRectangleBorder(),
        borderRadius: BorderRadius.circular(6.0),
      ) as BeveledRectangleBorder;
      expect(beveled.borderRadius, BorderRadius.circular(6.0));

      final continuous = createShapeBorder(
        borderShape: const ContinuousRectangleBorder(),
        borderRadius: BorderRadius.circular(12.0),
      ) as ContinuousRectangleBorder;
      expect(continuous.borderRadius, BorderRadius.circular(12.0));
    });
  });
}

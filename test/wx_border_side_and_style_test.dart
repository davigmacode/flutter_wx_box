import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_border.dart';

void main() {
  group('WxBorderStyle', () {
    test('constants and solid / non-solid checks', () {
      expect(WxBorderStyle.solid.isSolid, isTrue);
      expect(WxBorderStyle.solid.isNonSolid, isFalse);

      expect(WxBorderStyle.dotted.isSolid, isFalse);
      expect(WxBorderStyle.dotted.isNonSolid, isTrue);

      expect(WxBorderStyle.dashed.isNonSolid, isTrue);
      expect(WxBorderStyle.morse.isNonSolid, isTrue);
    });

    test('equality and hashCode', () {
      const style1 = WxBorderStyle([2, 2], absolute: true);
      const style2 = WxBorderStyle([2, 2], absolute: true);
      const style3 = WxBorderStyle([2, 2], absolute: false);

      expect(style1, equals(style2));
      expect(style1.hashCode, equals(style2.hashCode));
      expect(style1, isNot(equals(style3)));
    });

    test('lerp between styles', () {
      expect(WxBorderStyle.lerp(null, WxBorderStyle.solid, 0.5), WxBorderStyle.solid);
      expect(WxBorderStyle.lerp(WxBorderStyle.solid, null, 0.5), WxBorderStyle.solid);

      const a = WxBorderStyle([2, 2]);
      const b = WxBorderStyle([4, 4]);
      final result = WxBorderStyle.lerp(a, b, 0.5);
      expect(result, isNotNull);
      expect(result!.pattern, [3.0, 3.0, 3.0, 3.0]);
    });
  });

  group('WxBorderSide', () {
    test('default values', () {
      const side = WxBorderSide();
      expect(side.effectiveColor, const Color(0xFF000000));
      expect(side.effectiveWidth, 1.0);
      expect(side.effectiveStyle, WxBorderStyle.solid);
      expect(side.effectiveOffset, WxBorderSide.alignInside);
      expect(side.strokeInset, 1.0);
      expect(side.strokeOutset, 0.0);
      expect(side.strokeOffset, -1.0);
    });

    test('fromLegacy constructor', () {
      const legacy = BorderSide(
        color: Colors.amber,
        width: 4.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignOutside,
      );
      final side = WxBorderSide.fromLegacy(legacy);
      expect(side.color, Colors.amber);
      expect(side.width, 4.0);
      expect(side.offset, BorderSide.strokeAlignOutside);
    });

    test('fromLegacy with BorderStyle.none has zero width', () {
      const legacy = BorderSide(
        color: Colors.amber,
        width: 4.0,
        style: BorderStyle.none,
      );
      final side = WxBorderSide.fromLegacy(legacy);
      expect(side.width, 0.0);
    });

    test('toLegacy conversion', () {
      const side = WxBorderSide(
        color: Colors.red,
        width: 3.0,
        offset: WxBorderSide.alignCenter,
      );
      final legacy = side.toLegacy();
      expect(legacy.color, Colors.red);
      expect(legacy.width, 3.0);
      expect(legacy.strokeAlign, 0.0);
      expect(legacy.style, BorderStyle.solid);
    });

    test('scale method', () {
      const side = WxBorderSide(width: 4.0);
      final scaled = side.scale(0.5);
      expect(scaled.width, 2.0);

      final zeroScaled = side.scale(-1.0);
      expect(zeroScaled.width, 0.0);
    });

    test('merge method', () {
      const side1 = WxBorderSide(color: Colors.blue, width: 2.0);
      const side2 = WxBorderSide(color: Colors.green, width: 5.0);

      expect(side1.merge(null), side1);
      final merged = side1.merge(side2);
      expect(merged.color, Colors.green);
      expect(merged.width, 5.0);
    });

    test('lerp method', () {
      const side1 = WxBorderSide(color: Colors.black, width: 2.0);
      const side2 = WxBorderSide(color: Colors.white, width: 6.0);

      expect(WxBorderSide.lerp(side1, side1, 0.5), side1);
      expect(WxBorderSide.lerp(side1, side2, 0.0), side1);
      expect(WxBorderSide.lerp(side1, side2, 1.0), side2);

      final mid = WxBorderSide.lerp(side1, side2, 0.5);
      expect(mid?.width, 4.0);
    });

    test('toPaint returns paint with color and gradient shader', () {
      const gradient = LinearGradient(colors: [Colors.black, Colors.white]);
      const side = WxBorderSide(color: Color(0xFF123456), gradient: gradient);
      final paint = side.toPaint(const Rect.fromLTWH(0, 0, 100, 100));
      expect(paint.color.toARGB32(), 0xFF123456);
      expect(paint.shader, isNotNull);
    });

    test('equality and hashCode', () {
      const side1 = WxBorderSide(color: Colors.red, width: 2.0);
      const side2 = WxBorderSide(color: Colors.red, width: 2.0);
      const side3 = WxBorderSide(color: Colors.blue, width: 2.0);

      expect(side1, equals(side2));
      expect(side1.hashCode, equals(side2.hashCode));
      expect(side1, isNot(equals(side3)));
    });
  });
}

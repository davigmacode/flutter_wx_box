import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wx_box/wx_border.dart';
import 'package:wx_box/src/border/shape/rectangle_lerp.dart';
import 'package:wx_box/src/border/shape/stadium_lerp.dart';

void main() {
  const rect = Rect.fromLTWH(0, 0, 100, 100);

  group('WxRectangleBorder', () {
    test('getInnerPath and getOuterPath', () {
      final border = WxRectangleBorder(
        corners: BorderRadius.circular(10),
        width: 2.0,
      );
      final outer = border.getOuterPath(rect, textDirection: TextDirection.ltr);
      final inner = border.getInnerPath(rect, textDirection: TextDirection.ltr);

      expect(outer, isNotNull);
      expect(inner, isNotNull);
    });

    test('paint with solid and non-solid style', () {
      const border = WxRectangleBorder(
        width: 2.0,
        color: Colors.black,
        style: WxBorderStyle.dashed,
      );

      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      border.paint(canvas, rect, textDirection: TextDirection.ltr);
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);
    });

    test('paintInterior with zero and non-zero corners', () {
      const border1 = WxRectangleBorder(corners: BorderRadius.zero);
      final border2 = WxRectangleBorder(corners: BorderRadius.circular(5));

      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final paint = Paint();
      border1.paintInterior(canvas, rect, paint);
      border2.paintInterior(canvas, rect, paint);
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);
    });

    test('lerpFrom and lerpTo with WxRectangleBorder and WxCircleBorder', () {
      const border1 = WxRectangleBorder(width: 2.0);
      const border2 = WxRectangleBorder(width: 4.0);
      const circle = WxCircleBorder(width: 2.0);

      final lerpedRect = border1.lerpTo(border2, 0.5) as WxRectangleBorder?;
      expect(lerpedRect?.width, 3.0);

      final toCircle = border1.lerpTo(circle, 0.5);
      expect(toCircle, isNotNull);

      final fromCircle = border1.lerpFrom(circle, 0.5);
      expect(fromCircle, isNotNull);

      expect(border1.scale(2.0).dimensions, isNotNull);
      expect(border1.toString(), contains('WxRectangleBorder'));
      expect(border1 == border1, isTrue);
      expect(border1 == border2, isFalse);
    });
  });

  group('WxRectangleToCircleBorder', () {
    test('scale, lerp, getPath and paint', () {
      const shape = WxRectangleToCircleBorder(
        circularity: 0.5,
        eccentricity: 0.0,
        side: WxBorderSide(width: 2.0),
      );

      expect(shape.scale(2.0), isNotNull);
      expect(shape.getOuterPath(rect), isNotNull);
      expect(shape.getInnerPath(rect), isNotNull);

      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      shape.paint(canvas, rect, textDirection: TextDirection.ltr);
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);

      const circle = WxCircleBorder(width: 2.0);
      const rectBorder = WxRectangleBorder(width: 2.0);

      expect(shape.lerpFrom(rectBorder, 0.5), isNotNull);
      expect(shape.lerpFrom(circle, 0.5), isNotNull);
      expect(shape.lerpFrom(shape, 0.5), isNotNull);

      expect(shape.lerpTo(rectBorder, 0.5), isNotNull);
      expect(shape.lerpTo(circle, 0.5), isNotNull);
      expect(shape.lerpTo(shape, 0.5), isNotNull);
      expect(shape == shape, isTrue);
    });
  });

  group('WxCircleBorder', () {
    test('getInnerPath and getOuterPath', () {
      const border = WxCircleBorder(width: 2.0);
      final outer = border.getOuterPath(rect, textDirection: TextDirection.ltr);
      final inner = border.getInnerPath(rect, textDirection: TextDirection.ltr);

      expect(outer, isNotNull);
      expect(inner, isNotNull);
    });

    test('paint and paintInterior circle', () {
      const border = WxCircleBorder(width: 2.0, color: Colors.blue);
      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      border.paint(canvas, rect, textDirection: TextDirection.ltr);
      border.paintInterior(canvas, rect, Paint());
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);
    });

    test('scale and lerp', () {
      const circle1 = WxCircleBorder(width: 2.0);
      const circle2 = WxCircleBorder(width: 4.0);
      expect(circle1.scale(2.0).dimensions, isNotNull);
      expect(circle1.lerpTo(circle2, 0.5), isNotNull);
      expect(circle1.lerpFrom(circle2, 0.5), isNotNull);
      expect(circle1 == circle1, isTrue);
    });
  });

  group('WxStadiumBorder', () {
    test('getInnerPath, getOuterPath and paint', () {
      const border = WxStadiumBorder(width: 2.0);
      final outer = border.getOuterPath(rect, textDirection: TextDirection.ltr);
      final inner = border.getInnerPath(rect, textDirection: TextDirection.ltr);

      expect(outer, isNotNull);
      expect(inner, isNotNull);

      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      border.paint(canvas, rect, textDirection: TextDirection.ltr);
      border.paintInterior(canvas, rect, Paint());
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);
    });

    test('lerp to and from circle', () {
      const stadium = WxStadiumBorder(width: 2.0);
      const circle = WxCircleBorder(width: 2.0);
      expect(stadium.lerpTo(circle, 0.5), isNotNull);
      expect(stadium.lerpFrom(circle, 0.5), isNotNull);
      expect(stadium.scale(2.0), isNotNull);
      expect(stadium == stadium, isTrue);
    });
  });

  group('WxStadiumToCircleBorder', () {
    test('scale, lerp, getPath and paint', () {
      const shape = WxStadiumToCircleBorder(
        circularity: 0.5,
        eccentricity: 0.0,
        side: WxBorderSide(width: 2.0),
      );

      expect(shape.scale(2.0), isNotNull);
      expect(shape.getOuterPath(rect), isNotNull);
      expect(shape.getInnerPath(rect), isNotNull);

      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      shape.paint(canvas, rect, textDirection: TextDirection.ltr);
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);

      const circle = WxCircleBorder(width: 2.0);
      const stadium = WxStadiumBorder(width: 2.0);

      expect(shape.lerpFrom(stadium, 0.5), isNotNull);
      expect(shape.lerpFrom(circle, 0.5), isNotNull);
      expect(shape.lerpFrom(shape, 0.5), isNotNull);

      expect(shape.lerpTo(stadium, 0.5), isNotNull);
      expect(shape.lerpTo(circle, 0.5), isNotNull);
      expect(shape.lerpTo(shape, 0.5), isNotNull);
      expect(shape == shape, isTrue);
    });
  });

  group('WxLinearBorder', () {
    test('renders with individual sides', () {
      const border = WxLinearBorder(
        top: WxLinearBorderSide(width: 2.0, color: Colors.red),
        bottom: WxLinearBorderSide(width: 2.0, color: Colors.blue),
      );

      final outer = border.getOuterPath(rect, textDirection: TextDirection.ltr);
      final inner = border.getInnerPath(rect, textDirection: TextDirection.ltr);
      expect(outer, isNotNull);
      expect(inner, isNotNull);

      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      border.paint(canvas, rect, textDirection: TextDirection.ltr);
      final picture = pictureRecorder.endRecording();
      expect(picture, isNotNull);

      expect(border.scale(2.0), isNotNull);
      expect(border.dimensions, isNotNull);
      expect(border == border, isTrue);
    });
  });

  group('WxBeveledRectangleBorder and WxContinuousRectangleBorder', () {
    test('paths, lerp and scaling', () {
      final beveled1 = WxBeveledRectangleBorder(
        corners: BorderRadius.circular(8.0),
        width: 1.0,
      );
      final beveled2 = WxBeveledRectangleBorder(
        corners: BorderRadius.circular(16.0),
        width: 2.0,
      );
      expect(beveled1.getOuterPath(rect), isNotNull);
      expect(beveled1.getInnerPath(rect), isNotNull);
      expect(beveled1.scale(2.0), isA<WxBeveledRectangleBorder>());
      expect(beveled1.lerpTo(beveled2, 0.5), isNotNull);
      expect(beveled1.lerpFrom(beveled2, 0.5), isNotNull);

      final continuous1 = WxContinuousRectangleBorder(
        corners: BorderRadius.circular(8.0),
        width: 1.0,
      );
      final continuous2 = WxContinuousRectangleBorder(
        corners: BorderRadius.circular(16.0),
        width: 2.0,
      );
      expect(continuous1.getOuterPath(rect), isNotNull);
      expect(continuous1.getInnerPath(rect), isNotNull);
      expect(continuous1.scale(2.0), isA<WxContinuousRectangleBorder>());
      expect(continuous1.lerpTo(continuous2, 0.5), isNotNull);
      expect(continuous1.lerpFrom(continuous2, 0.5), isNotNull);
    });
  });
}

// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import '../lib/src/svgpath.dart';
import 'package:test/test.dart';

void main() {
  group('translate', () {
    test('x only', () {
      var path = new SvgPath('M10 10 L15 15')..transform('translate(20)');
      expect(path.toString(), equals('M30 10L35 15'));
    });

    test('x and y', () {
      var path = new SvgPath('M10 10 L15 15')..transform('translate(20,10)');
      expect(path.toString(), equals('M30 20L35 25'));
    });

    test('x and y with space', () {
      var path = new SvgPath('M10 10 L15 15')..transform('translate ( 20, 10)');
      expect(path.toString(), equals('M30 20L35 25'));
    });

    test('x and y with relatives curves', () {
      var path = new SvgPath('M10 10 c15 15, 20 10, 15 15')
        ..transform('translate(20,10)');
      expect(path.toString(), equals('M30 20c15 15 20 10 15 15'));
    });

    test('x and y with absolute curves', () {
      var path = new SvgPath('M10 10 C15 15, 20 10, 15 15')
        ..transform('translate(20,10)');
      expect(path.toString(), equals('M30 20C35 25 40 20 35 25'));
    });

    test(
        'rel after translate sequence should not break translate if first m (#10)',
        () {
      var path = new SvgPath('m70 70 l20 20 l-20 0 l0 -20')
        ..translate(100, 100);
      expect(path.toString(), equals('M170 170l20 20-20 0 0-20'));

      path = new SvgPath('m70 70 l20 20 l-20 0 l0 -20')
        ..translate(100, 100)
        ..rel();
      expect(path.toString(), equals('M170 170l20 20-20 0 0-20'));
    });
  });

  group('rotate', () {
    test('rotate by 90 degrees about point(10, 10)', () {
      var path = new SvgPath('M10 10L15 10')
        ..transform('rotate(90, 10, 10')
        ..round(0);

      expect(path.toString(), equals('M10 10L10 15'));
    });

    test('rotate by -90 degrees about point (0,0)', () {
      var path = new SvgPath('M0 10L0 20')
        ..transform('rotate(-90')
        ..round(0);

      expect(path.toString(), equals('M10 0L20 0'));
    });
  });

  group('scale', () {
    test('scale picture by 2', () {
      var path = new SvgPath('M5 5L15 20')..transform('scale(2)');
      expect(path.toString(), equals('M10 10L30 40'));
    });

    test('scale picture with x*0.5 and y*1.5', () {
      var path = new SvgPath('M5 5L30 20')..transform('scale(.5, 1.5)');
      expect(path.toString(), equals('M2.5 7.5L15 30'));
    });

    test('scale picture with x*0.5 and y*1.5 with relative elements', () {
      var path = new SvgPath('M5 5c15 15, 20 10, 15 15')
        ..transform('scale(.5, 1.5)');
      expect(path.toString(), equals('M2.5 7.5c7.5 22.5 10 15 7.5 22.5'));
    });
  });

  group('skew', () {
    // SkewX matrix [ 1, 0, 4, 1, 0, 0 ],
    // x = x*1 + y*4 + 0 = x + y*4
    // y = x*0 + y*1 + 0 = y
    test('skewX', () {
      expect(
          new SvgPath('M5 5L15 20')
              .transform('skewX(75.96)')
              .round(0)
              .toString(),
          equals('M25 5L95 20'));
    });

    // SkewY matrix [ 1, 4, 0, 1, 0, 0 ],
    // x = x*1 + y*0 + 0 = x
    // y = x*4 + y*1 + 0 = y + x*4
    test('skewY', () {
      expect(
          new SvgPath('M5 5L15 20')
              .transform('skewY(75.96)')
              .round(0)
              .toString(),
          equals('M5 25L15 80'));
    });
  });

  group('matrix', () {
    // x = x*1.5 + y/2 + ( absolute ? 10 : 0)
    // y = x/2 + y*1.5 + ( absolute ? 15 : 0)
    test('path with absolute segments', () {
      expect(
          new SvgPath('M5 5 C20 30 10 15 30 15')
              .transform('matrix(1.5, 0.5, 0.5, 1.5, 10, 15)')
              .toString(),
          equals('M20 25C55 70 32.5 42.5 62.5 52.5'));
    });

    test('path with relative segments', () {
      expect(
          new SvgPath('M5 5 c10 12 10 15 20 30')
              .transform('matrix(1.5, 0.5, 0.5, 1.5, 10, 15)')
              .toString(),
          equals('M20 25c21 23 22.5 27.5 45 55'));
    });
  });

  group('combinations', () {
    test('scale + translate', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .transform('translate(100,100) scale(2,3)')
              .toString(),
          equals('M100 100L120 130 140 130')
      );
    });

    test('scale + rotate', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .transform('rotate(90) scale(2,3)')
              .round(0)
              .toString(),
          equals('M0 0L-30 20-30 40')
      );
    });

    test('skewX + scale', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .transform('skewX(75.96) scale(2,3)')
              .round(0)
              .toString(),
          equals('M0 0L140 30 160 30')
      );
    });
  });

  group('misc', () {
    test('empty transforms', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .transform('rotate(0) scale(1,1) translate(0,0) skewX(0) skewY(0)')
              .round(0)
              .toString(),
          equals('M0 0L10 10 20 10')
      );
    });

    test('wrong params count in transforms', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .transform('rotate(10,0) scale(10,10,1) translate(10,10,0) skewX(10,0) skewY(10,0) matrix(0)')
              .round(0)
              .toString(),
          equals('M0 0L10 10 20 10')
      );
    });

    test('segment replacement [H,V] => L', () {
      expect(
          new SvgPath('M0 0 H 10 V 10 Z M 100 100 h 15 v -10')
              .transform('rotate(45)')
              .round(0)
              .toString(),
          equals('M0 0L7 7 0 14ZM0 141l11 11 7-7')
      );
    });

    test('nothing to transform', () {
      expect(
          new SvgPath('M10 10 L15 15')
              .transform('   ')
              .round(0)
              .toString(),
          equals('M10 10L15 15')
      );
    });

    test('first m should be processed as absolute', () {
      // By default parser force first 'm' to upper case
      // and we don't fall into troubles.
      expect(
          new SvgPath('m70 70 70 70')
              .translate(100, 100)
              .toString(),
          equals('M170 170l70 70')
      );

      // Emulate first 'm'.
      var p = new SvgPath('m70 70 70 70');
      p.segments[0][0] = 'm';
      expect(p.translate(100, 100).toString(), equals('m170 170l70 70'));
    });
  });
}

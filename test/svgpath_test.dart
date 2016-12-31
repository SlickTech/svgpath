// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'package:svgpath/svgpath.dart';
import 'package:test/test.dart';

void main() {
  group('toString', () {
    test('should not collapse multiple M', () {
      expect(new SvgPath('M 10 10 M 10 100 M 100 100 M 100 10 Z').toString(),
          equals('M10 10M10 100M100 100M100 10Z'));
    });

    test('should not collapse multiple m', () {
      expect(new SvgPath('m 10 10 m 10 100 m 100 100 m 100 10 z').toString(),
          equals('M10 10m10 100m100 100m100 10z'));
    });
  });

  group('unshort - cubic', () {
    test("shouldn't change full arc", () {
      expect(new SvgPath('M10 10 C 20 20, 40 20, 50 10').unshort().toString(),
          equals('M10 10C20 20 40 20 50 10'));
    });

    test('should reflect control point after full path', () {
      expect(
          new SvgPath('M10 10 C 20 20, 40 20, 50 10 S 80 0, 90 10')
              .unshort()
              .toString(),
          equals('M10 10C20 20 40 20 50 10 60 0 80 0 90 10'));
    });

    test('should copy starting point if not followed by a path', () {
      expect(new SvgPath('M10 10 S 50 50, 90 10').unshort().toString(),
          equals('M10 10C10 10 50 50 90 10'));
    });

    test('should handle relative paths', () {
      expect(
          new SvgPath('M30 50 c 10 30, 30 30, 40 0 s 30 -30, 40 0')
              .unshort()
              .toString(),
          equals('M30 50c10 30 30 30 40 0 10-30 30-30 40 0'));
    });
  });

  group('unshort - quadratic', () {
    test("shouldn't change full arc", () {
      expect(new SvgPath('M10 10 Q 50 50, 90 10').unshort().toString(),
          equals('M10 10Q50 50 90 10'));
    });

    test('should reflect control point after full path', () {
      expect(new SvgPath('M30 50 Q 50 90, 90 50 T 150 50').unshort().toString(),
          equals('M30 50Q50 90 90 50 130 10 150 50'));
    });

    test('should copy starting point if not followed by a path', () {
      expect(new SvgPath('M10 30 T150 50').unshort().toString(),
          equals('M10 30Q10 30 150 50'));
    });

    test('should handle relative paths', () {
      expect(new SvgPath('M30 50 q 20 20, 40 0 t 40 0').unshort().toString(),
          equals('M30 50q20 20 40 0 20-20 40 0'));
    });
  });

  group('abs', () {
    test('should convert line', () {
      expect(new SvgPath('M10 10 l 30 30').abs().toString(),
          equals('M10 10L40 40'));
    });

    test("shouldn't process existing line", () {
      expect(new SvgPath('M10 10 L30 30').abs().toString(),
          equals('M10 10L30 30'));
    });

    test('should convert multi-segment curve', () {
      expect(
          new SvgPath('M10 10 c 10 30 30 30 40, 0 10 -30 20 -30 40 0')
              .abs()
              .toString(),
          equals('M10 10C20 40 40 40 50 10 60-20 70-20 90 10'));
    });

    test('should handle horizontal lines', () {
      expect(
          new SvgPath('M10 10H40h50').abs().toString(), equals('M10 10H40 90'));
    });

    test('should handle vertical lines', () {
      expect(
          new SvgPath('M10 10V40v50').abs().toString(), equals('M10 10V40 90'));
    });

    test('should handle arcs', () {
      expect(new SvgPath('M40 30a20 40 -45 0 1 20 50').abs().toString(),
          equals('M40 30A20 40-45 0 1 60 80'));
    });

    test('should track position after z', () {
      expect(
          new SvgPath('M10 10 l10 0 l0 10 Z l 0 10 l 10 0 z l-1-1')
              .abs()
              .toString(),
          equals('M10 10L20 10 20 20ZL10 20 20 20ZL9 9'));
    });
  });

  group('rel', () {
    test('should convert line', () {
      expect(new SvgPath('M10 10 L30 30').rel().toString(),
          equals('M10 10l20 20'));
    });

    test("shouldn't process existing line", () {
      expect(new SvgPath('m10 10 l30 30').rel().toString(),
          equals('M10 10l30 30'));
    });

    test('should convert multi-segment curve', () {
      expect(
          new SvgPath('M10 10 C 20 40 40 40 50 10 60 -20 70 -20 90 10')
              .rel()
              .toString(),
          equals('M10 10c10 30 30 30 40 0 10-30 20-30 40 0'));
    });

    test('should handle horizontal lines', () {
      expect(
          new SvgPath('M10 10H40h50').rel().toString(), equals('M10 10h30 50'));
    });

    test('should handle vertical lines', () {
      expect(
          new SvgPath('M10 10V40v50').rel().toString(), equals('M10 10v30 50'));
    });

    test('should handle arcs', () {
      expect(new SvgPath('M40 30A20 40 -45 0 1 60 80').rel().toString(),
          equals('M40 30a20 40-45 0 1 20 50'));
    });

    test('should track position after z', () {
      expect(
          new SvgPath('M10 10 L20 10 L20 20 Z L10 20 L20 20 z L9 9')
              .rel()
              .toString(),
          equals('M10 10l10 0 0 10zl0 10 10 0zl-1-1'));
    });
  });

  group('scale', () {
    test('should scale abs curve', () {
      expect(new SvgPath('M10 10 C 20 40 40 40 50 10').scale(2, 1.5).toString(),
          equals('M20 15C40 60 80 60 100 15'));
    });

    test('should scale rel curve', () {
      expect(new SvgPath('M10 10 c 10 30 30 30 40 0').scale(2, 1.5).toString(),
          equals('M20 15c20 45 60 45 80 0'));
    });

    test('second argument defaults to the first', () {
      expect(new SvgPath('M10 10l20 30').scale(2).toString(),
          equals('M20 20l40 60'));
    });

    test('should handle horizontal lines', () {
      expect(new SvgPath('M10 10H40h50').scale(2, 1.5).toString(),
          equals('M20 15H80h100'));
    });

    test('should handle vertical lines', () {
      expect(new SvgPath('M10 10V40v50').scale(2, 1.5).toString(),
          equals('M20 15V60v75'));
    });

    test('should handle arcs', () {
      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .scale(2, 1.5)
              .round(0)
              .toString(),
          equals('M80 45a72 34 32.04 0 1 40 75'));

      expect(
          new SvgPath('M40 30A20 40 -45 0 1 20 50')
              .scale(2, 1.5)
              .round(0)
              .toString(),
          equals('M80 45A72 34 32.04 0 1 40 75'));
    });
  });

  group('rotate', () {
    test('rotate by 90 degrees about point(10, 10)', () {
      expect(new SvgPath('M10 10L15 10').rotate(90, 10, 10).round().toString(),
          equals('M10 10L10 15'));
    });

    test('rotate by -90 degrees about point (0,0)', () {
      expect(new SvgPath('M0 10L0 20').rotate(-90).round().toString(),
          equals('M10 0L20 0'));
    });

    test('rotate abs arc', () {
      expect(
          new SvgPath('M 100 100 A 90 30 0 1 1 200 200')
              .rotate(45)
              .round()
              .toString(),
          equals('M0 141A90 30 45 1 1 0 283'));
    });

    test('rotate rel arc', () {
      expect(
          new SvgPath('M 100 100 a 90 30 15 1 1 200 200')
              .rotate(20)
              .round()
              .toString(),
          equals('M60 128a90 30 35 1 1 119 257'));
    });
  });

  group('skew', () {
    // SkewX matrix [ 1, 0, 4, 1, 0, 0 ],
    // x = x*1 + y*4 + 0 = x + y*4
    // y = x*0 + y*1 + 0 = y
    test('skewX', () {
      expect(new SvgPath('M5 5L15 20').skewX(75.96).round().toString(),
          equals('M25 5L95 20'));
    });

    // SkewY matrix [ 1, 4, 0, 1, 0, 0 ],
    // x = x*1 + y*0 + 0 = x
    // y = x*4 + y*1 + 0 = y + x*4
    test('skewY', () {
      expect(new SvgPath('M5 5L15 20').skewY(75.96).round().toString(),
          equals('M5 25L15 80'));
    });
  });

  group('matrix', () {
    // x = x*1.5 + y/2 + ( absolute ? 10 : 0)
    // y = x/2 + y*1.5 + ( absolute ? 15 : 0)
    test('path with absolute segments', () {
      expect(
          new SvgPath('M5 5 C20 30 10 15 30 15')
              .matrix([1.5, 0.5, 0.5, 1.5, 10, 15]).toString(),
          equals('M20 25C55 70 32.5 42.5 62.5 52.5'));
    });

    test('path with relative segments', () {
      expect(
          new SvgPath('M5 5 c10 12 10 15 20 30')
              .matrix([1.5, 0.5, 0.5, 1.5, 10, 15]).toString(),
          equals('M20 25c21 23 22.5 27.5 45 55'));
    });

    test('no change', () {
      expect(
          new SvgPath('M5 5 C20 30 10 15 30 15')
              .matrix([1, 0, 0, 1, 0, 0]).toString(),
          equals('M5 5C20 30 10 15 30 15'));
    });

    test('should handle arcs', () {
      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .matrix([1.5, 0.5, 0.5, 1.5, 10, 15])
              .round()
              .toString(),
          equals('M85 80a80 20 45 0 1 55 85'));

      expect(
          new SvgPath('M40 30A20 40 -45 0 1 20 50')
              .matrix([1.5, 0.5, 0.5, 1.5, 10, 15])
              .round()
              .toString(),
          equals('M85 80A80 20 45 0 1 65 100'));
    });
  });

  group('combination', () {
    test('scale + translate', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .scale(2, 3)
              .translate(100, 100)
              .toString(),
          equals('M100 100L120 130 140 130'));
    });

    test('scale + rotate', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .scale(2, 3)
              .rotate(90)
              .round(0)
              .toString(),
          equals('M0 0L-30 20-30 40'));
    });

    test('empty', () {
      expect(
          new SvgPath('M0 0 L 10 10 20 10')
              .translate(0)
              .scale(1)
              .rotate(0, 10, 10)
              .round(0)
              .toString(),
          equals('M0 0L10 10 20 10'));
    });
  });

  group('translate', () {
    test('should translate abs curve', () {
      expect(
          new SvgPath('M10 10 C 20 40 40 40 50 10').translate(5, 15).toString(),
          equals('M15 25C25 55 45 55 55 25'));
    });

    test('should translate rel curve', () {
      expect(
          new SvgPath('M10 10 c 10 30 30 30 40 0').translate(5, 15).toString(),
          equals('M15 25c10 30 30 30 40 0'));
    });

    test('second argument defaults to zero', () {
      expect(new SvgPath('M10 10L20 30').translate(10).toString(),
          equals('M20 10L30 30'));
    });

    test('should handle horizontal lines', () {
      expect(new SvgPath('M10 10H40h50').translate(10, 15).toString(),
          equals('M20 25H50h50'));
    });

    test('should handle vertical lines', () {
      expect(new SvgPath('M10 10V40v50').translate(10, 15).toString(),
          equals('M20 25V55v50'));
    });

    test('should handle arcs', () {
      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .translate(10, 15)
              .round()
              .toString(),
          equals('M50 45a40 20 45 0 1 20 50'));

      expect(
          new SvgPath('M40 30A20 40 -45 0 1 20 50')
              .translate(10, 15)
              .round()
              .toString(),
          equals('M50 45A40 20 45 0 1 30 65'));
    });
  });

  group('round', () {
    test('should round arcs', () {
      expect(
          new SvgPath('M10 10 A12.5 17.5 45.5 0 0 15.5 19.5')
              .round()
              .toString(),
          equals('M10 10A13 18 45.5 0 0 16 20'));
    });

    test('should round curves', () {
      expect(
          new SvgPath('M10 10 c 10.12 30.34 30.56 30 40.00 0.12')
              .round()
              .toString(),
          equals('M10 10c10 30 31 30 40 0'));
    });

    test('set precision', () {
      expect(new SvgPath('M10.123 10.456L20.4351 30.0000').round(2).toString(),
          equals('M10.12 10.46L20.44 30'));
    });

    test('should track errors', () {
      expect(new SvgPath('M1.2 1.4l1.2 1.4 l1.2 1.4').round().toString(),
          equals('M1 1l1 2 2 1'));
    });

    test('should track errors #2', () {
      expect(
          new SvgPath('M1.2 1.4 H2.4 h1.2 v2.4 h-2.4 V2.4 v-1.2')
              .round()
              .toString(),
          equals('M1 1H2h2v3h-3V2v-1'));
    });

    test('should track errors for contour start', () {
      expect(
          new SvgPath('m0.4 0.2zm0.4 0.2m0.4 0.2m0.4 0.2zm0.4 0.2')
              .round()
              .abs()
              .toString(),
          equals('M0 0ZM1 0M1 1M2 1ZM2 1'));
    });

    test('reset delta error on contour end', () {
      expect(
          new SvgPath('m.1 .1l.3 .3zm.1 .1l.3 .3zm0 0z')
              .round()
              .abs()
              .toString(),
          equals('M0 0L0 0ZM0 0L1 1ZM0 0Z'));
    });
  });

  group('unarc', () {
    test('almost complete arc gets expanded to 4 curves', () {
      expect(
          new SvgPath('M100 100 A30 50 0 1 1 110 110')
              .unarc()
              .round()
              .toString(),
          equals(
              'M100 100C89 83 87 54 96 33 105 12 122 7 136 20 149 33 154 61 147 84 141 108 125 119 110 110'));
    });

    test('small arc gets expanded to one curve', () {
      expect(
          new SvgPath('M100 100 a30 50 0 0 1 30 30').unarc().round().toString(),
          equals('M100 100C113 98 125 110 130 130'));
    });

    test('unarc a circle', () {
      expect(
          new SvgPath(
                  'M 100, 100 m -75, 0 a 75,75 0 1,0 150,0 a 75,75 0 1,0 -150,0')
              .unarc()
              .round()
              .toString(),
          equals(
              'M100 100m-75 0C25 141 59 175 100 175 141 175 175 141 175 100 175 59 141 25 100 25 59 25 25 59 25 100'));
    });

    test('rounding errors', () {
      // Coverage
      //
      // Due to rounding errors, with these exact arguments radicand
      // will be -9.974659986866641e-17, causing Math.sqrt() of that to be NaN
      expect(
          new SvgPath(
                  'M-0.5 0 A 0.09188163040671497 0.011583783896639943 0 0 1 0 0.5')
              .unarc()
              .round(5)
              .toString(),
          equals(
              'M-0.5 0C0.59517-0.01741 1.59491 0.08041 1.73298 0.21848 1.87105 0.35655 1.09517 0.48259 0 0.5'));
    });

    test('rounding errors #2', () {
      // Coverage
      //
      // Due to rounding errors this will compute Math.acos(-1.0000000000000002)
      // and fail when calculating vector between angles
      expect(
          new SvgPath('M-0.07467194809578359 -0.3862391309812665'
                  'A1.2618792965076864 0.2013618852943182 90 0 1 -0.7558937461581081 -0.8010219619609416')
              .unarc()
              .round(5)
              .toString(),
          equals(
              'M-0.07467-0.38624C-0.09295 0.79262-0.26026 1.65542-0.44838 1.54088'
              '-0.63649 1.42634-0.77417 0.37784-0.75589-0.80102'));
    });

    test("we're already there", () {
      // Asked to draw a curve between a point and itself. According to spec,
      // nothing shall be drawn in this case.
      expect(
          new SvgPath('M100 100A123 456 90 0 1 100 100')
              .unarc()
              .round()
              .toString(),
          equals('M100 100L100 100'));

      expect(
          new SvgPath('M100 100a123 456 90 0 1 0 0').unarc().round().toString(),
          equals('M100 100l0 0'));
    });

    test('radii are zero', () {
      // both rx and ry are zero
      expect(
          new SvgPath('M100 100A0 0 0 0 1 110 110').unarc().round().toString(),
          equals('M100 100L110 110'));

      // rx is zero
      expect(
          new SvgPath('M100 100A0 100 0 0 1 110 110')
              .unarc()
              .round()
              .toString(),
          equals('M100 100L110 110'));
    });
  });

  group('arc transform edge cases', () {
    test('replace arcs rx/ry = 0 with lines', () {
      expect(
          new SvgPath('M40 30a0 40 -45 0 1 20 50Z M40 30A20 0 -45 0 1 20 50Z')
              .scale(2)
              .toString(),
          equals('M80 60l40 100ZM80 60L40 100Z'));
    });

    test('drop arcs with end point == start point', () {
      expect(
          new SvgPath('M40 30a20 40 -45 0 1 0 0')
              .scale(2)
              .toString(),
          equals('M80 60l0 0'));

      expect(
          new SvgPath('M40 30A20 40 -45 0 1 40 30')
              .scale(2)
              .toString(),
          equals('M80 60L80 60'));
    });

    test('to line at scale x|y = 0', () {
      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .scale(0, 1)
              .toString(),
          equals('M0 30l0 50'));

      expect(
          new SvgPath('M40 30A20 40 -45 0 1 20 50')
              .scale(1, 0)
              .toString(),
          equals('M40 0L20 0'));
    });

    test('rotate to +/- 90 degree', () {
      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .rotate(90)
              .round(0)
              .toString(),
          equals('M-30 40a20 40 45 0 1-50 20'));

      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .matrix([ 0, 1, -1, 0, 0, 0 ])
              .round(0)
              .toString(),
          equals('M-30 40a20 40 45 0 1-50 20'));

      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .rotate(-90)
              .round(0)
              .toString(),
          equals('M30-40a20 40 45 0 1 50-20'));

      expect(
          new SvgPath('M40 30a20 40 -45 0 1 20 50')
              .matrix([ 0, -1, 1, 0, 0, 0 ])
              .round(0)
              .toString(),
          equals('M30-40a20 40 45 0 1 50-20'));
    });

    test('process circle-like segments', () {
      expect(
          new SvgPath('M50 50A30 30 -45 0 1 100 100')
              .scale(0.5)
              .round(0)
              .toString(),
          equals('M25 25A15 15 0 0 1 50 50'));
    });

    test('almost zero eigen values', () {
      expect(
          new SvgPath('M148.7 277.9A228.7 113.2 90 1 0 159.3 734.8')
              .translate(10)
              .round(1)
              .toString(),
          equals('M158.7 277.9A228.7 113.2 90 1 0 169.3 734.8'));
    });

    test('should flip sweep flag if image is flipped', () {
      expect(
          new SvgPath('M10 10A20 15 90 0 1 30 10')
              .scale(1, -1)
              .translate(0, 40)
              .toString(),
          equals('M10 30A20 15 90 0 0 30 30'));

      expect(
          new SvgPath('M10 10A20 15 90 0 1 30 10')
              .scale(-1, -1)
              .translate(40, 40)
              .toString(),
          equals('M30 30A20 15 90 0 1 10 30'));
    });
  });
}

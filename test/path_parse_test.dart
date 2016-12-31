// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import '../lib/src/svgpath.dart';
import 'package:test/test.dart';
import 'dart:io' show Platform, File;
import 'package:path/path.dart' show dirname;

void main() {
  test('big batch', () {
    var path = dirname(Platform.script.toString());
    var filePath = path.substring(path.lastIndexOf('file://') + 7);
    var file = new File('$filePath/big.txt');
    var lines = file.readAsLinesSync();
    for (var line in lines) {
      if (line == null) {
        continue;
      }

      expect(new SvgPath(line).toString(), equals(line));
    }
  });

  test('empty string', () {
    expect(new SvgPath('').toString(), equals(''));
  });

  test('line terminators', () {
    expect(
        new SvgPath('M0\r 0\n\u1680l2-3\nz').toString(), equals('M0 0l2-3z'));
  });

  test('params formats', () {
    expect(new SvgPath('M 0.0 0.0').toString(), equals('M0 0'));
    expect(new SvgPath('M 1e2 0').toString(), equals('M100 0'));
    expect(new SvgPath('M 1e+2 0').toString(), equals('M100 0'));
    expect(new SvgPath('M +1e+2 0').toString(), equals('M100 0'));
    expect(new SvgPath('M 1e-2 0').toString(), equals('M0.01 0'));
    expect(new SvgPath('M 0.1e-2 0').toString(), equals('M0.001 0'));
    expect(new SvgPath('M .1e-2 0').toString(), equals('M0.001 0'));
  });

  test('repeated', () {
    expect(new SvgPath('M 0 0 100 100').toString(), equals('M0 0L100 100'));
    expect(new SvgPath('m 0 0 100 100').toString(), equals('M0 0l100 100'));
    expect(new SvgPath('M 0 0 R 1 1 2 2').toString(), equals('M0 0R1 1 2 2'));
    expect(new SvgPath('M 0 0 r 1 1 2 2').toString(), equals('M0 0r1 1 2 2'));
  });

  test('errors', () {
    expect(new SvgPath('0').err, equals('SvgPath: bad command 0 (at pos 0)'));
    expect(new SvgPath('U').err, equals('SvgPath: bad command U (at pos 0)'));
    expect(new SvgPath('M0 0G 1').err,
        equals('SvgPath: bad command G (at pos 4)'));
    expect(new SvgPath('z').err,
        equals('SvgPath: string should start with "M" or "m"'));
    expect(new SvgPath('M+').err,
        equals('SvgPath: param should start with 0..9 or `.` (at pos 2)'));

    expect(new SvgPath('M00').err,
        equals(
            'SvgPath: numbers started with `0` such as `09` are ilegal (at pos 1)'));

    expect(new SvgPath('M0e').err,
        equals('SvgPath: invalid float exponent (at pos 3)'));

    expect(new SvgPath('M0').err, equals('SvgPath: missed param (at pos 2)'));

    expect(new SvgPath('M0,0,').err,
        equals('SvgPath: missed param (at pos 5)'));

    expect(new SvgPath('M0 .e3').err,
        equals('SvgPath: invalid float exponent (at pos 4)'));
  });
}

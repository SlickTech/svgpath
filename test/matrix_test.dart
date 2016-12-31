// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import '../lib/src/matrix.dart';
import 'package:test/test.dart';

void main() {
  Matrix matrix;

  setUp(() {
    matrix = new Matrix();
  });

  group('ignore empty actions', () {
    test('empty Matrix', () {
      expect(matrix.toArray(), equals([1, 0, 0, 1, 0, 0]));
    });

    test('matrix', () {
      matrix.matrix([1, 0, 0, 1, 0, 0]);
      expect(matrix.queue.isEmpty, equals(true));
    });

    test('translate', () {
      matrix.translate(0, 0);
      expect(matrix.queue.isEmpty, equals(true));
    });

    test('scale', () {
      matrix.scale(1, 1);
      expect(matrix.queue.isEmpty, equals(true));
    });

    test('rotate', () {
      matrix.rotate(0);
      expect(matrix.queue.isEmpty, equals(true));
    });

    test('skewX', () {
      matrix.skewX(0);
      expect(matrix.queue.isEmpty, equals(true));
    });

    test('skewY', () {
      matrix.skewY(0);
      expect(matrix.queue.isEmpty, equals(true));
    });
  });

  test('do nothing on empty queue', () {
    expect(matrix.calc(10, 11), equals([10, 11]));
    expect(matrix.toArray(), equals([1, 0, 0, 1, 0, 0]));
  });

  test('compose', () {
    matrix
      ..translate(10, 10)
      ..translate(-10, -10)
      ..rotate(180, 10, 10)
      ..rotate(180, 10, 10);

    var m = matrix.toArray();

    // Need to round errors prior to compare
    expect(double.parse(m[0].toStringAsFixed(2)), equals(1));
    expect(double.parse(m[1].toStringAsFixed(2)), equals(0));
    expect(double.parse(m[2].toStringAsFixed(2)), equals(0));
    expect(double.parse(m[3].toStringAsFixed(2)), equals(1));
    expect(double.parse(m[4].toStringAsFixed(2)), equals(0));
    expect(double.parse(m[5].toStringAsFixed(2)), equals(0));
  });

//  test('cache', () {
//    matrix..translate(10, 20)..scale(2, 3);
//    expect(matrix.cache, null);
//    expect(matrix.toArray(), equals([2, 0, 0, 3, 10, 20]));
//    expect(matrix.cache, equals([2, 0, 0, 3, 10, 20]));
//  });
}

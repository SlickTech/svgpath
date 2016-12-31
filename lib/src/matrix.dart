// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'dart:math' as math;

num toFixed(num value, int digits) {
  num rt = double.parse(value.toStringAsFixed(digits));
  return fixInt(rt);
}

num fixInt(num value) {
  var integer = value.toInt();

  if (integer == value) {
    return integer;
  }
  return value;
}

class Matrix {
  // list of _matrixes to apply
  final queue = <List<num>>[];

  List<num> _cache;

  Matrix();

  Matrix matrix(List<num> m) {
    if (m[0] != 1 ||
        m[1] != 0 ||
        m[2] != 0 ||
        m[3] != 1 ||
        m[4] != 0 ||
        m[5] != 0) {
      queue.add(m);
    }
    return this;
  }

  void translate(num tx, num ty) {
    if (tx != 0 || ty != 0) {
      _cache = null;
      queue.add([1, 0, 0, 1, tx, ty]);
    }
  }

  void scale(num sx, num sy) {
    if (sx != 1 || sy != 1) {
      _cache = null;
      queue.add([sx, 0, 0, sy, 0, 0]);
    }
  }

  void rotate(num angle, [num rx = 0, num ry = 0]) {
    if (angle != 0) {
      translate(rx, ry);

      var rad = angle * math.PI / 180;
      var cos = math.cos(rad);
      var sin = math.sin(rad);

      _cache = null;
      queue.add([cos, sin, -sin, cos, 0, 0]);

      translate(-rx, -ry);
    }
  }

  void skewX(num angle) {
    if (angle != 0) {
      _cache = null;
      queue.add([1, 0, math.tan(angle * math.PI / 180), 1, 0, 0]);
    }
  }

  void skewY(num angle) {
    if (angle != 0) {
      _cache = null;
      queue.add([1, math.tan(angle * math.PI / 180), 0, 1, 0, 0]);
    }
  }

  List<num> toArray() {
    if (_cache != null) {
      return _cache;
    }

    if (queue.isEmpty) {
      _cache = [1, 0, 0, 1, 0, 0];
      return _cache;
    }

    _cache = queue[0];

    for (int i = 1; i < queue.length; ++i) {
      _cache = _multiply(_cache, queue[i]);
    }

    return _cache;
  }

  /// Apply list of matrixes to (x,y) point.
  /// If `isRelative` set, `translate` component of matrix will be skipped
  List<num> calc(num x, num y, {bool isRelative: false}) {
    // Don't change point on empty transforms queue
    if (queue.isEmpty) {
      return [x, y];
    }

    // Calculate final matrix, if not exists
    //
    // NB. if you decide to apply transforms to point one-by-one,
    // they should be taken in reverse order

    if (_cache == null) {
      _cache = toArray();
    }

    // Apply matrix to point
    return [
      fixInt(x * _cache[0] + y * _cache[2] + (isRelative ? 0 : _cache[4])),
      fixInt(x * _cache[1] + y * _cache[3] + (isRelative ? 0 : _cache[5]))
    ];
  }

  List<num> _multiply(List<num> m1, List<num> m2) {
    return [
      m1[0] * m2[0] + m1[2] * m2[1],
      m1[1] * m2[0] + m1[3] * m2[1],
      m1[0] * m2[2] + m1[2] * m2[3],
      m1[1] * m2[2] + m1[3] * m2[3],
      m1[0] * m2[4] + m1[2] * m2[5] + m1[4],
      m1[1] * m2[4] + m1[3] * m2[5] + m1[5]
    ];
  }

  num get scaleXValue => _cache[0];
  void set scaleXValue(num value) {
    _cache[0] = value;
  }

  num get scaleYValue => _cache[3];
  void set scaleYValue(num value) {
    _cache[3] = value;
  }

  num get skewXValue => _cache[1];
  void set skewXValue(num value) {
    _cache[1] = value;
  }

  num get skewYValue => _cache[2];
  void set skewYValue(num value) {
    _cache[2] = value;
  }

  num get translateXValue => _cache[4];
  void set translateXValue(num value) {
    _cache[4] = value;
  }

  num get translateYValue => _cache[5];
  void set translateYValue(num value) {
    _cache[5] = value;
  }

  num get a => _cache[0];
  void set a(num value) {
    _cache[0] = value;
  }

  num get b => _cache[1];
  void set b(num value) {
    _cache[1] = value;
  }

  num get c => _cache[2];
  void set c(num value) {
    _cache[2] = value;
  }

  num get d => _cache[3];
  void set d(num value) {
    _cache[3] = value;
  }

  num get e => _cache[4];
  void set e(num value) {
    _cache[4] = value;
  }

  num get f => _cache[5];
  void set f(num value) {
    _cache[5] = value;
  }

//  List<num> get cache => _cache;
}

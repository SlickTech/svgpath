# svgpath

This is a Dart port of Fontello's [svgpath](https://github.com/fontello/svgpath) JavaScript library.

> Low level toolkit for SVG paths transformations. Sometime you can't use
`transform` attributes and have to apply changes to svg paths directly.
Then this package is for you :) !

This package works both in browser and on server.

## API


### new SvgPath(path)

Constructor. Creates new `SvgPath` class instance.


### .abs()

Converts all path commands to absolute.


### .rel()

Converts all path commands to relative. Useful to reduce output size.


### .scale(sx [, sy])

Rescale path (the same as SVG `scale` transformation). `sy` = `sx` by default.


### .translate(x [, y])

Translate path (the same as SVG `translate` transformation). `y` = 0 by default.


### .rotate(angle [, rx, ry])

Rotate path to `angle` degrees around (rx, ry) point. If rotation center not set,
(0, 0) used. The same as SVG `rotate` transformation.


### .skewX(degrees)

Skew path along the X axis by `degrees` angle.


### .skewY(degrees)

Skew path along the Y axis by `degrees` angle.


### .matrix([ m1, m2, m3, m4, m5, m6 ])

Apply 2x3 affine transform matrix to path. Params - array. The same as SVG
`matrix` transformation.


### .transform(string)

Any SVG transform or their combination. For example `rotate(90) scale(2,3)`.
The same format, as described in SVG standard for `transform` attribute.


### .unshort()

Converts smooth curves `T`/`t`/`S`/`s` with "missed" control point to
generic curves (`Q`/`q`/`C`/`c`).


### .unarc()

Replaces all arcs with bezier curves.


### .toString() -> String

Returns final path string.


### .round(precision)

Round all coordinates to given decimal precision. By default round to integer.
Useful to reduce resulting output string size.


### .iterate(function(segment, index, x, y) [, keepLazyStack])

Apply iterator to all path segments.

- Each iterator receives `segment`, `index`, `x` and `y` params.
  Where (x, y) - absolute coordinates of segment start point.
- Iterator can modify current segment directly (return nothing in this case).
- Iterator can return array of new segments to replace current one (`[]` means
  that current segment should be deleted).

If second param `keepLazyStack` set to `true`, then iterator will not evaluate
stacked transforms prior to run. That can be useful to optimize calculations.

// Copyright (c) 2014, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library json;

import 'package:enumerators/enumerators.dart' as E;
import 'package:enumerators/combinators.dart' as E;
import 'package:pretty_demo/random.dart';
import 'dart:math';

E.Enumeration oneOf(List values) {
  return values.map(E.singleton).reduce((x, y) => x + y);
}

final _keys = E.nats.map((n) => "key$n");
final _strings = E.nats.map((n) => "value$n");

final _jsons = E.fix((e) =>
    _strings
    + E.bools
    + E.ints
    + E.singleton(null)
    + E.mapsOf(_keys, e)
    + E.listsOf(e));

final Random _rand = new Random();

Object randomJson(int size) {
  final part = _jsons.parts[size];
  return part[nextBigInt(_rand, part.length)];
}

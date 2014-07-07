// Copyright (c) 2014, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library tree;

import 'package:enumerators/enumerators.dart' as E;
import 'package:enumerators/combinators.dart' as E;
import 'package:pretty_demo/random.dart';
import 'dart:math';

class Tree {
  final String name;
  final List<Tree> children;

  Tree(this.name, this.children);

  toString() => "$name ${children.map((c) => c.toString()).toList()}";
}

_mkTree(name) => (children) => new Tree(name, children);

E.Enumeration<String> _names =
  ["foo", "bar", "baz", "qux"].map(E.singleton).reduce((x, y) => x + y);

E.Enumeration<Tree> _trees = E.fix((e) =>
    E.singleton(_mkTree).apply(_names).apply(E.listsOf(e)));

final Random _rand = new Random();

Tree randomTree(int size) {
  final part = _trees.parts[size];
  return part[nextBigInt(_rand, part.length)];
}
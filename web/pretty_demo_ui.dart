// Copyright (c) 2014, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library pretty_demo_ui;

import 'dart:convert' show JsonEncoder;
import 'dart:js';

import 'package:polymer/polymer.dart';
import 'package:pretty_demo/tree.dart';
import 'package:pretty_demo/json.dart';
import 'package:pretty/pretty.dart';

import 'pretty_viewer.dart';

Document a = text("aaa");
Document b = text("bbb");
Document c = text("ccc");
Document d = text("ddd");

class PlusDemo extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    return a + empty + b + line + c;
  }
}

class NestDemo1 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    return a + (line + b + line + c).nest(2) + line + d;
  }
}

class NestDemo2 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    return a + (line + b + (line + c).nest(2) + line + d).nest(2);
  }
}

class GroupDemo1 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    return (a + line + (b + line + c).group + line + d).group;
  }
}

class GroupDemo2 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    return (a + (line + (b + line + c).group).nest(2) + line + d).group;
  }
}

class TreeDemo extends PrettyViewerConfig {

  @override generateDocument() => prettyTree(randomTree(20));

  static Document prettyTree(Tree tree) {
    final prettyChildren = tree.children.isEmpty
        ? empty
        : brackets((text(",") + line).join(tree.children.map(prettyTree)));
    return (text(tree.name) + prettyChildren).group;
  }

  static Document brackets(Document doc) {
    return (text(" {") + line + doc).nest(2) + line + text("}");
  }
}

class JsonDemo extends PrettyViewerConfig {

  @override generateDocument() => prettyJson(randomJson(20));

  static final Document comma = text(",") + line;

  static Document between(String left, String right, Document doc) {
    return (text(left) + (lineOr('') + doc).nest(2) + lineOr('') + text(right)).group;
  }

  static Document prettyJson(Object json) {
    if (json is List) {
      return between("[", "]", comma.join(json.map(prettyJson)));
    } else if (json is Map) {
      final children = [];
      json.forEach((key, value) {
        children.add(escape(key) + text(": ") + prettyJson(value));
      });
      return between("{", "}", comma.join(children));
    } else {
      return escape(json);
    }
  }

  static Document escape(Object leaf) {
    return text(const JsonEncoder().convert(leaf));
  }
}

@CustomTag('pretty-demo-ui')
class PrettyDemoUi extends PolymerElement {

  PrettyDemoUi.created() : super.created() {}

  @override ready() {
    final hljs = context['hljs'];
    for (final codeElement in shadowRoot.getElementsByTagName('code')) {
      if (codeElement.classes.contains("dart")) {
        hljs.callMethod('highlightBlock', [codeElement]);
      }
    }
  }

  final plusConfig = new PlusDemo();
  final nestConfig1 = new NestDemo1();
  final nestConfig2 = new NestDemo2();
  final groupConfig1 = new GroupDemo1();
  final groupConfig2 = new GroupDemo2();
  final treeConfig = new TreeDemo();
  final jsonConfig = new JsonDemo();
}
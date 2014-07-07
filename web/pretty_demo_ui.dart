// Copyright (c) 2014, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library pretty_demo_ui;

import 'package:polymer/polymer.dart';
import 'package:pretty_demo/tree.dart';
import 'pretty_viewer.dart';
import 'package:pretty/pretty.dart';

class NestDemo1 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    final a = text("aaa");
    final b = text("bbb");
    final c = text("ccc");
    final d = text("ddd");
    return a + (line + b + line + c).nest(2) + line + d;
  }
}

class NestDemo2 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    final a = text("aaa");
    final b = text("bbb");
    final c = text("ccc");
    final d = text("ddd");
    return a + (line + b + (line + c).nest(2) + line + d).nest(2);
  }
}

class GroupDemo1 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    final a = text("aaa");
    final b = text("bbb");
    final c = text("ccc");
    final d = text("ddd");
    return (a + line + (b + line + c).group + line + d).group;
  }
}

class GroupDemo2 extends PrettyViewerConfig {
  @override final supportsReloading = false;

  @override generateDocument() {
    final a = text("aaa");
    final b = text("bbb");
    final c = text("ccc");
    final d = text("ddd");
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

@CustomTag('pretty-demo-ui')
class PrettyDemoUi extends PolymerElement {

  PrettyDemoUi.created() : super.created();

  final nestConfig1 = new NestDemo1();
  final nestConfig2 = new NestDemo2();
  final groupConfig1 = new GroupDemo1();
  final groupConfig2 = new GroupDemo2();
  final treeConfig = new TreeDemo();
}
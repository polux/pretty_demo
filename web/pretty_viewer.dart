// Copyright (c) 2014, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

library pretty_viewer;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:paper_elements/paper_button.dart';
import 'package:pretty/pretty.dart' as P;

abstract class PrettyViewerConfig {
  bool supportsReloading = true;
  P.Document generateDocument() => null;
}

@CustomTag('pretty-viewer')
class PrettyViewer extends PolymerElement {

  @published PrettyViewerConfig config;

  @observable int fontSizePx = null;

  P.Document doc = P.empty;
  bool moving = false;
  int width = 75;

  PreElement display;
  PaperButton newTreeButton;
  PaperButton plusButton;
  PaperButton minusButton;
  DivElement widthMeasurement;
  DivElement verticalLine;
  DivElement redZone;
  SpanElement widthText;

  double get characterSize => widthMeasurement.clientWidth / 20;

  PrettyViewer.created() : super.created();

  void setupElements() {
    display = $['display'];
    newTreeButton = $['newtree'];
    plusButton = $['plus'];
    minusButton = $['minus'];
    widthMeasurement = $['width-measurement'];
    verticalLine = $['vertical-line'];
    redZone = $['red-zone'];
    widthText = $['width-text'];
  }

  void setupFontSize() {
    final sizeString = display.getComputedStyle().fontSize;
    fontSizePx = int.parse(sizeString.substring(0, sizeString.length - 2));
  }

  void setupHandlers() {
    newTreeButton.onClick.listen((_) {
      newDoc();
      render();
    });
    window.onResize.listen((_) {
      clampWidth();
      render();
    });
    verticalLine.onMouseDown.listen((_) { moving = true; });
    window.onMouseUp.listen((_) { moving = false; });
    window.onMouseMove.listen((MouseEvent event) {
      if (!moving) return;
      double xPos = event.page.x - display.getBoundingClientRect().left;
      int maxWidth =
          (display.getBoundingClientRect().width / characterSize).floor();
      width = (xPos / characterSize).round();
      clampWidth();
      render();
      event.preventDefault();
    });
    minusButton.onClick.listen((_) {
      fontSizePx = max(fontSizePx - 2, 1);
      // we wait for the DOM to render in order to get an accurate characterSize
      new Future(() {
        clampWidth();
        render();
      });
    });
    plusButton.onClick.listen((_) {
      fontSizePx += 2;
      // we wait for the DOM to render in order to get an accurate characterSize
      new Future(() {
        clampWidth();
        render();
      });
    });
  }

  void newDoc() {
    doc = config.generateDocument();
  }

  void clampWidth() {
    double displayWidth = display.getBoundingClientRect().width;
    int maxWidth = (displayWidth / characterSize).floor();
    width = width.clamp(0, maxWidth);
  }

  void render() {
    double x = width * characterSize;
    verticalLine.style.left = "${x}px";
    redZone.style.left = "${x}px";
    redZone.style.width = "${display.clientWidth - x}px";
    widthText.innerHtml = width.toString();
    display.text = doc.render(width);
  }

  @override void attached() {
    super.attached();
    setupElements();
    setupFontSize();
    setupHandlers();
    newDoc();
    render();
  }
}
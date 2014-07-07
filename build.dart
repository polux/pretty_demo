// Copyright (c) 2014, Google Inc. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Author: Paul Brauner (polux@google.com)

import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: ['web/pretty_demo.html'],
      options: parseOptions(args));
}

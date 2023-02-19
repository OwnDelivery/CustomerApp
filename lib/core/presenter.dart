import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class Presenter<T> {
  final StreamController<T> _viewStateController = StreamController();

  Stream<T> getViewStateStream() {
    return _viewStateController.stream;
  }

  @protected
  StreamController<T> getSink() {
    return _viewStateController;
  }

  onDestroy() {
    _viewStateController.sink.close();
  }
}

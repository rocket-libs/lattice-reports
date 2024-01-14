import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class Messenger<TModel> {
  final List<TModel> _items = [];
  final List<Function(List<TModel>)> _listeners = [];

  TModel get singleOrNull => _items.single;

  set single(TModel value) {
    many = [value];
    _notifyListeners();
  }

  TModel getSingleOrDefault({required TModel defaultValue}) {
    if (_items.isEmpty) {
      return defaultValue;
    }
    return _items.single;
  }

  setUntypedItems(List<dynamic> value) {
    many = value.cast<TModel>().toList();
  }

  set many(List<TModel> value) {
    _items.clear();
    _items.addAll(value);
    _notifyListeners();
  }

  initialize() {
    // _controller.stream.listen((event) {
    //   items = event;
    // });
    refreshAsync().then((value) {}).catchError((error) {
      throw error;
    });
  }

  String get name;

  // updateItem(
  //     {required TModel item,
  //     bool insertIfNotFound = true,
  //     int Function(TModel, TModel)? fnSorter}) {
  //   final index = _items.indexWhere((element) => element.id == item.id);
  //   if (index == -1) {
  //     if (insertIfNotFound) {
  //       _items.add(item);
  //     } else {
  //       throw Exception("Item with id '${item.id}' not found.");
  //     }
  //   } else {
  //     _items[index] = item;
  //   }
  //   if (fnSorter != null) {
  //     _items.sort(fnSorter);
  //   }
  //   _notifyListeners();
  // }

  List<TModel> get many {
    return _items;
  }

  void refreshWithoutAwait() {
    refreshAsync(); // We purposely don't await this call as we want to refresh in the background
  }

  Future refreshAsync();

  // sinkMany(List<TModel> items) {
  //   if (_controller.isClosed) return;
  //   _controller.sink.add(items);
  //   _notifyListeners();
  // }

  _notifyListeners() {
    for (var specificListener in _listeners) {
      specificListener(many);
    }
  }

  addListener(Function(List<TModel>) listener) {
    _listeners.add(listener);
    listener(many);
  }

  removeListener(Function(List<TModel>) listener) {
    _listeners.remove(listener);
  }

  // final _controller = StreamController<List<TModel>>.broadcast();

  @mustCallSuper
  dispose() {
    _items.clear();
    _listeners.clear();
    // _controller.close();
  }
}

import 'package:blocstar/BlocstarContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:flutter/material.dart';

abstract class LogicBase<TBlocstarLogicBaseContext extends BlocstarContextBase>
    extends BlocstarLogicBase<TBlocstarLogicBaseContext> {
  late Future Function(Future Function()) runWrappedAsync;
  Future Function() onInitializedAsync = () async {};

  @mustCallSuper
  @override
  Future initializeAsync() async {
    await onInitializedAsync();
  }
}

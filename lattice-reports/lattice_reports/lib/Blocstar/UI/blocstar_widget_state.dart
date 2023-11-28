import 'package:blocstar/BlocstarContextBase.dart';
import 'package:blocstar/BlocstarLogicBase.dart';
import 'package:blocstar/BlocstarState.dart';
import 'package:flutter/material.dart';

abstract class BlocStarWidgetState<TWidget extends StatefulWidget,
        TLogic extends BlocstarLogicBase<BlocstarContextBase>>
    extends BlocstarState<TWidget, TLogic> {
  bool _busy = false;

  Widget get mainContent;
  Widget get busyContent;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onFirstBuild();
    });
  }

  void onFirstBuild();

  set busy(bool value) {
    setState(() {
      _busy = value;
    });
  }

  Future runBusyAsync(Future Function() asyncFunction) async {
    busy = true;
    try {
      await asyncFunction();
    } finally {
      busy = false;
    }
  }

  Future _initializeLogic() async {
    if (logic.initialized) {
      return;
    }
    await logic.initializeAsync();
  }

  @override
  Widget rootWidget() {
    if (_busy) {
      return busyContent;
    } else {
      if (logic.initialized) {
        return mainContent;
      }
      return FutureBuilder(
        future: _initializeLogic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return mainContent;
          } else {
            return busyContent;
          }
        },
      );
    }
  }
}

import 'package:blocstar/BlocstarContextBase.dart';

import 'package:flutter/material.dart';

import '../logic_base.dart';
import 'blocstar_widget_state.dart';

abstract class WidgetState<TWidget extends StatefulWidget,
        TLogic extends LogicBase<BlocstarContextBase>>
    extends BlocStarWidgetState<TWidget, TLogic> {
  bool isBusy = false;
  @override
  void initState() {
    logic.runWrappedAsync = (fn) async {
      try {
        setState(() {
          isBusy = true;
        });
        return await fn();
      } finally {
        setState(() {
          isBusy = false;
        });
      }
    };
    logic.onInitializedAsync = () async {
      await onLogicInitializedAsync();
    };
    super.initState();
  }

  double get usableHeight {
    final mediaQuery = MediaQuery.of(context);
    final appBarHeight = kToolbarHeight;
    final viewPortHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return viewPortHeight - appBarHeight;
  }

  Future<void> onLogicInitializedAsync() async {}

  Widget buildRootWidget(BuildContext context);

  @override
  Widget get busyContent => Container();

  @override
  Widget get mainContent => buildRootWidget(context);

  Future<void> onFirstBuildAsync() async {}

  @override
  void onFirstBuild() {
    Future.sync(() => onFirstBuildAsync());
  }
}

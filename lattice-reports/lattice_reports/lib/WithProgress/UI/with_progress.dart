import 'package:flutter/material.dart';

class WithProgress extends StatelessWidget {
  final Widget child;
  final bool showProgress;

  const WithProgress(
      {super.key, required this.child, required this.showProgress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showProgress)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}

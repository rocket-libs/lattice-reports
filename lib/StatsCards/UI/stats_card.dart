import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;
  final Color foregroundColor;
  final Color? backgroundColor;

  const StatsCard(
      {super.key,
      required this.header,
      required this.body,
      required this.footer,
      required this.foregroundColor,
      this.backgroundColor});

  Color get _backgroundColor {
    if (backgroundColor != null) {
      return backgroundColor!;
    } else {
      return _getContrastedBackgroundColor(foregroundColor, 0.4);
    }
  }

  Color _getContrastedBackgroundColor(Color darkColor, double factor) {
    // Ensure the factor is within the valid range (0.0 to 1.0)
    factor = factor.clamp(0.0, 1.0);

    // Extract the RGB components of the dark color
    int red = darkColor.red;
    int green = darkColor.green;
    int blue = darkColor.blue;

    // Calculate the lighter color by blending with white
    int newRed = ((1.0 - factor) * 255 + factor * red).round();
    int newGreen = ((1.0 - factor) * 255 + factor * green).round();
    int newBlue = ((1.0 - factor) * 255 + factor * blue).round();

    // Return the new color
    return Color.fromARGB(255, newRed, newGreen, newBlue);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: foregroundColor),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: _backgroundColor,
        ),
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              header,
              Expanded(
                child: Center(
                  child: FittedBox(fit: BoxFit.scaleDown, child: body),
                ),
              ),
              footer,
            ],
          ),
        ),
      ),
    );
  }
}

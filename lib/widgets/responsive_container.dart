import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

/// Experiment 3: Responsive Content Container that adjusts padding, max-width,
/// and column alignments according to screen width and device orientation.
class ResponsiveContentContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContentContainer({
    super.key,
    required this.child,
    this.maxWidth = 1000,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.isDesktop(context);
    final isTablet = ResponsiveBreakpoints.isTablet(context);

    final horizontalPadding = isDesktop
        ? 32.0
        : isTablet
            ? 24.0
            : 16.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isDesktop ? 24.0 : 12.0,
          ),
          child: child,
        ),
      ),
    );
  }
}

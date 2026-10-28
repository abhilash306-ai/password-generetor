import 'package:flutter/material.dart';

/// Experiment 3: Responsive UI Breakpoints & Media Query Helpers
enum DeviceScreenType { mobile, tablet, desktop }

class ResponsiveBreakpoints {
  static const double mobileMax = 650;
  static const double tabletMax = 1050;

  static DeviceScreenType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMax) return DeviceScreenType.mobile;
    if (width < tabletMax) return DeviceScreenType.tablet;
    return DeviceScreenType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMax && width < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
}

/// Experiment 3b: Responsive Layout Builder using LayoutBuilder & Breakpoints
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.tabletMax) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ResponsiveBreakpoints.mobileMax) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

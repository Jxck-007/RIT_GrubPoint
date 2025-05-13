import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    return ResponsiveBreakpoints.of(context).largerThan(MOBILE)
        ? ResponsiveBreakpoints.of(context).largerThan(TABLET)
            ? desktop ?? tablet ?? mobile
            : tablet ?? mobile
        : mobile;
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? ResponsiveBreakpoints.of(context).largerThan(TABLET)
              ? desktopPadding ?? tabletPadding ?? const EdgeInsets.all(16.0)
              : tabletPadding ?? const EdgeInsets.all(24.0)
          : mobilePadding ?? const EdgeInsets.all(16.0),
      child: child,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileCrossAxisCount;
  final int? tabletCrossAxisCount;
  final int? desktopCrossAxisCount;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileCrossAxisCount,
    this.tabletCrossAxisCount,
    this.desktopCrossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? ResponsiveBreakpoints.of(context).largerThan(TABLET)
              ? desktopCrossAxisCount ?? 4
              : tabletCrossAxisCount ?? 3
          : mobileCrossAxisCount ?? 2,
      childAspectRatio: childAspectRatio ?? 1.0,
      crossAxisSpacing: crossAxisSpacing ?? 10.0,
      mainAxisSpacing: mainAxisSpacing ?? 10.0,
      children: children,
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextStyle? desktopStyle;
  final TextAlign? textAlign;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileStyle,
    this.tabletStyle,
    this.desktopStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
          ? ResponsiveBreakpoints.of(context).largerThan(TABLET)
              ? desktopStyle ?? tabletStyle ?? style
              : tabletStyle ?? style
          : mobileStyle ?? style,
      textAlign: textAlign,
    );
  }
} 
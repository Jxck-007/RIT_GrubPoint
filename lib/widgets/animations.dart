import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeIn,
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class ScaleInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;
  final double end;

  const ScaleInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeIn,
    this.begin = 0.8,
    this.end = 1.0,
  });

  @override
  State<ScaleInWidget> createState() => _ScaleInWidgetState();
}

class _ScaleInWidgetState extends State<ScaleInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class SlideInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;

  const SlideInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeIn,
    this.begin = const Offset(0.0, 0.1),
    this.end = Offset.zero,
  });

  @override
  State<SlideInWidget> createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingSpinner({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
} 
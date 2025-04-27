import 'package:flutter/material.dart';

/// A utility class to show toast messages without relying on external packages
class ToastUtil {
  /// Shows a toast message at the bottom of the screen
  static void showToast(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  /// Shows a toast message at the bottom of the screen using SnackBar
  static void showSnackBarToast(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 50, right: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  /// Shows a toast message with custom position
  static void showCustomToast(
    BuildContext context, {
    required String message,
    required Alignment alignment,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                message,
                style: TextStyle(color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
} 
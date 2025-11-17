import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    required this.child,
    this.appBar,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: appBar != null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF), Color(0xFFFFF7ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}

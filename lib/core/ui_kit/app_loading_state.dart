import 'dart:ui';
import 'package:flutter/material.dart';

class AppLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? logo; // Masukkan Widget Logo kamu di sini

  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          // 1. Frosted Glass Effect
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10 * value,
                  sigmaY: 10 * value,
                ),
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 0.1 * value),
                ),
              );
            },
          ),

          // 2. Pulsing Logo / Icon
          Center(
            child: _PulsingLoader(
              child:
                  logo ??
                  Icon(
                    Icons.label_important, // Ganti dengan logo FocusFlow-mu
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),

          // 3. Ultra-thin Top Progress Bar (Optional tapi keren)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              minHeight: 3,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ],
    );
  }
}

/// Helper untuk animasi denyut logo
class _PulsingLoader extends StatefulWidget {
  final Widget child;
  const _PulsingLoader({required this.child});

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

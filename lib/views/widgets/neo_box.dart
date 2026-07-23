import 'package:flutter/material.dart';
import 'package:planit/core/theme/app_colors.dart';

/// A bordered container with a hard offset shadow — the core neo-brutalist
/// building block used across the app.
class NeoBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Offset shadowOffset;
  final Color? borderColor;

  const NeoBox({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.radius = AppStyles.radius,
    this.shadowOffset = const Offset(4, 4),
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: AppStyles.border(color: borderColor),
        boxShadow: AppStyles.shadow(offset: shadowOffset),
      ),
      child: child,
    );
  }
}

/// A tappable neo-brutalist surface that "presses in" (drops onto its shadow)
/// while held, giving a satisfying chunky feel.
class NeoButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Offset shadowOffset;

  const NeoButton({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.padding,
    this.radius = AppStyles.radius,
    this.shadowOffset = const Offset(4, 4),
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? Offset.zero : widget.shadowOffset;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          _pressed ? widget.shadowOffset.dx : 0,
          _pressed ? widget.shadowOffset.dy : 0,
          0,
        ),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(widget.radius),
          border: AppStyles.border(),
          boxShadow: AppStyles.shadow(offset: offset),
        ),
        child: widget.child,
      ),
    );
  }
}

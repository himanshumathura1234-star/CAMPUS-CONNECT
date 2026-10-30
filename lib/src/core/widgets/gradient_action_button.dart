import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientActionButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LinearGradient gradient;
  final double height;
  final double? width;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;

  const GradientActionButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.gradient = AppColors.primaryGradient,
    this.height = 48,
    this.width,
    this.borderRadius = 18,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  State<GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<GradientActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) _controller.reverse();
  }

  void _onTapCancel() {
    if (widget.onPressed != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: isDisabled ? null : _onTapDown,
        onTapUp: isDisabled ? null : _onTapUp,
        onTapCancel: isDisabled ? null : _onTapCancel,
        onTap: widget.onPressed,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade500],
                  )
                : widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: widget.gradient.colors.first.withValues(alpha: 0.32),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: widget.width != null && widget.width! < 120 ? 8 : 16,
          ),
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: widget.height < 40 ? 14 : 18),
                      SizedBox(width: widget.height < 40 ? 4 : 8),
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: widget.textStyle ??
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: widget.height < 40 ? 12 : 14,
                              letterSpacing: 0.2,
                            ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

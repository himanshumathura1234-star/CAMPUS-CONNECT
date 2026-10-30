import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'bouncy_card.dart';

/// ---------------------------------------------------------------------------
/// A. LARGE HERO CARD
/// Large rounded corners, rich gradient backgrounds, bold typography,
/// decorative abstract shapes, and a prominent call-to-action button.
/// ---------------------------------------------------------------------------
class LargeHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final IconData? badgeIcon;
  final String ctaLabel;
  final VoidCallback? onCtaPressed;
  final VoidCallback? onTap;
  final LinearGradient gradient;
  final Widget? trailingIllustration;
  final List<Widget>? footerWidgets;
  final double height;

  const LargeHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeIcon,
    required this.ctaLabel,
    this.onCtaPressed,
    this.onTap,
    this.gradient = AppColors.heroGradient,
    this.trailingIllustration,
    this.footerWidgets,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyCard(
      onTap: onTap ?? onCtaPressed,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppColors.glowShadow(gradient.colors.first),
        ),
        child: Stack(
          children: [
            // Decorative Abstract Shapes
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: -40,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldenYellow.withValues(alpha: 0.22),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: -20,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Badge & Optional Trailing Illustration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (badgeIcon != null) ...[
                                Icon(badgeIcon, size: 13, color: Colors.white),
                                const SizedBox(width: 5),
                              ],
                              Text(
                                badgeText!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (trailingIllustration != null) trailingIllustration!,
                    ],
                  ),

                  // Middle: Title & Subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Row: CTA Button & Footer Widgets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (footerWidgets != null && footerWidgets!.isNotEmpty)
                        Row(children: footerWidgets!)
                      else
                        const SizedBox.shrink(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onCtaPressed ?? onTap,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppColors.softShadow(Colors.black, blur: 8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ctaLabel,
                                  style: TextStyle(
                                    color: gradient.colors.first,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: gradient.colors.first,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// B. FLOATING LAYERED CARD
/// Multi-depth card featuring overlapping visual chips, avatar groups,
/// and layered statistic tags with prominent hierarchy.
/// ---------------------------------------------------------------------------
class FloatingLayeredCard extends StatelessWidget {
  final Widget child;
  final Widget? floatingTopChip;
  final Widget? floatingBottomChip;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;

  const FloatingLayeredCard({
    super.key,
    required this.child,
    this.floatingTopChip,
    this.floatingBottomChip,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BouncyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.pureWhite),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: borderColor ?? (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                width: 1.2,
              ),
              boxShadow: AppColors.softShadow(Colors.black, blur: 14, offset: const Offset(0, 4)),
            ),
            child: child,
          ),
          if (floatingTopChip != null)
            Positioned(
              top: -12,
              right: 18,
              child: floatingTopChip!,
            ),
          if (floatingBottomChip != null)
            Positioned(
              bottom: -12,
              left: 18,
              child: floatingBottomChip!,
            ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// C. IMAGE-FIRST CARD
/// Large cover image with rounded corners, dark gradient overlay for high contrast,
/// status/category badges, and action callbacks.
/// ---------------------------------------------------------------------------
class ImageFirstCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? category;
  final Color categoryColor;
  final String? topBadgeText;
  final IconData? topBadgeIcon;
  final Color? topBadgeColor;
  final Widget? actionButton;
  final VoidCallback? onTap;
  final double imageHeight;
  final Widget? extraContent;

  const ImageFirstCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.category,
    this.categoryColor = AppColors.coral,
    this.topBadgeText,
    this.topBadgeIcon,
    this.topBadgeColor,
    this.actionButton,
    this.onTap,
    this.imageHeight = 140,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BouncyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            width: 1.2,
          ),
          boxShadow: AppColors.softShadow(Colors.black, blur: 12, offset: const Offset(0, 4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with gradient overlay
            Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      height: imageHeight,
                      color: AppColors.peach.withValues(alpha: 0.35),
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 40, color: AppColors.coral),
                      ),
                    ),
                  ),
                ),
                // Gradient Scrim for contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                // Top Category & Status Pills
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppColors.softShadow(Colors.black),
                          ),
                          child: Text(
                            category!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (topBadgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: (topBadgeColor ?? Colors.black).withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (topBadgeIcon != null) ...[
                                Icon(topBadgeIcon, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                topBadgeText!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Bottom Title Overlay
                Positioned(
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Colors.black87, blurRadius: 6),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Body
            if (subtitle != null || extraContent != null || actionButton != null)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null) ...[
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (extraContent != null) ...[
                      extraContent!,
                      const SizedBox(height: 12),
                    ],
                    if (actionButton != null) actionButton!,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// D. DARK PREMIUM CARD
/// Deep charcoal background with gold/coral/emerald lighting, large statistics,
/// and glowing achievement aesthetic.
/// ---------------------------------------------------------------------------
class DarkPremiumCard extends StatelessWidget {
  final String title;
  final String statValue;
  final String statLabel;
  final IconData icon;
  final Color accentColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const DarkPremiumCard({
    super.key,
    required this.title,
    required this.statValue,
    required this.statLabel,
    required this.icon,
    this.accentColor = AppColors.goldenYellow,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1C1A), // Deep warm charcoal
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.15),
              blurRadius: 16,
              spreadRadius: -2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                      ),
                      child: Icon(icon, color: accentColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  statValue,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11.5,
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// E. GLASS-STYLE CARD
/// Translucent surface with fine frosted border, controlled contrast, and subtle blur.
/// ---------------------------------------------------------------------------
class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double blurSigma;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.all(16),
    this.blurSigma = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BouncyCard(
      onTap: onTap,
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.65),
              borderRadius: borderRadius,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// F. COMPACT INTERACTIVE CARD / TILE
/// Modern small category card with vibrant icon, clean typography,
/// and tactile scaling active feedback.
/// ---------------------------------------------------------------------------
class CompactFeatureTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const CompactFeatureTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: textColor.withValues(alpha: 0.22),
            width: 1.2,
          ),
          boxShadow: AppColors.softShadow(Colors.black, blur: 6, offset: const Offset(0, 2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                boxShadow: AppColors.softShadow(Colors.black, blur: 4),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';

class FlowScaffold extends StatelessWidget {
  const FlowScaffold({
    required this.child,
    super.key,
    this.title,
    this.onBack,
    this.footer,
    this.trailing,
    this.scrollable = false,
    this.horizontalPadding = 24,
  });

  final Widget child;
  final String? title;
  final VoidCallback? onBack;
  final Widget? footer;
  final Widget? trailing;
  final bool scrollable;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
      child: child,
    );
    if (scrollable) {
      content = SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (title != null)
              SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      if (onBack != null)
                        GestureDetector(
                          onTap: onBack,
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Text(
                              '←',
                              style: TextStyle(
                                color: WellLessColors.muted,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title!,
                          style: const TextStyle(
                            color: WellLessColors.muted,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                      ?trailing,
                    ],
                  ),
                ),
              ),
            Expanded(child: content),
            if (footer != null)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: WellLessColors.divider),
                  ),
                ),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.enabled = true,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor ?? WellLessColors.primary,
          disabledBackgroundColor: WellLessColors.surfaceRaised,
          foregroundColor: WellLessColors.text,
          disabledForegroundColor: WellLessColors.dim,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: condensed(
            size: 14,
            weight: FontWeight.w700,
            color: enabled ? Colors.white : WellLessColors.dim,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class SmallPill extends StatelessWidget {
  const SmallPill(
    this.label, {
    super.key,
    this.active = false,
    this.green = false,
  });

  final String label;
  final bool active;
  final bool green;

  @override
  Widget build(BuildContext context) {
    final color = green
        ? WellLessColors.success
        : active
        ? WellLessColors.primary
        : WellLessColors.dim;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: condensed(size: 9, weight: FontWeight.w600, color: color),
      ),
    );
  }
}

class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow(this.text, {super.key, this.color = WellLessColors.dim});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: condensed(
      size: 11,
      weight: FontWeight.w700,
      color: color,
      letterSpacing: 2.1,
    ),
  );
}

class ProductBottle extends StatelessWidget {
  const ProductBottle({super.key, this.size = 76});

  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/aac_serum_bottle.png',
    width: size,
    height: size,
    fit: BoxFit.contain,
  );
}

class MetricBar extends StatelessWidget {
  const MetricBar(this.label, this.value, this.reference, {super.key});

  final String label;
  final double value;
  final double reference;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 19),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: WellLessColors.text),
        ),
        const SizedBox(height: 4),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value,
          child: Container(
            height: 7,
            decoration: BoxDecoration(
              color: WellLessColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 3),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: reference,
          child: Container(
            height: 7,
            decoration: BoxDecoration(
              color: WellLessColors.dim,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'dart:async';

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

class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.98),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.98, end: 1.0),
          weight: 50,
        ),
      ],
    ).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeInOut));

    _arrowAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 4.0),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 4.0, end: 0.0),
          weight: 50,
        ),
      ],
    ).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    _tapController.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.enabled
        ? (widget.backgroundColor ?? WellLessColors.primary)
        : WellLessColors.surfaceRaised;

    final textColor = widget.enabled ? Colors.white : WellLessColors.dim;

    final labelText = widget.label;
    Widget buttonContent;
    if (labelText.endsWith('→')) {
      final textWithoutArrow = labelText
          .substring(0, labelText.length - 1)
          .trim();
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(textWithoutArrow),
          AnimatedBuilder(
            animation: _tapController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_arrowAnimation.value, 0.0),
                child: const Text(' →'),
              );
            },
          ),
        ],
      );
    } else {
      buttonContent = Text(labelText);
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedScale(
        scale: widget.enabled ? 1.0 : 0.985,
        duration: const Duration(milliseconds: 250),
        curve: const Cubic(0.22, 1.0, 0.36, 1.0),
        child: SizedBox(
          width: double.infinity,
          height: 53,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: const Cubic(0.22, 1.0, 0.36, 1.0),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: FilledButton(
              onPressed: widget.enabled ? _handleTap : null,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                foregroundColor: WellLessColors.text,
                disabledForegroundColor: WellLessColors.dim,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: condensed(
                  size: 14,
                  weight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: 1.5,
                ),
                child: buttonContent,
              ),
            ),
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

class MetricBar extends StatefulWidget {
  const MetricBar(
    this.label,
    this.value,
    this.reference, {
    this.delay = Duration.zero,
    super.key,
  });

  final String label;
  final double value;
  final double reference;
  final Duration delay;

  @override
  State<MetricBar> createState() => _MetricBarState();
}

class _MetricBarState extends State<MetricBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _labelOpacity;
  late final Animation<double> _redWidth;
  late final Animation<double> _grayWidth;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _labelOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _redWidth =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: widget.value * 0.97,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 85,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: widget.value * 0.97,
              end: widget.value,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 15,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
        );

    _grayWidth = Tween<double>(begin: 0.0, end: widget.reference).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.63, curve: Curves.easeOut),
      ),
    );

    _timer = Timer(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: _labelOpacity.value,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: WellLessColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _redWidth.value,
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
                widthFactor: _grayWidth.value,
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
      },
    );
  }
}

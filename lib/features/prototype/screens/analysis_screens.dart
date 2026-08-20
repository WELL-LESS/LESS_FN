import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/mock_data.dart';
import 'package:well_less_app/features/prototype/widgets.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({
    required this.onBack,
    required this.onAnalyze,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onAnalyze;

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> with SingleTickerProviderStateMixin {
  late final List<RoutineProduct> _items;
  late final AnimationController _entranceController;

  int? _draggingIndex;
  double _dragOffset = 0.0;
  final Set<String> _activeProductNames = {'MISSHA 타임 레볼루션'};

  @override
  void initState() {
    super.initState();
    _items = List.from(routineProducts);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  double _getEntranceProgress(int index) {
    final start = 0.15 + index * 0.10;
    final end = (start + 0.35).clamp(0.0, 1.0);
    final val = (_entranceController.value - start) / (end - start);
    return val.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'AI 루틴 분석',
      onBack: widget.onBack,
      horizontalPadding: 16,
      footer: PrimaryButton(label: '피부 적합도 분석 →', onPressed: widget.onAnalyze),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 14, 8, 8),
            child: Text(
              '사용자님의 루틴을 분석했습니다.\n만약 다르다면, 드래그를 통해 순서를 바꿀 수 있습니다.',
              style: TextStyle(
                fontSize: 12,
                color: WellLessColors.dim,
                height: 1.65,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: _draggingIndex != null ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              child: AnimatedBuilder(
                animation: _entranceController,
                builder: (context, _) {
                  return SizedBox(
                    height: _items.length * 108.0 + 60.0,
                    child: Stack(
                      children: [
                        // Serpentine items
                        for (int i = 0; i < _items.length; i++) _buildItem(i),
                        
                        // Footer label
                        Positioned(
                          left: 0,
                          right: 0,
                          top: _items.length * 108.0 + 16,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _entranceController,
                              builder: (context, child) {
                                final prog = _getEntranceProgress(_items.length);
                                return Opacity(
                                  opacity: prog,
                                  child: child,
                                );
                              },
                              child: const Text(
                                'ROUTINE END',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: WellLessColors.faint,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final product = _items[index];
    final isDragging = (_draggingIndex == index);
    final active = _activeProductNames.contains(product.name);
    final left = index.isEven;
    
    // Staggered values
    final prog = _getEntranceProgress(index);
    final isStaged = prog > 0.0;
    
    double scale = 1.0;
    if (!isDragging) {
      if (prog < 0.75) {
        scale = 0.96 + (prog / 0.75) * (1.03 - 0.96);
      } else {
        scale = 1.03 - ((prog - 0.75) / 0.25) * 0.03;
      }
    } else {
      scale = 1.04;
    }
    
    final opacity = isDragging ? 1.0 : prog;
    final double baseTop = index * 108.0;
    final double currentTop = baseTop + (isDragging ? _dragOffset : 0.0);
    
    final card = GestureDetector(
      onTap: () {
        setState(() {
          if (_activeProductNames.contains(product.name)) {
            _activeProductNames.remove(product.name);
          } else {
            _activeProductNames.add(product.name);
          }
        });
      },
      onVerticalDragStart: (details) {
        setState(() {
          _draggingIndex = index;
          _dragOffset = 0.0;
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dy;
          final newY = index * 108.0 + _dragOffset;
          final targetIndex = (newY / 108.0).round().clamp(0, _items.length - 1);
          if (targetIndex != _draggingIndex) {
            final item = _items.removeAt(_draggingIndex!);
            _items.insert(targetIndex, item);
            _dragOffset += (_draggingIndex! - targetIndex) * 108.0;
            _draggingIndex = targetIndex;
          }
        });
      },
      onVerticalDragEnd: (details) {
        setState(() {
          _draggingIndex = null;
          _dragOffset = 0.0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 130,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
        decoration: BoxDecoration(
          color: active
              ? WellLessColors.primary.withValues(alpha: 0.07)
              : WellLessColors.surface,
          border: Border.all(
            color: active ? WellLessColors.primary : (isDragging ? Colors.white : WellLessColors.border),
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: left ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: left ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: active ? WellLessColors.primary : WellLessColors.text,
                fontSize: 11,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            SmallPill(product.category, active: active),
            const SizedBox(height: 5),
            Text(
              product.description,
              style: const TextStyle(fontSize: 9, color: WellLessColors.faint),
            ),
          ],
        ),
      ),
    );

    final numberNode = Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: active ? 36 : 28,
          height: active ? 36 : 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? WellLessColors.primary : WellLessColors.surface,
            border: Border.all(
              color: active ? WellLessColors.primary : WellLessColors.faint,
            ),
            shape: BoxShape.circle,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: WellLessColors.primary.withValues(alpha: 0.3),
                      blurRadius: 7,
                    ),
                  ]
                : null,
          ),
          child: Text(
            '${index + 1}',
            style: condensed(
              size: active ? 16 : 12,
              weight: FontWeight.w900,
              color: active ? Colors.white : WellLessColors.faint,
            ),
          ),
        ),
        if (index != _items.length - 1)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SvgPicture.asset(
              left ? 'assets/icons/routine_left.svg' : 'assets/icons/routine_right.svg',
              key: ValueKey(left),
              width: 48,
              height: 45,
              fit: BoxFit.fill,
            ),
          ),
      ],
    );

    return AnimatedPositioned(
      duration: isDragging ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      left: 0,
      right: 0,
      top: currentTop,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final centerX = width / 2;
              return SizedBox(
                height: 108,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Node circle in the center
                    Positioned(
                      left: centerX - 24,
                      top: 0,
                      child: numberNode,
                    ),
                    
                    // Card sliding horizontally
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      left: left ? null : centerX + 24 + 18,
                      right: left ? centerX + 24 + 18 : null,
                      top: 0,
                      child: card,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SuitabilityScreen extends StatefulWidget {
  const SuitabilityScreen({
    required this.replacementSelected,
    required this.onBack,
    required this.onReplacement,
    required this.onFinal,
    super.key,
  });

  final bool replacementSelected;
  final VoidCallback onBack;
  final VoidCallback onReplacement;
  final VoidCallback onFinal;

  @override
  State<SuitabilityScreen> createState() => _SuitabilityScreenState();
}

class _SuitabilityScreenState extends State<SuitabilityScreen> with TickerProviderStateMixin {
  bool _comparisonVisible = false;
  bool _removedSecond = false;
  
  double _card2Scale = 1.0;
  double _card2Opacity = 1.0;
  double _card2TranslateX = 0.0;
  bool _card2FullyRemoved = false;

  late final AnimationController _entranceController;
  late final AnimationController _comparisonController;

  late final Animation<double> _orbProgress;
  late final Animation<double> _badgeProgress;
  late final Animation<double> _removeTitleProgress;
  late final Animation<double> _card1Progress;
  late final Animation<double> _card2Progress;
  late final Animation<double> _ctaProgress;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _comparisonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _orbProgress = Tween<double>(begin: 0.0, end: 0.68).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)),
    );
    _badgeProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.5, 0.68, curve: Curves.easeOutBack)),
    );
    _removeTitleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.55, 0.70, curve: Curves.easeOut)),
    );
    _card1Progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.65, 0.82, curve: Curves.easeOut)),
    );
    _card2Progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.75, 0.92, curve: Curves.easeOut)),
    );
    _ctaProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.85, 1.0, curve: Curves.easeOut)),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _comparisonController.dispose();
    super.dispose();
  }

  void _triggerRemoveSecond() {
    setState(() {
      _card2Scale = 0.97;
      _card2Opacity = 0.4;
    });
    Future.delayed(const Duration(milliseconds: 220), () {
      setState(() {
        _card2TranslateX = -8.0;
        _card2Opacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 180), () {
        setState(() {
          _card2FullyRemoved = true;
          _removedSecond = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: '피부 적합도 분석 결과',
      onBack: widget.onBack,
      footer: AnimatedBuilder(
        animation: _entranceController,
        builder: (context, child) {
          return Opacity(
            opacity: _ctaProgress.value,
            child: Transform.translate(
              offset: Offset(0.0, (1.0 - _ctaProgress.value) * 10.0),
              child: child,
            ),
          );
        },
        child: PrimaryButton(label: '최종 루틴 확인하러 가기 →', onPressed: widget.onFinal),
      ),
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          
          // Header / Score Summary
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, _) => _ScoreSummary(
              orbProgress: _orbProgress.value,
              badgeProgress: _badgeProgress.value,
              entranceController: _entranceController,
            ),
          ),
          const SizedBox(height: 28),
          const Divider(height: 1, color: WellLessColors.border),
          const SizedBox(height: 16),
          
          // REMOVE Title Banner
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, _) {
              final val = _removeTitleProgress.value;
              return Opacity(
                opacity: val,
                child: Transform.translate(
                  offset: Offset((1.0 - val) * -8.0, 0.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 12, bottom: 2),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: WellLessColors.primary, width: 3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REMOVE',
                          style: condensed(
                            size: 38,
                            weight: FontWeight.w900,
                            color: WellLessColors.primary,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          '아래 항목들은 덜어내는 것을 권장드립니다.',
                          style: TextStyle(fontSize: 10, color: WellLessColors.dim),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          
          // Global comparison panel removed to favor inline card expansion
            
          // Product Card 1
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, _) {
              final val = _card1Progress.value;
              return Opacity(
                opacity: val,
                child: Transform.translate(
                  offset: Offset(0.0, (1.0 - val) * 12.0),
                  child: Transform.scale(
                    scale: 0.97 + val * 0.03,
                    child: _RemoveProductCard(
                      selectedReplacement: widget.replacementSelected,
                      onRemove: () {},
                      onReplace: () {
                        if (!widget.replacementSelected) widget.onReplacement();
                        setState(() {
                          _comparisonVisible = true;
                          _comparisonController.forward(from: 0.0);
                        });
                      },
                      cardProgress: val,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          
          // Product Card 2
          if (!_card2FullyRemoved)
            AnimatedBuilder(
              animation: _entranceController,
              builder: (context, _) {
                final val = _card2Progress.value;
                return Opacity(
                  opacity: val * _card2Opacity,
                  child: Transform.translate(
                    offset: Offset(_card2TranslateX, (1.0 - val) * 12.0),
                    child: Transform.scale(
                      scale: (0.97 + val * 0.03) * _card2Scale,
                      child: _RemoveProductCard(
                        removed: _removedSecond,
                        onRemove: _triggerRemoveSecond,
                        onReplace: () {
                          if (!widget.replacementSelected) widget.onReplacement();
                          setState(() {
                            _comparisonVisible = true;
                            _comparisonController.forward(from: 0.0);
                          });
                        },
                        cardProgress: val,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary({
    required this.orbProgress,
    required this.badgeProgress,
    required this.entranceController,
  });

  final double orbProgress;
  final double badgeProgress;
  final AnimationController entranceController;

  @override
  Widget build(BuildContext context) {
    final countVal = (orbProgress * 100).round();
    
    double scoreScale = 1.0;
    if (entranceController.value >= 0.55) {
      final popVal = ((entranceController.value - 0.55) / 0.1).clamp(0.0, 1.0);
      if (popVal < 0.5) {
        scoreScale = 1.0 + (popVal / 0.5) * 0.05;
      } else {
        scoreScale = 1.05 - ((popVal - 0.5) / 0.5) * 0.05;
      }
    }

    return Row(
      children: [
        _BlurredScoreOrb(progress: orbProgress),
        const SizedBox(width: 26),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '사용자님의 루틴 점수는',
                style: TextStyle(
                  fontSize: 11,
                  color: WellLessColors.dim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Transform.scale(
                scale: scoreScale,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$countVal',
                        style: scoreNumber(size: 52, height: 0.95),
                      ),
                      TextSpan(
                        text: '%',
                        style: condensed(
                          size: 22,
                          weight: FontWeight.w900,
                          color: WellLessColors.dim,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                '8개 제품 중 2개 부적합',
                style: TextStyle(fontSize: 11, color: WellLessColors.faint),
              ),
              const SizedBox(height: 7),
              Opacity(
                opacity: badgeProgress.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.9 + badgeProgress.clamp(0.0, 1.0) * 0.1,
                  child: const SmallPill('주의 필요', active: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlurredScoreOrb extends StatelessWidget {
  const _BlurredScoreOrb({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 127,
    height: 127,
    child: CustomPaint(painter: _ScoreRingPainter(progress: progress)),
  );
}

class _ScoreRingPainter extends CustomPainter {
  const _ScoreRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.37;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -1.5707963267948966;
    final sweepAngle = 6.283185307179586 * progress;
    final endAngle = startAngle + (sweepAngle > 0.0 ? sweepAngle : 0.0001);
    final sectorShader = SweepGradient(
      center: Alignment.center,
      startAngle: startAngle,
      endAngle: endAngle,
      colors: const [
        Color(0xFFD91820), // Darker red at the start
        Color(0xFFFF3B30), // Mid-red
        Color(0xFFFF9500), // Vibrant orange-yellow at leading tip
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);

    final track = Paint()..color = const Color(0xFF0E0E0E);
    canvas.drawCircle(center, radius, track);

    if (sweepAngle > 0.0) {
      final outerGlow = Paint()
        ..color = const Color(0xFFFF5E00).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(rect, startAngle, sweepAngle, true, outerGlow);

      final sector = Paint()
        ..shader = sectorShader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4);
      canvas.drawArc(rect, startAngle, sweepAngle, true, sector);

      final innerGlow = Paint()
        ..color = const Color(0xFFFF342E).withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.88),
        startAngle,
        sweepAngle,
        true,
        innerGlow,
      );

      final edge = Paint()
        ..color = const Color(0xFFFF4238).withValues(alpha: 0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawArc(rect, startAngle, sweepAngle, false, edge);
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _RemoveProductCard extends StatefulWidget {
  const _RemoveProductCard({
    required this.onRemove,
    required this.onReplace,
    this.selectedReplacement = false,
    this.removed = false,
    required this.cardProgress,
  });

  final VoidCallback onRemove;
  final VoidCallback onReplace;
  final bool selectedReplacement;
  final bool removed;
  final double cardProgress;

  @override
  State<_RemoveProductCard> createState() => _RemoveProductCardState();
}

class _RemoveProductCardState extends State<_RemoveProductCard> {
  double _scale = 1.0;
  bool _expanded = false;

  @override
  void didUpdateWidget(covariant _RemoveProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedReplacement != oldWidget.selectedReplacement) {
      if (widget.selectedReplacement) {
        _expanded = true;
      }
    }
  }

  void _handleTap() {
    setState(() {
      _expanded = !_expanded;
      _scale = 1.015;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _scale = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedReplacement || widget.removed;
    final selectedColor = widget.selectedReplacement
        ? WellLessColors.success
        : WellLessColors.primary;
        
    // Score count-up logic
    final double innerVal = widget.cardProgress;
    final scoreValue = widget.selectedReplacement ? 86 : 22;
    final scoreCount = (innerVal * scoreValue).round();
    
    // Scale pop for scores
    double scoreScale = 1.0;
    if (innerVal >= 0.8) {
      final p = (innerVal - 0.8) / 0.2;
      scoreScale = 1.0 + (p * (1.0 - p)) * 0.28;
    }

    return GestureDetector(
      onTap: _handleTap,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: widget.selectedReplacement
                ? WellLessColors.successSurface
                : selected
                ? selectedColor.withValues(alpha: 0.06)
                : Colors.transparent,
            border: Border.all(
              color: selected
                  ? selectedColor.withValues(alpha: 0.26)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Image reveal
                    Opacity(
                      opacity: (innerVal - 0.15).clamp(0.0, 1.0),
                      child: const ProductBottle(size: 70),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 2. Name & tag reveal
                              Expanded(
                                child: Opacity(
                                  opacity: (innerVal - 0.3).clamp(0.0, 1.0),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      final isIncoming = child.key == ValueKey(widget.selectedReplacement);
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(0.0, isIncoming ? 0.05 : -0.05),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: FadeTransition(opacity: animation, child: child),
                                      );
                                    },
                                    child: widget.selectedReplacement
                                        ? Column(
                                            key: const ValueKey(true),
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "AAC 세이프 BHA 세럼",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              const SizedBox(height: 2),
                                              SmallPill('세럼', active: true, green: true),
                                            ],
                                          )
                                        : Column(
                                            key: const ValueKey(false),
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Paula's Choice BHA 2%",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              const SizedBox(height: 2),
                                              const SmallPill('세럼'),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              
                              // 3. Score count-up and scale pop
                              Opacity(
                                opacity: (innerVal - 0.45).clamp(0.0, 1.0),
                                child: Transform.scale(
                                  scale: scoreScale,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$scoreCount',
                                        style: scoreNumber(
                                          size: 36,
                                          color: selectedColor,
                                        ),
                                      ),
                                      Text(
                                        '/100',
                                        style: condensed(
                                          size: 11,
                                          color: widget.selectedReplacement
                                              ? WellLessColors.success.withValues(alpha: 0.5)
                                              : const Color(0xFF7A241C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          
                          // 4. Description reveal
                          Opacity(
                            opacity: (innerVal - 0.55).clamp(0.0, 1.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: widget.selectedReplacement
                                  ? const Text(
                                      '유기유황성분이 사용자의 민감성을 회복하도록 도와주며,\n피부 장벽 복구 확률이 높습니다.',
                                      key: ValueKey(true),
                                      style: TextStyle(fontSize: 10, height: 1.55),
                                    )
                                  : const Text(
                                      '고농도 살리실산이 사용자의 민감성을 더욱 극대화 하여,\n피부 장벽 손상 확률이 높습니다.',
                                      key: ValueKey(false),
                                      style: TextStyle(fontSize: 10, height: 1.55),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // 5. Tags reveal
                          Opacity(
                            opacity: (innerVal - 0.65).clamp(0.0, 1.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: widget.selectedReplacement
                                  ? Wrap(
                                      key: const ValueKey(true),
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: [
                                        SmallPill('유기유황 0.5%', active: true, green: true),
                                        const SmallPill('히알루론산'),
                                        const SmallPill('병풀 추출물'),
                                        const SmallPill('판테놀'),
                                      ],
                                    )
                                  : const Wrap(
                                      key: const ValueKey(false),
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: [
                                        SmallPill('살리실산', active: true),
                                        SmallPill('에탄올'),
                                        SmallPill('메틸파라벤'),
                                        SmallPill('향료'),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 6. Action buttons reveal
              Opacity(
                opacity: (innerVal - 0.75).clamp(0.0, 1.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _DecisionButton(
                        label: widget.removed ? '✓ 제거 확정' : '× 제거',
                        active: widget.removed,
                        color: WellLessColors.primary,
                        onTap: widget.onRemove,
                      ),
                    ),
                    Expanded(
                      child: _DecisionButton(
                        label: widget.selectedReplacement ? '✓ AAC 교체' : '↻ AAC 교체',
                        active: widget.selectedReplacement,
                        color: WellLessColors.success,
                        onTap: widget.onReplace,
                      ),
                    ),
                  ],
                ),
              ),

              // 7. Inline Comparison Expansion
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                child: _expanded
                    ? _IngredientComparison(
                        onClose: () => setState(() => _expanded = false),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 43,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: WellLessColors.border),
          right: BorderSide(color: WellLessColors.border),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? color : WellLessColors.dim,
        ),
      ),
    ),
  );
}

class _IngredientComparison extends StatelessWidget {
  const _IngredientComparison({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: WellLessColors.successSurface,
      border: Border.all(color: WellLessColors.success.withValues(alpha: 0.2)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '성분 비교',
                  style: TextStyle(
                    color: WellLessColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Text(
                  '×',
                  style: TextStyle(color: WellLessColors.dim),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: WellLessColors.border),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _ComparisonColumn(existing: true)),
              Container(width: 1, height: 175, color: WellLessColors.border),
              const Expanded(child: _ComparisonColumn(existing: false)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ComparisonColumn extends StatelessWidget {
  const _ComparisonColumn({required this.existing});
  final bool existing;

  @override
  Widget build(BuildContext context) {
    final color = existing ? WellLessColors.primary : WellLessColors.success;
    final items = existing
        ? ['× 살리실산 2% (고농도)', '× 에탄올 (자극)', '× 메틸파라벤', '× 향료 (알레르기)']
        : ['✓ 살리실산 0.5% (저자극)', '✓ 히알루론산', '✓ 병풀 추출물 (진정)', '✓ 판테놀 (장벽 강화)'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            existing ? '기존 제품' : 'AAC 대체 제품',
            style: TextStyle(
              fontSize: 9,
              color: existing ? WellLessColors.dim : WellLessColors.success,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            existing ? "Paula's Choice BHA 2%" : 'AAC 세이프 BHA 세럼',
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            existing ? '22/100' : '86/100',
            style: scoreNumber(size: 32, color: color),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(item, style: TextStyle(fontSize: 10, color: color)),
            ),
          ),
        ],
      ),
    );
  }
}

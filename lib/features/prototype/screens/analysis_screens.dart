import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/mock_data.dart';
import 'package:well_less_app/features/prototype/widgets.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({
    required this.onBack,
    required this.onAnalyze,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onAnalyze;

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: 'AI 루틴 분석',
    onBack: onBack,
    horizontalPadding: 16,
    footer: PrimaryButton(label: '피부 적합도 분석 →', onPressed: onAnalyze),
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                for (var index = 0; index < routineProducts.length; index++)
                  _ZigzagRoutineItem(
                    product: routineProducts[index],
                    index: index,
                    active: index == 0,
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'ROUTINE END',
                    style: TextStyle(
                      fontSize: 9,
                      color: WellLessColors.faint,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _ZigzagRoutineItem extends StatelessWidget {
  const _ZigzagRoutineItem({
    required this.product,
    required this.index,
    required this.active,
  });

  final RoutineProduct product;
  final int index;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final left = index.isEven;
    final card = Container(
      width: 130,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
      decoration: BoxDecoration(
        color: active
            ? WellLessColors.primary.withValues(alpha: 0.07)
            : WellLessColors.surface,
        border: Border.all(
          color: active ? WellLessColors.primary : WellLessColors.border,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: left
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
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
    );

    final number = Column(
      children: [
        Container(
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
        if (index != routineProducts.length - 1)
          SvgPicture.asset(
            left
                ? 'assets/icons/routine_left.svg'
                : 'assets/icons/routine_right.svg',
            width: 48,
            height: 45,
            fit: BoxFit.fill,
          ),
      ],
    );

    return SizedBox(
      height: 108,
      child: Row(
        children: left
            ? [
                Expanded(
                  child: Align(alignment: Alignment.centerRight, child: card),
                ),
                const SizedBox(width: 18),
                SizedBox(width: 48, child: number),
                const Expanded(child: SizedBox()),
              ]
            : [
                const Expanded(child: SizedBox()),
                SizedBox(width: 48, child: number),
                const SizedBox(width: 18),
                Expanded(
                  child: Align(alignment: Alignment.centerLeft, child: card),
                ),
              ],
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

class _SuitabilityScreenState extends State<SuitabilityScreen> {
  bool _comparisonVisible = false;
  bool _removedSecond = false;

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '피부 적합도 분석 결과',
    onBack: widget.onBack,
    footer: PrimaryButton(label: '최종 루틴 확인하러 가기 →', onPressed: widget.onFinal),
    scrollable: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const _ScoreSummary(),
        const SizedBox(height: 28),
        const Divider(height: 1, color: WellLessColors.border),
        const SizedBox(height: 16),
        Container(
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
        const SizedBox(height: 12),
        if (_comparisonVisible)
          _IngredientComparison(
            onClose: () => setState(() => _comparisonVisible = false),
          ),
        _RemoveProductCard(
          selectedReplacement: widget.replacementSelected,
          onRemove: () => setState(() => _removedSecond = true),
          onReplace: () {
            if (!widget.replacementSelected) widget.onReplacement();
            setState(() => _comparisonVisible = true);
          },
        ),
        const SizedBox(height: 14),
        _RemoveProductCard(
          removed: _removedSecond,
          onRemove: () => setState(() => _removedSecond = true),
          onReplace: () {
            if (!widget.replacementSelected) widget.onReplacement();
            setState(() => _comparisonVisible = true);
          },
        ),
      ],
    ),
  );
}

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const _BlurredScoreOrb(),
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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '68',
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
            const Text(
              '8개 제품 중 2개 부적합',
              style: TextStyle(fontSize: 11, color: WellLessColors.faint),
            ),
            const SizedBox(height: 7),
            const SmallPill('주의 필요', active: true),
          ],
        ),
      ),
    ],
  );
}

class _BlurredScoreOrb extends StatelessWidget {
  const _BlurredScoreOrb();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 127,
    height: 127,
    child: CustomPaint(painter: _ScoreRingPainter(progress: 0.68)),
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
    final sectorShader = const RadialGradient(
      center: Alignment(-0.12, -0.08),
      radius: 0.9,
      colors: [Color(0xFFFF4338), Color(0xFFF52C29), Color(0xFFD91820)],
      stops: [0, 0.62, 1],
    ).createShader(rect);

    final track = Paint()..color = const Color(0xFF0E0E0E);
    canvas.drawCircle(center, radius, track);

    final outerGlow = Paint()
      ..color = const Color(0xFFE51F27).withValues(alpha: 0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawArc(rect, startAngle, sweepAngle, true, outerGlow);

    final sector = Paint()
      ..shader = sectorShader
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4);
    canvas.drawArc(rect, startAngle, sweepAngle, true, sector);

    final innerGlow = Paint()
      ..color = const Color(0xFFFF342E).withValues(alpha: 0.42)
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

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _RemoveProductCard extends StatelessWidget {
  const _RemoveProductCard({
    required this.onRemove,
    required this.onReplace,
    this.selectedReplacement = false,
    this.removed = false,
  });

  final VoidCallback onRemove;
  final VoidCallback onReplace;
  final bool selectedReplacement;
  final bool removed;

  @override
  Widget build(BuildContext context) {
    final selected = selectedReplacement || removed;
    final selectedColor = selectedReplacement
        ? WellLessColors.success
        : WellLessColors.primary;
    return Container(
      decoration: BoxDecoration(
        color: selectedReplacement
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
                const ProductBottle(size: 70),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Paula's Choice BHA 2%",
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(height: 2),
                                SmallPill('세럼'),
                              ],
                            ),
                          ),
                          Text(
                            '22',
                            style: scoreNumber(
                              size: 36,
                              color: WellLessColors.primary,
                            ),
                          ),
                          Text(
                            '/100',
                            style: condensed(
                              size: 11,
                              color: const Color(0xFF7A241C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '고농도 살리실산이 사용자의 민감성을 더욱 극대화 하여,\n피부 장벽 손상 확률이 높습니다.',
                        style: TextStyle(fontSize: 10, height: 1.55),
                      ),
                      const SizedBox(height: 8),
                      const Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          SmallPill('살리실산', active: true),
                          SmallPill('에탄올'),
                          SmallPill('메틸파라벤'),
                          SmallPill('향료'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _DecisionButton(
                  label: removed ? '✓ 제거 확정' : '× 제거',
                  active: removed,
                  color: WellLessColors.primary,
                  onTap: onRemove,
                ),
              ),
              Expanded(
                child: _DecisionButton(
                  label: selectedReplacement ? '✓ AAC 교체' : '↻ AAC 교체',
                  active: selectedReplacement,
                  color: WellLessColors.success,
                  onTap: onReplace,
                ),
              ),
            ],
          ),
        ],
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

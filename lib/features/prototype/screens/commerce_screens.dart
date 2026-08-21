import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/mock_data.dart';
import 'package:well_less_app/features/prototype/widgets.dart';

class FinalRoutineScreen extends StatefulWidget {
  const FinalRoutineScreen({
    required this.onBack,
    required this.onCart,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onCart;

  @override
  State<FinalRoutineScreen> createState() => _FinalRoutineScreenState();
}

class _FinalRoutineScreenState extends State<FinalRoutineScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  late final Animation<double> _headerOpacity;
  late final Animation<double> _headerTranslateY;
  late final Animation<double> _circleProgress;
  late final Animation<double> _checkProgress;

  late final Animation<double> _line1Progress;
  late final Animation<double> _line2Progress;
  late final Animation<double> _aacLabelProgress;
  late final Animation<double> _ctaProgress;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.12, curve: Curves.easeOut),
      ),
    );
    _headerTranslateY = Tween<double>(begin: 5.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.12, curve: Curves.easeOut),
      ),
    );

    _circleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.32, curve: Curves.easeOut),
      ),
    );
    _checkProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.22, 0.42, curve: Curves.easeOut),
      ),
    );

    _line1Progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.38, 0.54, curve: Curves.easeOut),
      ),
    );
    _line2Progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.44, 0.60, curve: Curves.easeOut),
      ),
    );

    _aacLabelProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.52, 0.68, curve: Curves.easeOut),
      ),
    );
    _ctaProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.88, 1.0, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  double _getItemProgress(int index) {
    final start = 0.56 + index * 0.055;
    final end = (start + 0.14).clamp(0.0, 1.0);
    final val = (_entranceController.value - start) / (end - start);
    return val.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: '최종 루틴',
      onBack: widget.onBack,
      trailing: GestureDetector(
        onTap: widget.onCart,
        child: const Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: WellLessColors.muted,
              size: 21,
            ),
            Positioned(
              right: -3,
              top: -4,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: WellLessColors.primary,
              ),
            ),
          ],
        ),
      ),
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
        child: PrimaryButton(label: '제품 만나보러 가기 →', onPressed: widget.onCart),
      ),
      child: AnimatedBuilder(
        animation: _entranceController,
        builder: (context, _) {
          double checkScale = 1.0;
          if (_entranceController.value >= 0.42) {
            final p = ((_entranceController.value - 0.42) / 0.08).clamp(
              0.0,
              1.0,
            );
            if (p < 0.5) {
              checkScale = 1.0 + (p / 0.5) * 0.04;
            } else {
              checkScale = 1.04 - ((p - 0.5) / 0.5) * 0.04;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Transform.scale(
                    scale: checkScale,
                    child: SizedBox(
                      width: 98,
                      height: 98,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(98, 98),
                            painter: _CheckmarkPainter(
                              circleProgress: _circleProgress.value,
                              checkProgress: _checkProgress.value,
                            ),
                          ),
                          const SizedBox(
                            width: 0,
                            height: 0,
                            child: Icon(
                              Icons.task_alt_rounded,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: _line1Progress.value,
                          child: Transform.translate(
                            offset: Offset(
                              (1.0 - _line1Progress.value) * 8.0,
                              (1.0 - _line1Progress.value) * 3.0,
                            ),
                            child: const Text(
                              '필요한 것만 남긴,',
                              style: TextStyle(
                                fontSize: 21,
                                height: 1.25,
                                color: WellLessColors.muted,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _line2Progress.value,
                          child: Transform.translate(
                            offset: Offset(
                              (1.0 - _line2Progress.value) * 8.0,
                              (1.0 - _line2Progress.value) * 3.0,
                            ),
                            child: const Text(
                              '당신을 위한 루틴이에요.',
                              style: TextStyle(
                                fontSize: 21,
                                height: 1.25,
                                color: WellLessColors.success,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Opacity(
                opacity: _aacLabelProgress.value,
                child: Transform.translate(
                  offset: Offset(0.0, (1.0 - _aacLabelProgress.value) * 5.0),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: _aacLabelProgress.value,
                        child: const CircleAvatar(
                          radius: 3,
                          backgroundColor: WellLessColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'AAC 교체 제품',
                        style: TextStyle(
                          fontSize: 11,
                          color: WellLessColors.dim,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: finalRoutineProducts.length,
                  itemBuilder: (context, index) {
                    final p = _getItemProgress(index);
                    double borderOpacity = 1.0;
                    if (index == 0 && _entranceController.value >= 0.82) {
                      final val = ((_entranceController.value - 0.82) / 0.12)
                          .clamp(0.0, 1.0);
                      borderOpacity = 1.0 - (val * (1.0 - val)) * 0.44;
                    }

                    return Opacity(
                      opacity: p,
                      child: Transform.translate(
                        offset: Offset(0.0, (1.0 - p) * 12.0),
                        child: _FinalRoutineItem(
                          product: finalRoutineProducts[index],
                          index: index,
                          selected: index == 0,
                          revealProgress: p,
                          borderOpacity: borderOpacity,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({
    required this.circleProgress,
    required this.checkProgress,
  });
  final double circleProgress;
  final double checkProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WellLessColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    if (circleProgress >= 0.99) {
      canvas.drawCircle(center, radius, paint);
    } else if (circleProgress > 0.0) {
      final path = Path()
        ..addArc(
          Rect.fromCircle(center: center, radius: radius),
          -1.570796,
          6.283185 * circleProgress,
        );
      canvas.drawPath(path, paint);
    }

    if (checkProgress > 0.0) {
      final checkPath = Path();
      final start = Offset(size.width * 0.32, size.height * 0.50);
      final corner = Offset(size.width * 0.45, size.height * 0.63);
      final end = Offset(size.width * 0.68, size.height * 0.38);

      checkPath.moveTo(start.dx, start.dy);

      if (checkProgress <= 0.35) {
        final t = checkProgress / 0.35;
        final p = Offset.lerp(start, corner, t)!;
        checkPath.lineTo(p.dx, p.dy);
      } else {
        checkPath.lineTo(corner.dx, corner.dy);
        final t = (checkProgress - 0.35) / 0.65;
        final p = Offset.lerp(corner, end, t)!;
        checkPath.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(checkPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) =>
      oldDelegate.circleProgress != circleProgress ||
      oldDelegate.checkProgress != checkProgress;
}

class _FinalRoutineItem extends StatelessWidget {
  const _FinalRoutineItem({
    required this.product,
    required this.index,
    required this.selected,
    required this.revealProgress,
    required this.borderOpacity,
  });

  final RoutineProduct product;
  final int index;
  final bool selected;
  final double revealProgress;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) {
    const itemHeight = 78.0;
    const circleSize = 34.0;

    final topProgress = (revealProgress / 0.5).clamp(0.0, 1.0);
    final bottomProgress = ((revealProgress - 0.5) / 0.5).clamp(0.0, 1.0);

    return SizedBox(
      height: itemHeight,
      child: Row(
        children: [
          SizedBox(
            width: circleSize,
            height: itemHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (index > 0)
                  Positioned(
                    top: 0,
                    left: (circleSize - 1) / 2,
                    width: 1,
                    height: ((itemHeight - circleSize) / 2) * topProgress,
                    child: const ColoredBox(color: WellLessColors.divider),
                  ),
                if (index < finalRoutineProducts.length - 1)
                  Positioned(
                    bottom: 0,
                    left: (circleSize - 1) / 2,
                    width: 1,
                    height: ((itemHeight - circleSize) / 2) * bottomProgress,
                    child: const ColoredBox(color: WellLessColors.divider),
                  ),
                Opacity(
                  opacity: (revealProgress / 0.4).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale:
                        0.85 + ((revealProgress / 0.4).clamp(0.0, 1.0) * 0.15),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? WellLessColors.successSurface
                            : WellLessColors.surface,
                        border: Border.all(
                          color: selected
                              ? WellLessColors.success.withValues(
                                  alpha: borderOpacity,
                                )
                              : WellLessColors.divider,
                        ),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: condensed(
                          size: 13,
                          weight: FontWeight.w900,
                          color: selected
                              ? WellLessColors.success
                              : WellLessColors.dim,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 14,
            child: selected
                ? ColoredBox(
                    color: WellLessColors.success.withValues(
                      alpha: borderOpacity,
                    ),
                    child: const SizedBox(height: 1),
                  )
                : null,
          ),
          Expanded(
            child: Opacity(
              opacity: (revealProgress - 0.2).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(
                  (1.0 - (revealProgress - 0.2).clamp(0.0, 1.0)) * 6.0,
                  0.0,
                ),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: selected
                        ? Border.all(
                            color: WellLessColors.success.withValues(
                              alpha: borderOpacity,
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: selected
                              ? WellLessColors.success
                              : WellLessColors.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Opacity(
                        opacity: (revealProgress - 0.4).clamp(0.0, 1.0),
                        child: Row(
                          children: [
                            SmallPill(product.category, green: selected),
                            if (selected)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'AAC 추천',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: WellLessColors.success,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum DemoPaymentMethod { card, kakao, naver, toss }

class CartScreen extends StatefulWidget {
  const CartScreen({required this.onBack, required this.onPaid, super.key});
  final VoidCallback onBack;
  final VoidCallback onPaid;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  int quantity = 1;
  DemoPaymentMethod method = DemoPaymentMethod.card;

  String get methodLabel => switch (method) {
    DemoPaymentMethod.card => '신용/체크카드',
    DemoPaymentMethod.kakao => '카카오페이',
    DemoPaymentMethod.naver => '네이버페이',
    DemoPaymentMethod.toss => '토스페이',
  };

  int get total => 32000 * quantity;

  bool _sheetVisible = false;
  late final AnimationController _entranceController;
  late final AnimationController _sheetController;

  late final Animation<double> _headerProgress;
  late final Animation<double> _cardProgress;
  late final Animation<double> _totalProgress;
  late final Animation<double> _methodProgress;
  late final Animation<double> _ctaProgress;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _headerProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.32, curve: Curves.easeOut),
      ),
    );
    _cardProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.14, 0.46, curve: Curves.easeOut),
      ),
    );
    _totalProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.28, 0.60, curve: Curves.easeOut),
      ),
    );
    _methodProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.42, 0.74, curve: Curves.easeOut),
      ),
    );
    _ctaProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.56, 0.88, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _choosePayment() {
    setState(() {
      _sheetVisible = true;
    });
    _sheetController.forward(from: 0.0);
  }

  void _closePaymentSheet() {
    _sheetController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _sheetVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlowScaffold(
          title: '장바구니',
          onBack: widget.onBack,
          trailing: const Icon(
            Icons.shopping_cart_outlined,
            color: WellLessColors.primary,
          ),
          footer: AnimatedBuilder(
            animation: _entranceController,
            builder: (context, child) {
              return Opacity(
                opacity: _ctaProgress.value,
                child: Transform.translate(
                  offset: Offset(0.0, (1.0 - _ctaProgress.value) * 12.0),
                  child: child,
                ),
              );
            },
            child: PrimaryButton(
              label: '₩${_money(total)} 결제하기 →',
              onPressed: widget.onPaid,
            ),
          ),
          child: AnimatedBuilder(
            animation: _entranceController,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Opacity(
                    opacity: _headerProgress.value,
                    child: Transform.translate(
                      offset: Offset(0.0, (1.0 - _headerProgress.value) * 12.0),
                      child: const Text(
                        '선택한 제품',
                        style: TextStyle(
                          fontSize: 10,
                          color: WellLessColors.dim,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Opacity(
                    opacity: _cardProgress.value,
                    child: Transform.translate(
                      offset: Offset(0.0, (1.0 - _cardProgress.value) * 14.0),
                      child: Transform.scale(
                        scale: 0.98 + _cardProgress.value * 0.02,
                        child: Container(
                          height: 142,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: WellLessColors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Opacity(
                                opacity: (_cardProgress.value - 0.25).clamp(
                                  0.0,
                                  1.0,
                                ),
                                child: Container(
                                  width: 86,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: WellLessColors.surfaceRaised,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Image.asset(
                                      'assets/images/babaco_snow_glacial_toner.png',
                                      key: const Key('babaco-cart-image'),
                                      fit: BoxFit.contain,
                                      semanticLabel: '바바코 스노우 빙하수 에센스 토너',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: (_cardProgress.value - 0.35)
                                          .clamp(0.0, 1.0),
                                      child: const Text(
                                        '바바코 스노우 빙하수 에센스 토너',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Opacity(
                                      opacity: (_cardProgress.value - 0.35)
                                          .clamp(0.0, 1.0),
                                      child: Text(
                                        '수량 $quantity개',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: WellLessColors.dim,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Opacity(
                                      opacity: (_cardProgress.value - 0.45)
                                          .clamp(0.0, 1.0),
                                      child: Text(
                                        '₩${_money(total)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: WellLessColors.success,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Opacity(
                                opacity: (_cardProgress.value - 0.50).clamp(
                                  0.0,
                                  1.0,
                                ),
                                child: Row(
                                  children: [
                                    _QuantityButton(
                                      label: '−',
                                      onTap: () => setState(
                                        () => quantity = quantity > 1
                                            ? quantity - 1
                                            : 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 34,
                                      child: Text(
                                        '$quantity',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    _QuantityButton(
                                      label: '+',
                                      onTap: () => setState(() => quantity++),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 56),
                  Opacity(
                    opacity: _totalProgress.value,
                    child: Transform.translate(
                      offset: Offset(0.0, (1.0 - _totalProgress.value) * 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '결제 금액',
                            style: TextStyle(
                              fontSize: 13,
                              color: WellLessColors.dim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: WellLessColors.border),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '총 결제 금액',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₩${_money(total)}',
                                  style: condensed(
                                    size: 23,
                                    weight: FontWeight.w900,
                                    color: WellLessColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Opacity(
                    opacity: _methodProgress.value,
                    child: Transform.translate(
                      offset: Offset(0.0, (1.0 - _methodProgress.value) * 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '결제 수단',
                            style: TextStyle(
                              fontSize: 13,
                              color: WellLessColors.dim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _choosePayment,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: WellLessColors.surfaceRaised,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _PaymentBrandIcon(method: method, size: 32),
                                  const SizedBox(width: 16),
                                  Text(
                                    methodLabel,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: WellLessColors.dim,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (_sheetVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closePaymentSheet,
              child: AnimatedBuilder(
                animation: _sheetController,
                builder: (context, _) {
                  final dim = _sheetController.value * 0.55;
                  return Container(color: Colors.black.withValues(alpha: dim));
                },
              ),
            ),
          ),
        if (_sheetVisible)
          AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              final curve = CurvedAnimation(
                parent: _sheetController,
                curve: const Cubic(0.22, 1.0, 0.36, 1.0),
              );
              final translateY = (1.0 - curve.value) * 440.0;
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Transform.translate(
                  offset: Offset(0.0, translateY),
                  child: child,
                ),
              );
            },
            child: _PaymentSheet(
              current: method,
              onSelect: (selected) {
                setState(() => method = selected);
                _closePaymentSheet();
              },
              onClose: _closePaymentSheet,
              sheetProgress: _sheetController,
            ),
          ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      color: WellLessColors.surfaceRaised,
      child: Text(label, style: const TextStyle(fontSize: 15)),
    ),
  );
}

class _PaymentSheet extends StatelessWidget {
  const _PaymentSheet({
    required this.current,
    required this.onSelect,
    required this.onClose,
    required this.sheetProgress,
  });

  final DemoPaymentMethod current;
  final ValueChanged<DemoPaymentMethod> onSelect;
  final VoidCallback onClose;
  final AnimationController sheetProgress;

  double _getRowProgress(int index) {
    final start = 0.65 + index * 0.07;
    final end = (start + 0.2).clamp(0.0, 1.0);
    final val = (sheetProgress.value - start) / (end - start);
    return val.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(34, 16, 34, 36),
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
      ),
      child: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: sheetProgress,
          builder: (context, _) {
            final hbProgress = (sheetProgress.value / 0.7).clamp(0.0, 1.0);
            final hbScaleX = 0.65 + hbProgress * 0.35;
            final titleProgress = ((sheetProgress.value - 0.6) / 0.2).clamp(
              0.0,
              1.0,
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: hbProgress,
                  child: Transform.scale(
                    scaleX: hbScaleX,
                    child: Container(
                      width: 86,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 38),
                      color: WellLessColors.muted,
                    ),
                  ),
                ),
                Opacity(
                  opacity: titleProgress,
                  child: Transform.translate(
                    offset: Offset(0.0, (1.0 - titleProgress) * 6.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '결제 수단 선택',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onClose,
                          child: const Icon(
                            Icons.close,
                            color: WellLessColors.muted,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _PaymentRow(
                  method: DemoPaymentMethod.kakao,
                  label: '카카오페이',
                  onTap: () => onSelect(DemoPaymentMethod.kakao),
                  progress: _getRowProgress(0),
                ),
                _PaymentRow(
                  method: DemoPaymentMethod.naver,
                  label: '네이버페이',
                  onTap: () => onSelect(DemoPaymentMethod.naver),
                  progress: _getRowProgress(1),
                ),
                _PaymentRow(
                  method: DemoPaymentMethod.toss,
                  label: '토스페이',
                  onTap: () => onSelect(DemoPaymentMethod.toss),
                  progress: _getRowProgress(2),
                ),
                _PaymentRow(
                  method: DemoPaymentMethod.card,
                  label: '신용/체크카드',
                  onTap: () => onSelect(DemoPaymentMethod.card),
                  progress: _getRowProgress(3),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PaymentRow extends StatefulWidget {
  const _PaymentRow({
    required this.method,
    required this.label,
    required this.onTap,
    required this.progress,
  });

  final DemoPaymentMethod method;
  final String label;
  final VoidCallback onTap;
  final double progress;

  @override
  State<_PaymentRow> createState() => _PaymentRowState();
}

class _PaymentRowState extends State<_PaymentRow> {
  double _scale = 1.0;

  void _handleTap() {
    setState(() => _scale = 0.985);
    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) setState(() => _scale = 1.0);
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: Opacity(
        opacity: widget.progress,
        child: Transform.translate(
          offset: Offset(0.0, (1.0 - widget.progress) * 9.0),
          child: InkWell(
            onTap: _handleTap,
            child: Container(
              height: 64,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF4A4A4A))),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 95,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _PaymentBrandIcon(method: widget.method),
                    ),
                  ),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentBrandIcon extends StatelessWidget {
  const _PaymentBrandIcon({required this.method, this.size = 38});

  final DemoPaymentMethod method;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (method == DemoPaymentMethod.card) {
      return Container(
        width: size * 1.65,
        height: size * 0.68,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(size),
        ),
        child: Icon(Icons.credit_card, color: Colors.white, size: size * 0.5),
      );
    }

    if (method == DemoPaymentMethod.naver) {
      return SizedBox(
        width: size * 1.75,
        height: size * 0.68,
        child: SvgPicture.asset(
          'assets/icons/naver_pay_official.svg',
          fit: BoxFit.contain,
        ),
      );
    }

    final asset = switch (method) {
      DemoPaymentMethod.kakao => 'assets/images/payment_asset_1.png',
      DemoPaymentMethod.toss => 'assets/images/payment_asset_5.png',
      DemoPaymentMethod.naver || DemoPaymentMethod.card => '',
    };
    final background = switch (method) {
      DemoPaymentMethod.kakao => const Color(0xFFFEE500),
      DemoPaymentMethod.toss => Colors.white,
      DemoPaymentMethod.naver || DemoPaymentMethod.card => Colors.transparent,
    };

    return Container(
      width: size * 1.75,
      height: size * 0.68,
      padding: EdgeInsets.symmetric(horizontal: size * 0.12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

class OrderCompleteScreen extends StatefulWidget {
  const OrderCompleteScreen({required this.onRoutine, super.key});
  final VoidCallback onRoutine;

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _orderTextProgress;
  late final Animation<double> _doneTextProgress;
  late final Animation<double> _circleProgress;
  late final Animation<double> _checkProgress;
  late final Animation<double> _settleProgress;
  late final Animation<double> _descProgress;
  late final Animation<double> _btnProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _orderTextProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.25, curve: Curves.easeOut),
      ),
    );
    _doneTextProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.3, curve: Curves.easeOut),
      ),
    );
    _circleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.225, 0.525, curve: Curves.easeOut),
      ),
    );
    _checkProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.65, curve: Curves.easeOut),
      ),
    );
    _settleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.625, 0.725, curve: Curves.easeInOut),
      ),
    );
    _descProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.675, 0.805, curve: Curves.easeOut),
      ),
    );
    _btnProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 0.95, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              double checkScale = 1.0;
              if (_settleProgress.value > 0.0) {
                final p = _settleProgress.value;
                if (p < 0.5) {
                  checkScale = 1.0 + (p / 0.5) * 0.04;
                } else {
                  checkScale = 1.04 - ((p - 0.5) / 0.5) * 0.04;
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: checkScale,
                    child: SizedBox(
                      width: 88,
                      height: 88,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(88, 88),
                            painter: _OrderCompleteCheckPainter(
                              circleProgress: _circleProgress.value,
                              checkProgress: _checkProgress.value,
                            ),
                          ),
                          SizedBox(
                            width: 0,
                            height: 0,
                            child: SvgPicture.asset(
                              'assets/icons/order_check.svg',
                              colorFilter: const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Opacity(
                    opacity: _orderTextProgress.value,
                    child: Transform.translate(
                      offset: Offset(
                        0.0,
                        (1.0 - _orderTextProgress.value) * 10.0,
                      ),
                      child: const Text(
                        '주문',
                        style: TextStyle(
                          fontSize: 54,
                          height: 0.9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _doneTextProgress.value,
                    child: Transform.translate(
                      offset: Offset(
                        0.0,
                        (1.0 - _doneTextProgress.value) * 10.0,
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(
                          fontSize: 54,
                          height: 0.9,
                          color: WellLessColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Opacity(
                    opacity: _descProgress.value,
                    child: Transform.translate(
                      offset: Offset(0.0, (1.0 - _descProgress.value) * 8.0),
                      child: const Text(
                        'AAC Skin 제품이 곧 배송됩니다.',
                        style: TextStyle(
                          fontSize: 13,
                          color: WellLessColors.text,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Opacity(
                    opacity: _btnProgress.value,
                    child: Transform.translate(
                      offset: Offset(0.0, (1.0 - _btnProgress.value) * 10.0),
                      child: _OrderRoutineButton(onTap: widget.onRoutine),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrderCompleteCheckPainter extends CustomPainter {
  _OrderCompleteCheckPainter({
    required this.circleProgress,
    required this.checkProgress,
  });
  final double circleProgress;
  final double checkProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WellLessColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2.25;

    if (circleProgress >= 0.99) {
      canvas.drawCircle(center, radius, paint);
    } else if (circleProgress > 0.0) {
      final path = Path()
        ..addArc(
          Rect.fromCircle(center: center, radius: radius),
          -1.570796,
          6.283185 * circleProgress,
        );
      canvas.drawPath(path, paint);
    }

    if (checkProgress > 0.0) {
      final checkPath = Path();
      final start = Offset(size.width * 0.32, size.height * 0.50);
      final corner = Offset(size.width * 0.45, size.height * 0.63);
      final end = Offset(size.width * 0.68, size.height * 0.38);

      checkPath.moveTo(start.dx, start.dy);

      if (checkProgress <= 0.35) {
        final t = checkProgress / 0.35;
        final p = Offset.lerp(start, corner, t)!;
        checkPath.lineTo(p.dx, p.dy);
      } else {
        checkPath.lineTo(corner.dx, corner.dy);
        final t = (checkProgress - 0.35) / 0.65;
        final p = Offset.lerp(corner, end, t)!;
        checkPath.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(checkPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrderCompleteCheckPainter oldDelegate) =>
      oldDelegate.circleProgress != circleProgress ||
      oldDelegate.checkProgress != checkProgress;
}

class _OrderRoutineButton extends StatefulWidget {
  const _OrderRoutineButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_OrderRoutineButton> createState() => _OrderRoutineButtonState();
}

class _OrderRoutineButtonState extends State<_OrderRoutineButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 190),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.98),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.98, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _arrowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 4.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 4.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0).then((_) {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: TextButton(
            onPressed: _handleTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '루틴 보러가기  ',
                  style: TextStyle(
                    color: WellLessColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Transform.translate(
                  offset: Offset(_arrowAnimation.value, 0.0),
                  child: const Text(
                    '→',
                    style: TextStyle(
                      color: WellLessColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _money(int value) {
  final chars = value.toString().split('').reversed.toList();
  final result = <String>[];
  for (var i = 0; i < chars.length; i++) {
    if (i > 0 && i % 3 == 0) result.add(',');
    result.add(chars[i]);
  }
  return result.reversed.join();
}

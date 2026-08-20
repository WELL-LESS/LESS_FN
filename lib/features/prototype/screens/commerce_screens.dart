import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/mock_data.dart';
import 'package:well_less_app/features/prototype/widgets.dart';

class FinalRoutineScreen extends StatelessWidget {
  const FinalRoutineScreen({
    required this.onBack,
    required this.onCart,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onCart;

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '최종 루틴',
    onBack: onBack,
    trailing: GestureDetector(
      onTap: onCart,
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
    footer: PrimaryButton(label: '제품 만나보러 가기 →', onPressed: onCart),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(
              width: 98,
              height: 98,
              child: Icon(
                Icons.task_alt_rounded,
                color: WellLessColors.success,
                size: 98,
                weight: 900,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.25,
                    color: WellLessColors.muted,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(text: '필요한 것만 남긴,\n'),
                    TextSpan(
                      text: '당신을 위한 루틴',
                      style: TextStyle(color: WellLessColors.success),
                    ),
                    TextSpan(text: '이에요.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        const Row(
          children: [
            CircleAvatar(radius: 3, backgroundColor: WellLessColors.success),
            SizedBox(width: 8),
            Text(
              'AAC 교체 제품',
              style: TextStyle(fontSize: 11, color: WellLessColors.dim),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: finalRoutineProducts.length,
            itemBuilder: (context, index) => _FinalRoutineItem(
              product: finalRoutineProducts[index],
              index: index,
              selected: index == 3,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FinalRoutineItem extends StatelessWidget {
  const _FinalRoutineItem({
    required this.product,
    required this.index,
    required this.selected,
  });

  final RoutineProduct product;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const itemHeight = 78.0;
    const circleSize = 34.0;
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
                    height: (itemHeight - circleSize) / 2,
                    child: const ColoredBox(color: WellLessColors.divider),
                  ),
                if (index < finalRoutineProducts.length - 1)
                  Positioned(
                    bottom: 0,
                    left: (circleSize - 1) / 2,
                    width: 1,
                    height: (itemHeight - circleSize) / 2,
                    child: const ColoredBox(color: WellLessColors.divider),
                  ),
                Container(
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
                          ? WellLessColors.success
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
              ],
            ),
          ),
          SizedBox(
            width: 14,
            child: selected
                ? const ColoredBox(
                    color: WellLessColors.success,
                    child: SizedBox(height: 1),
                  )
                : null,
          ),
          Expanded(
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: selected
                    ? Border.all(color: WellLessColors.success)
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
                  Row(
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
                ],
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

class _CartScreenState extends State<CartScreen> {
  int quantity = 1;
  DemoPaymentMethod method = DemoPaymentMethod.card;

  String get methodLabel => switch (method) {
    DemoPaymentMethod.card => '신용/체크카드',
    DemoPaymentMethod.kakao => '카카오페이',
    DemoPaymentMethod.naver => '네이버페이',
    DemoPaymentMethod.toss => '토스페이',
  };

  int get total => 48000 * quantity;

  Future<void> _choosePayment() async {
    final selected = await showModalBottomSheet<DemoPaymentMethod>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaymentSheet(current: method),
    );
    if (selected != null) setState(() => method = selected);
  }

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '장바구니',
    onBack: widget.onBack,
    trailing: const Icon(
      Icons.shopping_cart_outlined,
      color: WellLessColors.primary,
    ),
    footer: PrimaryButton(
      label: '₩${_money(total)} 결제하기 →',
      onPressed: widget.onPaid,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          '선택한 제품',
          style: TextStyle(fontSize: 10, color: WellLessColors.dim),
        ),
        const SizedBox(height: 4),
        Container(
          height: 142,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: WellLessColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 86,
                height: 110,
                decoration: BoxDecoration(
                  color: WellLessColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ProductBottle(size: 76),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AAC 세이프 BHA 세럼',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AAC 세이프 BHA 세럼 x $quantity',
                      style: const TextStyle(
                        fontSize: 10,
                        color: WellLessColors.dim,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₩${_money(total)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: WellLessColors.success,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _QuantityButton(
                    label: '−',
                    onTap: () => setState(
                      () => quantity = quantity > 1 ? quantity - 1 : 1,
                    ),
                  ),
                  SizedBox(
                    width: 34,
                    child: Text(
                      '$quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  _QuantityButton(
                    label: '+',
                    onTap: () => setState(() => quantity++),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 56),
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
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
        const Spacer(),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
  );
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
  const _PaymentSheet({required this.current});
  final DemoPaymentMethod current;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(34, 16, 34, 36),
    decoration: const BoxDecoration(
      color: Color(0xFF222222),
      borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 86,
            height: 5,
            margin: const EdgeInsets.only(bottom: 38),
            color: WellLessColors.muted,
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  '결제 수단 선택',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: WellLessColors.muted,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _PaymentRow(method: DemoPaymentMethod.kakao, label: '카카오페이'),
          _PaymentRow(method: DemoPaymentMethod.naver, label: '네이버페이'),
          _PaymentRow(method: DemoPaymentMethod.toss, label: '토스페이'),
          const _PaymentRow(method: DemoPaymentMethod.card, label: '신용/체크카드'),
        ],
      ),
    ),
  );
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.method, required this.label});
  final DemoPaymentMethod method;
  final String label;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.pop(context, method),
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
              child: _PaymentBrandIcon(method: method),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
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

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({required this.onRoutine, super.key});
  final VoidCallback onRoutine;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WellLessColors.background,
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/order_check.svg',
              width: 88,
              height: 88,
            ),
            const SizedBox(height: 70),
            const Text(
              '주문',
              style: TextStyle(
                fontSize: 54,
                height: 0.9,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              '완료',
              style: TextStyle(
                fontSize: 54,
                height: 0.9,
                color: WellLessColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'AAC Skin 제품이 곧 배송됩니다.',
              style: TextStyle(fontSize: 13, color: WellLessColors.text),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: onRoutine,
              child: const Text(
                '루틴 보러가기  →',
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
    ),
  );
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

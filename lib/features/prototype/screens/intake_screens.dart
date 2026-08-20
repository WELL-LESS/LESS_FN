import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/widgets.dart';

class KoreanSplashScreen extends StatelessWidget {
  const KoreanSplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const _SplashFrame(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '더적게',
          style: TextStyle(
            fontSize: 76,
            height: 0.92,
            fontWeight: FontWeight.w900,
            letterSpacing: -3,
          ),
        ),
        Text(
          '더좋게',
          style: TextStyle(
            color: WellLessColors.primary,
            fontSize: 76,
            height: 0.92,
            fontWeight: FontWeight.w900,
            letterSpacing: -3,
          ),
        ),
      ],
    ),
  );
}

class BrandSplashScreen extends StatelessWidget {
  const BrandSplashScreen({super.key});

  @override
  Widget build(BuildContext context) => _SplashFrame(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELL',
          style: condensed(size: 82, weight: FontWeight.w900, height: 0.84),
        ),
        Container(
          width: 31,
          height: 5,
          margin: const EdgeInsets.symmetric(vertical: 9),
          color: WellLessColors.primary,
        ),
        Text(
          'LESS',
          style: condensed(size: 82, weight: FontWeight.w900, height: 0.84),
        ),
      ],
    ),
  );
}

class _SplashFrame extends StatelessWidget {
  const _SplashFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WellLessColors.background,
    body: Stack(
      children: [
        const Positioned.fill(child: CustomPaint(painter: _CrossHairPainter())),
        Center(child: child),
      ],
    ),
  );
}

class _CrossHairPainter extends CustomPainter {
  const _CrossHairPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final faint = Paint()..color = const Color(0xFF131313);
    canvas.drawRect(Rect.fromLTWH(size.width / 2, 0, 1, size.height), faint);
    canvas.drawRect(Rect.fromLTWH(0, size.height / 2, size.width, 1), faint);
    final corners = Paint()
      ..color = WellLessColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const d = 16.0;
    const inset = 28.0;
    canvas.drawPath(
      Path()
        ..moveTo(inset + d, inset)
        ..lineTo(inset, inset)
        ..lineTo(inset, inset + d),
      corners,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width - inset - d, inset)
        ..lineTo(size.width - inset, inset)
        ..lineTo(size.width - inset, inset + d),
      corners,
    );
    canvas.drawPath(
      Path()
        ..moveTo(inset, size.height - inset - d)
        ..lineTo(inset, size.height - inset)
        ..lineTo(inset + d, size.height - inset),
      corners,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width - inset, size.height - inset - d)
        ..lineTo(size.width - inset, size.height - inset)
        ..lineTo(size.width - inset - d, size.height - inset),
      corners,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CodeScreen extends StatefulWidget {
  const CodeScreen({required this.onSuccess, super.key});

  final VoidCallback onSuccess;

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final _controller = TextEditingController();
  bool _invalid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_controller.text.trim().toUpperCase() == 'WHS-2026-1234') {
      widget.onSuccess();
    } else {
      setState(() => _invalid = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;
    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionEyebrow('WELL LESS'),
              const SizedBox(height: 52),
              const Text(
                '고객 번호를 입력해주세요.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '피부 진단 센터에서 받은 개인 코드로 진단 결과를 불러옵니다.',
                style: TextStyle(fontSize: 12, color: WellLessColors.dim),
              ),
              const SizedBox(height: 42),
              const Text(
                'PERSONAL CODE',
                style: TextStyle(
                  fontSize: 10,
                  color: WellLessColors.dim,
                  letterSpacing: 1.7,
                ),
              ),
              TextField(
                controller: _controller,
                autofocus: false,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                onChanged: (_) => setState(() => _invalid = false),
                onSubmitted: (_) => _submit(),
                style: condensed(
                  size: 28,
                  weight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
                decoration: InputDecoration(
                  hintText: 'WHS-2026-XXXX',
                  hintStyle: condensed(
                    size: 28,
                    weight: FontWeight.w800,
                    color: WellLessColors.dim,
                    letterSpacing: 1.8,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: WellLessColors.border),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: WellLessColors.primary),
                  ),
                ),
              ),
              if (_invalid)
                const Padding(
                  padding: EdgeInsets.only(top: 9, bottom: 12),
                  child: Text(
                    '고객 번호가 올바르지 않습니다. 다시 진행해주세요.',
                    style: TextStyle(fontSize: 12, color: Color(0xFFC12C1E)),
                  ),
                )
              else
                const SizedBox(height: 10),
              PrimaryButton(
                label: 'WELL LESS 입장하기 →',
                enabled: hasText,
                onPressed: _submit,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onReport,
    required this.onHistory,
    super.key,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WellLessColors.background,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 48, 28, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionEyebrow('WELL LESS'),
            const SizedBox(height: 28),
            const Text(
              '환영합니다.',
              style: TextStyle(
                fontSize: 36,
                height: 1.08,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 7),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(text: 'WELL '),
                    TextSpan(
                      text: 'LESS',
                      style: TextStyle(color: WellLessColors.primary),
                    ),
                    TextSpan(
                      text: '입니다.',
                      style: TextStyle(color: WellLessColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '피부 진단 결과가 준비되었습니다.\n아래에서 원하는 항목을 선택하세요.',
              style: TextStyle(
                fontSize: 12,
                color: WellLessColors.dim,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 90),
            _HomeCard(
              active: true,
              title: '피부 레포트 보러가기',
              subtitle: '최신 진단 결과 · 루틴 분석',
              onTap: onReport,
            ),
            const SizedBox(height: 12),
            _HomeCard(
              title: '이전 기록 보러가기',
              subtitle: '과거 진단 내역 · 변화 추이',
              onTap: onHistory,
            ),
          ],
        ),
      ),
    ),
  );
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.active = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      height: active ? 92 : 64,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: active ? WellLessColors.primary : Colors.transparent,
        border: Border.all(
          color: active ? WellLessColors.primary : WellLessColors.border,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: active ? Colors.white : WellLessColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: active ? Colors.white70 : WellLessColors.dim,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '→',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w200,
              color: active ? Colors.white : WellLessColors.dim,
            ),
          ),
        ],
      ),
    ),
  );
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    required this.onBack,
    required this.onRegister,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onRegister;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _details = false;

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '피부 진단 레포트',
    onBack: widget.onBack,
    footer: PrimaryButton(label: '제품 등록하기 →', onPressed: widget.onRegister),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const SectionEyebrow('WHS-2026-1234', color: WellLessColors.muted),
        const SizedBox(height: 8),
        const Text(
          '2026년 08월 04일',
          style: TextStyle(fontSize: 10, color: WellLessColors.dim),
        ),
        Center(
          child: Image.asset(
            'assets/images/skin_face_2.png',
            width: 154,
            height: 174,
            fit: BoxFit.contain,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _ReportTab(
                label: '피부 타입',
                active: !_details,
                onTap: () => setState(() => _details = false),
              ),
            ),
            Expanded(
              child: _ReportTab(
                label: '상세 분석',
                active: _details,
                onTap: () => setState(() => _details = true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _details ? const _DetailedMetrics() : const _SkinTypeSummary(),
        ),
      ],
    ),
  );
}

class _ReportTab extends StatelessWidget {
  const _ReportTab({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: active ? WellLessColors.primary : WellLessColors.border,
            width: active ? 2 : 1,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? WellLessColors.text : WellLessColors.dim,
        ),
      ),
    ),
  );
}

class _SkinTypeSummary extends StatelessWidget {
  const _SkinTypeSummary();

  void _showTypes(BuildContext context, _SkinFamilyData family) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => _SkinTypeSheet(family: family),
      );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(
            '#OSP',
            style: condensed(
              size: 54,
              weight: FontWeight.w900,
              color: WellLessColors.primary,
              height: 0.9,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '사용자님의 피부 타입은',
                  style: TextStyle(fontSize: 12, color: WellLessColors.dim),
                ),
                SizedBox(height: 4),
                Text(
                  '지성·민감성·색소성',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 38),
      const Text(
        '다른 피부 타입도 확인해볼까요?',
        style: TextStyle(fontSize: 12, color: WellLessColors.dim),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          for (var index = 0; index < _skinFamilies.length; index++) ...[
            Expanded(
              child: _TypeCard(
                code: _skinFamilies[index].code,
                label: _skinFamilies[index].label,
                active: _skinFamilies[index].code == 'O',
                onTap: () => _showTypes(context, _skinFamilies[index]),
              ),
            ),
            if (index != _skinFamilies.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    ],
  );
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.code,
    required this.label,
    this.active = false,
    required this.onTap,
  });
  final String code;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      height: 155,
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
      decoration: BoxDecoration(
        color: active
            ? WellLessColors.primary.withValues(alpha: 0.09)
            : WellLessColors.surfaceRaised,
        border: Border.all(
          color: active ? WellLessColors.primary : WellLessColors.border,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            code,
            style: condensed(
              size: 36,
              weight: FontWeight.w900,
              color: active ? WellLessColors.primary : WellLessColors.dim,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? WellLessColors.text : WellLessColors.dim,
            ),
          ),
          const Spacer(),
          Text(
            '4 TYPES →',
            style: condensed(
              size: 9,
              weight: FontWeight.w400,
              color: active ? WellLessColors.primary : WellLessColors.faint,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SkinTypeSheet extends StatelessWidget {
  const _SkinTypeSheet({required this.family});

  final _SkinFamilyData family;

  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.sizeOf(context).height * 0.72,
    decoration: const BoxDecoration(
      color: WellLessColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      border: Border(top: BorderSide(color: WellLessColors.border)),
    ),
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 3,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WellLessColors.faint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Row(
              children: [
                Text(
                  family.code,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: WellLessColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      family.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      family.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: WellLessColors.dim,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...family.types.map(
            (item) => Container(
              height: 81,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: item.$1 == _currentSkinType
                    ? WellLessColors.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                border: const Border(
                  bottom: BorderSide(color: WellLessColors.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: condensed(
                            size: 22,
                            weight: FontWeight.w800,
                            color: item.$1 == _currentSkinType
                                ? WellLessColors.primary
                                : WellLessColors.text,
                          ),
                        ),
                        Text(
                          item.$2,
                          style: TextStyle(
                            fontSize: 11,
                            color: item.$1 == _currentSkinType
                                ? WellLessColors.primary
                                : WellLessColors.dim,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.$1 == _currentSkinType)
                    const SmallPill('내 타입', active: true),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DetailedMetrics extends StatelessWidget {
  const _DetailedMetrics();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetricBar('모공', 0.44, 0.79),
          MetricBar('블랙헤드', 0.56, 0.61),
          MetricBar('광채', 0.77, 0.86),
          MetricBar('홍조', 0.75, 0.91),
          MetricBar('다크서클', 0.98, 0.89),
          MetricBar('여드름', 0.89, 0.86),
        ],
      ),
    ),
  );
}

const _currentSkinType = 'OSP';

class _SkinFamilyData {
  const _SkinFamilyData({
    required this.code,
    required this.label,
    required this.title,
    required this.description,
    required this.types,
  });

  final String code;
  final String label;
  final String title;
  final String description;
  final List<(String, String)> types;
}

const _skinFamilies = <_SkinFamilyData>[
  _SkinFamilyData(
    code: 'O',
    label: '지성',
    title: '지성 피부',
    description: '피지 분비가 많고 모공이 넓은 유형',
    types: [
      ('OSP', '지성·민감성·색소성'),
      ('OSN', '지성·민감성·비색소성'),
      ('ORP', '지성·저항성·색소성'),
      ('ORN', '지성·저항성·비색소성'),
    ],
  ),
  _SkinFamilyData(
    code: 'D',
    label: '건성',
    title: '건성 피부',
    description: '수분과 유분이 부족해 건조함을 느끼는 유형',
    types: [
      ('DSP', '건성·민감성·색소성'),
      ('DSN', '건성·민감성·비색소성'),
      ('DRP', '건성·저항성·색소성'),
      ('DRN', '건성·저항성·비색소성'),
    ],
  ),
  _SkinFamilyData(
    code: 'C',
    label: '복합성',
    title: '복합성 피부',
    description: '부위에 따라 유분과 건조함이 함께 나타나는 유형',
    types: [
      ('CSP', '복합성·민감성·색소성'),
      ('CSN', '복합성·민감성·비색소성'),
      ('CRP', '복합성·저항성·색소성'),
      ('CRN', '복합성·저항성·비색소성'),
    ],
  ),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    required this.onBack,
    required this.onContinue,
    super.key,
  });
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final selected = <String>{'클렌징폼/젤', '미스트/오일'};

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '제품 등록',
    onBack: widget.onBack,
    footer: PrimaryButton(label: '제품 등록하기 →', onPressed: widget.onContinue),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          '사용하는 카테고리를 선택하세요.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 3),
        const Text(
          '스크롤을 하면서 카테고리를 선택할 수 있어요.',
          style: TextStyle(fontSize: 11, color: WellLessColors.dim),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: selected
              .map(
                (item) => GestureDetector(
                  onTap: () => setState(() => selected.remove(item)),
                  child: SmallPill(item, active: true),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 72),
        Center(
          child: SizedBox(
            width: 250,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/category_bottle.svg',
                  width: 100,
                  height: 200,
                ),
                ..._categoryLabels.map(
                  (label) => Positioned(
                    left: label.left,
                    top: label.top,
                    child: GestureDetector(
                      onTap: () => setState(
                        () => selected.contains(label.text)
                            ? selected.remove(label.text)
                            : selected.add(label.text),
                      ),
                      child: Text(
                        label.text,
                        style: TextStyle(
                          fontSize: label.text == '미스트/오일' ? 16 : 12,
                          fontWeight: FontWeight.w700,
                          color: selected.contains(label.text)
                              ? WellLessColors.primary
                              : label.strong
                              ? WellLessColors.text
                              : WellLessColors.dim,
                        ),
                      ),
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

class _CategoryLabel {
  const _CategoryLabel(this.text, this.left, this.top, this.strong);

  final String text;
  final double left;
  final double top;
  final bool strong;
}

const _categoryLabels = <_CategoryLabel>[
  _CategoryLabel('스킨/토너', 8, 20, false),
  _CategoryLabel('클렌징폼/젤', 145, 20, false),
  _CategoryLabel('에센스/세럼/앰플', 0, 66, true),
  _CategoryLabel('클렌징오일/밤', 155, 66, true),
  _CategoryLabel('미스트/오일', 18, 114, true),
  _CategoryLabel('필링&스크럽', 166, 114, true),
  _CategoryLabel('로션', 42, 164, false),
  _CategoryLabel('클렌징워터/밀크', 164, 164, false),
];

class ProductInputScreen extends StatelessWidget {
  const ProductInputScreen({
    required this.productAdded,
    required this.onBack,
    required this.onCamera,
    required this.onAnalyze,
    super.key,
  });
  final bool productAdded;
  final VoidCallback onBack;
  final VoidCallback onCamera;
  final VoidCallback onAnalyze;

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '제품 등록',
    onBack: onBack,
    trailing: Text(
      '${productAdded ? 2 : 1}개 등록',
      style: const TextStyle(
        color: WellLessColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
    footer: PrimaryButton(label: 'AI 루틴 분석 →', onPressed: onAnalyze),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const SectionEyebrow('토너', color: WellLessColors.text),
        const SizedBox(height: 10),
        const _RegisteredProduct(name: 'COSRX 어드밴스드 달팽이 72 에센스'),
        const SizedBox(height: 8),
        _PhotoInput(onTap: onCamera),
        const SizedBox(height: 32),
        const SectionEyebrow('에센스'),
        const SizedBox(height: 10),
        if (productAdded) const _RegisteredProduct(name: 'MISSHA 타임 레볼루션 앰플'),
        if (productAdded) const SizedBox(height: 8),
        _PhotoInput(onTap: onCamera),
      ],
    ),
  );
}

class _RegisteredProduct extends StatelessWidget {
  const _RegisteredProduct({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Container(
    height: 70,
    decoration: const BoxDecoration(
      border: Border.symmetric(
        horizontal: BorderSide(color: WellLessColors.border),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          color: WellLessColors.surfaceRaised,
          child: const Text('🧴'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 12)),
              const Text(
                'COSRX',
                style: TextStyle(fontSize: 9, color: WellLessColors.dim),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: WellLessColors.border),
          ),
          child: const Text(
            '제거',
            style: TextStyle(fontSize: 10, color: WellLessColors.dim),
          ),
        ),
      ],
    ),
  );
}

class _PhotoInput extends StatelessWidget {
  const _PhotoInput({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        border: Border.all(
          color: WellLessColors.border,
          style: BorderStyle.solid,
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.camera_alt_outlined, size: 17, color: WellLessColors.dim),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '사진으로 제품 등록',
                  style: TextStyle(fontSize: 11, color: WellLessColors.dim),
                ),
                Text(
                  '카메라 또는 갤러리',
                  style: TextStyle(fontSize: 9, color: WellLessColors.faint),
                ),
              ],
            ),
          ),
          Text('+', style: TextStyle(color: WellLessColors.dim)),
        ],
      ),
    ),
  );
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({
    required this.onCancel,
    required this.onCapture,
    super.key,
  });
  final VoidCallback onCancel;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WellLessColors.background,
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 54,
            child: Row(
              children: [
                const SizedBox(width: 22),
                GestureDetector(
                  onTap: onCancel,
                  child: const Text(
                    '← 취소',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                const Spacer(),
                const Text(
                  '제품을 화면에 맞추세요',
                  style: TextStyle(fontSize: 12, color: WellLessColors.muted),
                ),
                const Spacer(),
                const SizedBox(width: 54),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: Color(0xFF090909)),
                ),
                Center(
                  child: Container(
                    width: 274,
                    height: 330,
                    decoration: const BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: WellLessColors.muted),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    '카메라 연결 중...',
                    style: TextStyle(color: WellLessColors.faint, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 130,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: WellLessColors.border)),
            ),
            child: Center(
              child: GestureDetector(
                onTap: onCapture,
                child: Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: WellLessColors.primary),
                  ),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: WellLessColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({required this.onComplete, super.key});
  final VoidCallback onComplete;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    timer = Timer(const Duration(milliseconds: 1800), widget.onComplete);
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WellLessColors.background,
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '잠시만 기다려주세요.',
                    style: TextStyle(color: WellLessColors.dim, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        TextSpan(text: '사용자님의 '),
                        TextSpan(
                          text: '루틴',
                          style: TextStyle(color: WellLessColors.primary),
                        ),
                        TextSpan(text: '을 분석중입니다.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 38),
                  SizedBox(
                    width: 154,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (_, _) => LinearProgressIndicator(
                        value: 0.18 + controller.value * 0.65,
                        minHeight: 2,
                        backgroundColor: WellLessColors.divider,
                        color: WellLessColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'ANALYSIS INGREDIENTS DATA',
                    style: condensed(
                      size: 18,
                      weight: FontWeight.w200,
                      color: WellLessColors.dim,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 94,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: WellLessColors.border)),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

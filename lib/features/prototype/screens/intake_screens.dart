import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/widgets.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _splashTimer;

  // Animation values
  late final Animation<double> _text1Opacity;
  late final Animation<double> _text1TranslateY;
  late final Animation<double> _text1Scale;

  late final Animation<double> _text2Opacity;
  late final Animation<double> _text2TranslateY;
  late final Animation<double> _text2Scale;

  late final Animation<double> _koreanOpacity;
  late final Animation<double> _koreanCompressY;
  late final Animation<double> _koreanScaleX;
  late final Animation<double> _koreanScaleY;

  late final Animation<double> _englishOpacity;
  late final Animation<double> _englishExpandY;
  late final Animation<double> _englishScale;

  late final Animation<double> _redLineWidth;

  late final Animation<double> _subtextOpacity;
  late final Animation<double> _subtextTranslateY;
  late final Animation<double> _subtextBlur;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Timing Setup (Total: 1800ms)
    // 1. "더적게": 0ms to 350ms (0.0 to 0.194)
    _text1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.194, curve: Curves.easeOut),
      ),
    );
    _text1TranslateY = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.194, curve: Curves.easeOutCubic),
      ),
    );
    _text1Scale = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.194, curve: Curves.easeOut),
      ),
    );

    // 2. "더좋게": 150ms to 500ms (0.083 to 0.278)
    _text2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.083, 0.278, curve: Curves.easeOut),
      ),
    );
    _text2TranslateY = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.083, 0.278, curve: Curves.easeOutCubic),
      ),
    );
    _text2Scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.96, end: 1.02).chain(CurveTween(curve: Curves.easeOut)),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.083, 0.278),
      ),
    );

    // 3. Korean Compression / English Transition: 950ms to 1350ms (0.528 to 0.750)
    final compressProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.528, 0.750, curve: Curves.easeInOutCubic),
    );
    _koreanOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(compressProgress);
    _koreanCompressY = Tween<double>(begin: 0.0, end: 8.0).animate(compressProgress);
    _koreanScaleX = Tween<double>(begin: 1.0, end: 0.88).animate(compressProgress);
    _koreanScaleY = Tween<double>(begin: 1.0, end: 0.88).animate(compressProgress);

    _englishOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(compressProgress);
    _englishExpandY = Tween<double>(begin: 8.0, end: 0.0).animate(compressProgress);
    _englishScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.88, end: 1.02).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 25,
      ),
    ]).animate(compressProgress);

    // 4. Red line: 1250ms to 1550ms (0.694 to 0.861)
    _redLineWidth = Tween<double>(begin: 0.0, end: 31.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.694, 0.861, curve: Curves.easeOutCubic),
      ),
    );

    // 5. Subtext: 1450ms to 1750ms (0.806 to 0.972)
    _subtextOpacity = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.806, 0.972, curve: Curves.easeOut),
      ),
    );
    _subtextTranslateY = Tween<double>(begin: 6.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.806, 0.972, curve: Curves.easeOutCubic),
      ),
    );
    _subtextBlur = Tween<double>(begin: 3.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.806, 0.972, curve: Curves.easeOut),
      ),
    );

    _splashTimer = Timer(const Duration(milliseconds: 1750), () {
      if (mounted) {
        widget.onComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SplashFrame(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Korean Copy Column (Layout-stable using Opacity)
                  Opacity(
                    opacity: _koreanOpacity.value,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..scale(_koreanScaleX.value, _koreanScaleY.value),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.translate(
                            offset: Offset(0.0, _text1TranslateY.value + _koreanCompressY.value),
                            child: Transform.scale(
                              scale: _text1Scale.value,
                              child: const Text(
                                  '\ub354\uc801\uac8c',
                                  style: TextStyle(
                                    fontSize: 76,
                                    height: 0.92,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -3,
                                  ),
                                ),
                              ),
                            ),
                          Transform.translate(
                            offset: Offset(0.0, _text2TranslateY.value - _koreanCompressY.value),
                            child: Transform.scale(
                              scale: _text2Scale.value,
                              child: const Text(
                                  '\ub354\uc88b\uac8c',
                                  style: TextStyle(
                                    color: WellLessColors.primary,
                                    fontSize: 76,
                                    height: 0.92,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // English Brand Column (Layout-stable using Opacity)
                  Opacity(
                    opacity: _englishOpacity.value,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..scale(_englishScale.value, _englishScale.value),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: Offset(0.0, _englishExpandY.value),
                            child: Text(
                              'WELL',
                              style: condensed(
                                size: 82,
                                weight: FontWeight.w900,
                                height: 0.84,
                              ),
                            ),
                          ),
                          Container(
                            width: _redLineWidth.value,
                            height: 5,
                            margin: const EdgeInsets.symmetric(vertical: 9),
                            color: WellLessColors.primary,
                          ),
                          Transform.translate(
                            offset: Offset(0.0, -_englishExpandY.value),
                            child: Text(
                              'LESS',
                              style: condensed(
                                size: 82,
                                weight: FontWeight.w900,
                                height: 0.84,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Faint Subtext: AI SKINCARE ANALYSIS (Layout-stable using Opacity)
              const SizedBox(height: 32),
              Opacity(
                opacity: _subtextOpacity.value,
                child: Transform.translate(
                  offset: Offset(0.0, _subtextTranslateY.value),
                  child: _subtextBlur.value > 0.09
                      ? ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: _subtextBlur.value,
                            sigmaY: _subtextBlur.value,
                          ),
                          child: Text(
                            'AI SKINCARE ANALYSIS',
                            style: condensed(
                              size: 11,
                              weight: FontWeight.w600,
                              color: WellLessColors.text,
                              letterSpacing: 2.0,
                            ),
                          ),
                        )
                      : Text(
                          'AI SKINCARE ANALYSIS',
                          style: condensed(
                            size: 11,
                            weight: FontWeight.w600,
                            color: WellLessColors.text,
                            letterSpacing: 2.0,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SplashFrame extends StatelessWidget {
  const _SplashFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF000000),
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

class RevealWidget extends StatelessWidget {
  const RevealWidget({
    required this.child,
    required this.controller,
    required this.start,
    required this.duration,
    super.key,
  });

  final Widget child;
  final AnimationController controller;
  final double start;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );

    final translateAnimation = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: const Cubic(0.22, 1.0, 0.36, 1.0)),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0.0, translateAnimation.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class AnimatedCharacterText extends StatelessWidget {
  const AnimatedCharacterText({
    required this.text,
    required this.hintText,
    super.key,
  });

  final String text;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final style = condensed(
      size: 28,
      weight: FontWeight.w800,
      letterSpacing: 1.8,
    );
    final hintStyle = condensed(
      size: 28,
      weight: FontWeight.w800,
      color: WellLessColors.dim,
      letterSpacing: 1.8,
    );

    final charList = text.split('');
    final hintList = hintText.split('');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(hintList.length, (index) {
        final hasChar = index < charList.length;
        final char = hasChar ? charList[index] : hintList[index];
        final isHint = !hasChar;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.0, 0.15),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: Text(
            char,
            key: ValueKey('$index-$char-$isHint'),
            style: isHint ? hintStyle : style,
          ),
        );
      }),
    );
  }
}

class ShakeErrorText extends StatefulWidget {
  const ShakeErrorText({required this.text, super.key});

  final String text;

  @override
  State<ShakeErrorText> createState() => _ShakeErrorTextState();
}

class _ShakeErrorTextState extends State<ShakeErrorText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _translateY;
  late final Animation<double> _opacity;
  late final Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.44, curve: Curves.easeOut),
      ),
    );
    _translateY = Tween<double>(begin: 3.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.44, curve: Curves.easeOut),
      ),
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -2.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -2.0, end: 2.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 2.0, end: -1.5), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -1.5, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.44, 1.0, curve: Curves.linear),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(_shake.value, _translateY.value),
            child: child,
          ),
        );
      },
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 12, color: Color(0xFFC12C1E)),
      ),
    );
  }
}

class CodeScreen extends StatefulWidget {
  const CodeScreen({required this.onSuccess, super.key});

  final VoidCallback onSuccess;

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _invalid = false;
  late final AnimationController _revealController;
  late final AnimationController _exitController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _revealController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _revealController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_controller.text.trim().toUpperCase() == 'WHS-2026-1234') {
      _exitController.forward().then((_) {
        widget.onSuccess();
      });
    } else {
      setState(() => _invalid = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;
    final exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(_exitController);
    final exitTranslateY = Tween<double>(begin: 0.0, end: -6.0).animate(_exitController);

    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _exitController,
          builder: (context, child) {
            return Opacity(
              opacity: exitOpacity.value,
              child: Transform.translate(
                offset: Offset(0.0, exitTranslateY.value),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. WELL LESS eyebrow
                RevealWidget(
                  controller: _revealController,
                  start: 0.0,
                  duration: 0.35,
                  child: const SectionEyebrow('WELL LESS'),
                ),
                const SizedBox(height: 52),

                // 2. 고객 번호를 입력해주세요. (Staggered character groupings)
                const SizedBox(
                  width: 0,
                  height: 0,
                  child: Text(
                    '고객 번호를 입력해주세요.',
                    style: TextStyle(color: Colors.transparent),
                  ),
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    RevealWidget(
                      controller: _revealController,
                      start: 0.1,
                      duration: 0.4,
                      child: const Text(
                        '고객 ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RevealWidget(
                      controller: _revealController,
                      start: 0.14,
                      duration: 0.4,
                      child: const Text(
                        '번호를 ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RevealWidget(
                      controller: _revealController,
                      start: 0.18,
                      duration: 0.4,
                      child: const Text(
                        '입력해주세요.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // 3. 하단 설명 문구
                RevealWidget(
                  controller: _revealController,
                  start: 0.26,
                  duration: 0.35,
                  child: const Text(
                    '피부 진단 센터에서 받은 개인 코드로 진단 결과를 불러옵니다.',
                    style: TextStyle(fontSize: 12, color: WellLessColors.dim),
                  ),
                ),
                const SizedBox(height: 42),

                // 4. PERSONAL CODE
                RevealWidget(
                  controller: _revealController,
                  start: 0.34,
                  duration: 0.35,
                  child: const Text(
                    'PERSONAL CODE',
                    style: TextStyle(
                      fontSize: 10,
                      color: WellLessColors.dim,
                      letterSpacing: 1.7,
                    ),
                  ),
                ),

                // 5. Input Field Stack with custom character animations
                RevealWidget(
                  controller: _revealController,
                  start: 0.42,
                  duration: 0.4,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const SizedBox(
                        width: 0,
                        height: 0,
                        child: Text(
                          'WHS-2026-XXXX',
                          style: TextStyle(color: Colors.transparent),
                        ),
                      ),
                      IgnorePointer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: ListenableBuilder(
                            listenable: _controller,
                            builder: (context, _) {
                              return AnimatedCharacterText(
                                text: _controller.text,
                                hintText: 'WHS-2026-XXXX',
                              );
                            },
                          ),
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        autofocus: false,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [LengthLimitingTextInputFormatter(13)],
                        onChanged: (_) {
                          setState(() => _invalid = false);
                        },
                        onSubmitted: (_) => _submit(),
                        cursorColor: WellLessColors.primary,
                        showCursor: true,
                        style: condensed(
                          size: 28,
                          weight: FontWeight.w800,
                          color: Colors.transparent, // Hide actual characters to overlay animated text
                          letterSpacing: 1.8,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: WellLessColors.border),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: WellLessColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 6. Error text
                if (_invalid)
                  const Padding(
                    padding: EdgeInsets.only(top: 9, bottom: 12),
                    child: ShakeErrorText(
                      text: '고객 번호가 올바르지 않습니다. 다시 진행해주세요.',
                    ),
                  )
                else
                  const SizedBox(height: 10),

                // 7. WELL LESS 입장하기 버튼
                RevealWidget(
                  controller: _revealController,
                  start: 0.50,
                  duration: 0.4,
                  child: PrimaryButton(
                    label: 'WELL LESS 입장하기 →',
                    enabled: hasText,
                    onPressed: _submit,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.onReport,
    required this.onHistory,
    super.key,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _revealController.forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Eyebrow WELL LESS
              RevealWidget(
                controller: _revealController,
                start: 0.0,
                duration: 0.35,
                child: const SectionEyebrow('WELL LESS'),
              ),
              const SizedBox(height: 28),

              // 2. 환영합니다.
              RevealWidget(
                controller: _revealController,
                start: 0.1,
                duration: 0.4,
                child: const Text(
                  '환영합니다.',
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 7),

              // 3. WELL LESS입니다. (Staggered 70ms after title)
              RevealWidget(
                controller: _revealController,
                start: 0.19,
                duration: 0.4,
                child: FittedBox(
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
              ),
              const SizedBox(height: 10),

              // 4. 설명 문구
              RevealWidget(
                controller: _revealController,
                start: 0.28,
                duration: 0.35,
                child: const Text(
                  '피부 진단 결과가 준비되었습니다.\n아래에서 원하는 항목을 선택하세요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: WellLessColors.dim,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 90),

              // 5. 첫 번째 빨간 버튼
              RevealWidget(
                controller: _revealController,
                start: 0.38,
                duration: 0.4,
                child: _HomeCard(
                  active: true,
                  title: '피부 레포트 보러가기',
                  subtitle: '최신 진단 결과 · 루틴 분석',
                  onTap: widget.onReport,
                ),
              ),
              const SizedBox(height: 12),

              // 6. 두 번째 dark 버튼 (Staggered 80ms after first button)
              RevealWidget(
                controller: _revealController,
                start: 0.48,
                duration: 0.4,
                child: _HomeCard(
                  title: '이전 기록 보러가기',
                  subtitle: '과거 진단 내역 · 변화 추이',
                  onTap: widget.onHistory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

class _FaceImageReveal extends StatelessWidget {
  const _FaceImageReveal({
    required this.child,
    required this.controller,
    required this.start,
    required this.duration,
  });

  final Widget child;
  final AnimationController controller;
  final double start;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );
    final scale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scale.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _TitleReveal extends StatelessWidget {
  const _TitleReveal({
    required this.child,
    required this.controller,
    required this.start,
    required this.duration,
  });

  final Widget child;
  final AnimationController controller;
  final double start;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );
    final scale = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );
    final translate = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: const Cubic(0.22, 1.0, 0.36, 1.0)),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0.0, translate.value),
            child: Transform.scale(
              scale: scale.value,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _CardReveal extends StatelessWidget {
  const _CardReveal({
    required this.child,
    required this.controller,
    required this.start,
    required this.duration,
  });

  final Widget child;
  final AnimationController controller;
  final double start;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
    );
    final translate = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0), curve: const Cubic(0.22, 1.0, 0.36, 1.0)),
      ),
    );
    final scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.96, end: 1.02).chain(CurveTween(curve: Curves.easeOut)), weight: 80),
      TweenSequenceItem(tween: Tween<double>(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 20),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, (start + duration).clamp(0.0, 1.0)),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0.0, translate.value),
            child: Transform.scale(
              scale: scale.value,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
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

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  bool _details = false;
  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _revealController.forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FlowScaffold(
    title: '피부 진단 레포트',
    onBack: widget.onBack,
    footer: RevealWidget(
      controller: _revealController,
      start: 0.76,
      duration: 0.24,
      child: PrimaryButton(label: '제품 등록하기 →', onPressed: widget.onRegister),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        RevealWidget(
          controller: _revealController,
          start: 0.0,
          duration: 0.3,
          child: const SectionEyebrow('WHS-2026-1234', color: WellLessColors.muted),
        ),
        const SizedBox(height: 8),
        RevealWidget(
          controller: _revealController,
          start: 0.08,
          duration: 0.3,
          child: const Text(
            '2026년 08월 04일',
            style: TextStyle(fontSize: 10, color: WellLessColors.dim),
          ),
        ),
        Center(
          child: _FaceImageReveal(
            controller: _revealController,
            start: 0.16,
            duration: 0.45,
            child: Image.asset(
              'assets/images/skin_face_2.png',
              width: 154,
              height: 174,
              fit: BoxFit.contain,
            ),
          ),
        ),
        RevealWidget(
          controller: _revealController,
          start: 0.28,
          duration: 0.3,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 1,
                  color: WellLessColors.border,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                  alignment: _details ? Alignment.bottomRight : Alignment.bottomLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      height: 2,
                      color: WellLessColors.primary,
                    ),
                  ),
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
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _details
              ? const _DetailedMetrics()
              : _SkinTypeSummary(revealController: _revealController),
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
      color: Colors.transparent,
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
  const _SkinTypeSummary({required this.revealController});

  final AnimationController revealController;

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
          _TitleReveal(
            controller: revealController,
            start: 0.36,
            duration: 0.3,
            child: Text(
              '#OSP',
              style: condensed(
                size: 54,
                weight: FontWeight.w900,
                color: WellLessColors.primary,
                height: 0.9,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: RevealWidget(
              controller: revealController,
              start: 0.44,
              duration: 0.3,
              child: const Column(
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
          ),
        ],
      ),
      const SizedBox(height: 38),
      RevealWidget(
        controller: revealController,
        start: 0.52,
        duration: 0.3,
        child: const Text(
          '다른 피부 타입도 확인해볼까요?',
          style: TextStyle(fontSize: 12, color: WellLessColors.dim),
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          for (var index = 0; index < _skinFamilies.length; index++) ...[
            Expanded(
              child: _CardReveal(
                controller: revealController,
                start: 0.58 + (index * 0.08),
                duration: 0.25,
                child: _TypeCard(
                  code: _skinFamilies[index].code,
                  label: _skinFamilies[index].label,
                  active: _skinFamilies[index].code == 'O',
                  onTap: () => _showTypes(context, _skinFamilies[index]),
                ),
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

class _SkinTypeSheet extends StatefulWidget {
  const _SkinTypeSheet({required this.family, super.key});

  final _SkinFamilyData family;

  @override
  State<_SkinTypeSheet> createState() => _SkinTypeSheetState();
}

class _SkinTypeSheetState extends State<_SkinTypeSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sheetTranslateY;
  late final Animation<double> _sheetOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _sheetTranslateY = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _sheetOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _sheetOpacity.value,
          child: Transform.translate(
            offset: Offset(0.0, _sheetTranslateY.value),
            child: child,
          ),
        );
      },
      child: Container(
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
                      widget.family.code,
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
                          widget.family.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          widget.family.description,
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
              ...List.generate(widget.family.types.length, (index) {
                final item = widget.family.types[index];
                
                final start = 0.2 + (index * 0.08);
                final end = (start + 0.3).clamp(0.0, 1.0);
                
                final itemOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(start, end, curve: Curves.easeOut),
                  ),
                );
                
                final itemTranslateY = Tween<double>(begin: 7.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(start, end, curve: const Cubic(0.22, 1.0, 0.36, 1.0)),
                  ),
                );
                
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: itemOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0.0, itemTranslateY.value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricsLegend extends StatelessWidget {
  const _MetricsLegend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: WellLessColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '내 피부상태',
            style: TextStyle(fontSize: 10, color: WellLessColors.text),
          ),
          const SizedBox(width: 12),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: WellLessColors.dim,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '평균',
            style: TextStyle(fontSize: 10, color: WellLessColors.dim),
          ),
        ],
      ),
    );
  }
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
          _MetricsLegend(),
          MetricBar('모공', 0.44, 0.79, delay: Duration(milliseconds: 0)),
          MetricBar('블랙헤드', 0.56, 0.61, delay: Duration(milliseconds: 140)),
          MetricBar('광채', 0.77, 0.86, delay: Duration(milliseconds: 280)),
          MetricBar('홍조', 0.75, 0.91, delay: Duration(milliseconds: 420)),
          MetricBar('다크서클', 0.98, 0.89, delay: Duration(milliseconds: 560)),
          MetricBar('여드름', 0.89, 0.86, delay: Duration(milliseconds: 700)),
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

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  final selected = <String>{'클렌징젤', '클렌징폼', '오일'};
  double _scrollPosition = 4.0;
  late final AnimationController _snapController;
  Animation<double>? _snapAnimation;

  int get _selectedIndex => _scrollPosition.round().clamp(0, 7);

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _snapController.addListener(() {
      if (_snapController.isAnimating && _snapAnimation != null) {
        setState(() {
          _scrollPosition = _snapAnimation!.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_snapController.isAnimating) {
      _snapController.stop();
    }
    setState(() {
      _scrollPosition = (_scrollPosition - (details.primaryDelta! / 44.0)).clamp(0.0, 7.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final target = _scrollPosition.round().toDouble().clamp(0.0, 7.0);
    final start = _scrollPosition;

    _snapAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: start, end: target + (target - start > 0 ? 0.05 : -0.05))
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 80,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: target + (target - start > 0 ? 0.05 : -0.05), end: target)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 20,
      ),
    ]).animate(_snapController);

    _snapController.forward(from: 0.0);
  }

  (double, double) _getBottleSize(int index) {
    return switch (index) {
      0 => (100.0, 200.0), // 스킨/토너: Standard
      1 => (110.0, 180.0), // 클렌징폼/젤: Tube
      2 => (90.0, 170.0),  // 에센스/세럼/앰플: Dropper
      3 => (130.0, 120.0), // 클렌징오일/밤: Jar
      4 => (80.0, 210.0),  // 미스트/오일: Slim
      5 => (95.0, 150.0),  // 필링&스크럽: Short container
      6 => (105.0, 190.0), // 로션: Pump bottle
      7 => (115.0, 200.0), // 클렌징워터/밀크: Large round bottle
      _ => (100.0, 200.0),
    };
  }

  double getXOffset(double y) {
    final absY = y.abs();
    final factor = (absY / 130.0).clamp(0.0, 1.0);
    final drop = (1.0 - factor * factor) * 32.0;
    return 52.0 + drop;
  }

  Widget _buildBottle(int index) {
    final size = _getBottleSize(index);
    return SvgPicture.asset(
      'assets/icons/category_bottle.svg',
      key: ValueKey(index),
      width: size.$1,
      height: size.$2,
      fit: BoxFit.contain,
    );
  }

  List<Widget> _buildCategoryItems() {
    final list = <Widget>[];
    
    // Left items
    for (int i = 0; i < _leftCategories.length; i++) {
      final y = (i - _scrollPosition) * 44.0;
      final distance = (i - _scrollPosition).abs();
      final opacity = (1.0 - (distance * 0.36)).clamp(0.0, 1.0);
      if (opacity <= 0.0) continue;
      
      final scale = (1.12 - (distance * 0.12)).clamp(0.78, 1.12);
      
      final cat = _leftCategories[i];
      final isSelected = selected.contains(cat);
      
      Color textColor;
      if (isSelected) {
        textColor = WellLessColors.primary;
      } else if (i == _selectedIndex) {
        textColor = Colors.white;
      } else {
        textColor = WellLessColors.dim;
      }
      
      final fontWeight = i == _selectedIndex ? FontWeight.w900 : FontWeight.w700;
      
      list.add(
        Positioned(
          right: 125.0 + getXOffset(y),
          top: 130.0 + y - (18.0 * scale),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected.contains(cat)) {
                      selected.remove(cat);
                    } else {
                      selected.add(cat);
                    }
                  });
                },
                child: SizedBox(
                  width: 120,
                  height: 36,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: fontWeight,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Right items
    for (int i = 0; i < _rightCategories.length; i++) {
      final y = (i - _scrollPosition) * 44.0;
      final distance = (i - _scrollPosition).abs();
      final opacity = (1.0 - (distance * 0.36)).clamp(0.0, 1.0);
      if (opacity <= 0.0) continue;
      
      final scale = (1.12 - (distance * 0.12)).clamp(0.78, 1.12);
      
      final cat = _rightCategories[i];
      final isSelected = selected.contains(cat);
      
      Color textColor;
      if (isSelected) {
        textColor = WellLessColors.primary;
      } else if (i == _selectedIndex) {
        textColor = Colors.white;
      } else {
        textColor = WellLessColors.dim;
      }
      
      final fontWeight = i == _selectedIndex ? FontWeight.w900 : FontWeight.w700;
      
      list.add(
        Positioned(
          left: 125.0 + getXOffset(y),
          top: 130.0 + y - (18.0 * scale),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected.contains(cat)) {
                      selected.remove(cat);
                    } else {
                      selected.add(cat);
                    }
                  });
                },
                child: SizedBox(
                  width: 120,
                  height: 36,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: fontWeight,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

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
          child: GestureDetector(
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
            child: SizedBox(
              width: 250,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Floating Label above bottle silhouette
                  Positioned(
                    top: 10,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        final isIncoming = child.key == ValueKey(_selectedIndex);
                        final translate = Tween<double>(
                          begin: isIncoming ? 4.0 : -4.0,
                          end: 0.0,
                        ).animate(animation);
                        
                        return FadeTransition(
                          opacity: animation,
                          child: AnimatedBuilder(
                            animation: animation,
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(0.0, translate.value),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(_selectedIndex),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: WellLessColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_leftCategories[_selectedIndex]} / ${_rightCategories[_selectedIndex]}',
                          style: condensed(
                            size: 11,
                            weight: FontWeight.w800,
                            color: WellLessColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Product Silhouette Morph Switcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final isIncoming = child.key == ValueKey(_selectedIndex);
                      if (isIncoming) {
                        final scale = TweenSequence<double>([
                          TweenSequenceItem(tween: Tween<double>(begin: 0.88, end: 1.03).chain(CurveTween(curve: Curves.easeOut)), weight: 80),
                          TweenSequenceItem(tween: Tween<double>(begin: 1.03, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 20),
                        ]).animate(animation);
                        
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: scale, child: child),
                        );
                      } else {
                        final scale = Tween<double>(begin: 0.88, end: 1.0).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: scale, child: child),
                        );
                      }
                    },
                    child: _buildBottle(_selectedIndex),
                  ),
                  
                  // Curved Carousel items
                  ..._buildCategoryItems(),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

const _leftCategories = [
  '토너',
  '스킨',
  '에센스',
  '앰플',
  '오일',
  '세럼',
  '로션',
  '미스트',
];

const _rightCategories = [
  '클렌징젤',
  '클렌징폼',
  '클렌징티슈',
  '클렌징오일',
  '클렌징밤',
  '필링&스크럽',
  '클렌징워터',
  '클렌징밀크',
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
    with TickerProviderStateMixin {
  late final AnimationController _revealController;
  late final AnimationController _breathController;
  Timer? timer;

  late final Animation<double> _guideOpacity;
  late final Animation<double> _guideTranslateY;
  late final Animation<double> _mainOpacity;
  late final Animation<double> _mainTranslateY;
  late final Animation<double> _lineReveal;
  late final Animation<double> _subtitleOpacity;

  late final Animation<double> _lineBreath;
  late final Animation<double> _subtitleBreath;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _guideOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.0, 0.33, curve: Curves.easeOut)),
    );
    _guideTranslateY = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.0, 0.33, curve: Curves.easeOut)),
    );

    _mainOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.18, 0.58, curve: Curves.easeOut)),
    );
    _mainTranslateY = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.18, 0.58, curve: Curves.easeOut)),
    );

    _lineReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.44, 0.76, curve: Curves.easeOut)),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.66, 1.0, curve: Curves.easeOut)),
    );

    _lineBreath = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.96).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.96, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
    ]).animate(_breathController);

    _subtitleBreath = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.85).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.85, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
    ]).animate(_breathController);

    _revealController.forward().then((_) {
      if (mounted) {
        _breathController.repeat();
      }
    });

    timer = Timer(const Duration(milliseconds: 1800), widget.onComplete);
  }

  @override
  void dispose() {
    timer?.cancel();
    _revealController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Guide Text
                    AnimatedBuilder(
                      animation: _revealController,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(0.0, _guideTranslateY.value),
                          child: Opacity(
                            opacity: _guideOpacity.value,
                            child: const Text(
                              '잠시만 기다려주세요.',
                              style: TextStyle(color: WellLessColors.dim, fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Main Title
                    AnimatedBuilder(
                      animation: _revealController,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(0.0, _mainTranslateY.value),
                          child: Opacity(
                            opacity: _mainOpacity.value,
                            child: Text.rich(
                              const TextSpan(
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
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
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 38),

                    // Underline red bar with breathing/drawing animation
                    AnimatedBuilder(
                      animation: Listenable.merge([_revealController, _breathController]),
                      builder: (context, _) {
                        final widthFactor = _breathController.isAnimating ? _lineBreath.value : _lineReveal.value;
                        return Container(
                          width: 154,
                          height: 2,
                          color: WellLessColors.divider,
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: widthFactor,
                            child: Container(
                              color: WellLessColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 26),

                    // Subtitle Text
                    AnimatedBuilder(
                      animation: Listenable.merge([_revealController, _breathController]),
                      builder: (context, _) {
                        final opacity = _breathController.isAnimating ? _subtitleBreath.value : _subtitleOpacity.value;
                        return Opacity(
                          opacity: opacity,
                          child: Text(
                            'ANALYSIS INGREDIENTS DATA',
                            style: condensed(
                              size: 18,
                              weight: FontWeight.w200,
                              color: WellLessColors.dim,
                            ),
                          ),
                        );
                      },
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
}

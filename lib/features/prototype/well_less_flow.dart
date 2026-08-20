import 'dart:async';

import 'package:flutter/material.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/screens/analysis_screens.dart';
import 'package:well_less_app/features/prototype/screens/commerce_screens.dart';
import 'package:well_less_app/features/prototype/screens/intake_screens.dart';

enum FlowStep {
  splashKorean,
  splashBrand,
  code,
  home,
  report,
  category,
  productInput,
  camera,
  loading,
  routine,
  suitability,
  finalRoutine,
  cart,
  orderComplete,
}

class WellLessFlow extends StatefulWidget {
  const WellLessFlow({super.key});

  @override
  State<WellLessFlow> createState() => _WellLessFlowState();
}

class _WellLessFlowState extends State<WellLessFlow> {
  FlowStep _step = FlowStep.splashKorean;
  final List<FlowStep> _history = [];
  bool _productAdded = false;
  bool _replacementSelected = false;

  @override
  void initState() {
    super.initState();
  }

  void _go(FlowStep step) {
    setState(() {
      _history.add(_step);
      _step = step;
    });
  }

  void _back() {
    if (_history.isEmpty) return;
    setState(() => _step = _history.removeLast());
  }

  void _replaceSelected() => setState(() => _replacementSelected = true);

  int _getPageIndex(FlowStep step) {
    return switch (step) {
      FlowStep.code => 0,
      FlowStep.home => 1,
      FlowStep.report => 2,
      FlowStep.category => 3,
      FlowStep.productInput || FlowStep.camera => 4,
      FlowStep.loading || FlowStep.routine => 5,
      FlowStep.suitability || FlowStep.finalRoutine => 6,
      _ => 0,
    };
  }

  bool _shouldShowIndicator(FlowStep step) {
    return step == FlowStep.code ||
        step == FlowStep.home ||
        step == FlowStep.report ||
        step == FlowStep.category ||
        step == FlowStep.productInput ||
        step == FlowStep.camera ||
        step == FlowStep.loading ||
        step == FlowStep.routine ||
        step == FlowStep.suitability ||
        step == FlowStep.finalRoutine;
  }

  @override
  Widget build(BuildContext context) {
    final screen = switch (_step) {
      FlowStep.splashKorean => IntroSplashScreen(
        onComplete: () => setState(() => _step = FlowStep.code),
      ),
      FlowStep.splashBrand => const SizedBox.shrink(),
      FlowStep.code => CodeScreen(onSuccess: () => _go(FlowStep.home)),
      FlowStep.home => HomeScreen(
        onReport: () => _go(FlowStep.report),
        onHistory: () => _go(FlowStep.finalRoutine),
      ),
      FlowStep.report => ReportScreen(
        onBack: _back,
        onRegister: () => _go(FlowStep.category),
      ),
      FlowStep.category => CategoryScreen(
        onBack: _back,
        onContinue: () => _go(FlowStep.productInput),
      ),
      FlowStep.productInput => ProductInputScreen(
        productAdded: _productAdded,
        onBack: _back,
        onCamera: () => _go(FlowStep.camera),
        onAnalyze: () => _go(FlowStep.loading),
      ),
      FlowStep.camera => CameraScreen(
        onCancel: _back,
        onCapture: () {
          _productAdded = true;
          _back();
        },
      ),
      FlowStep.loading => LoadingScreen(
        onComplete: () => _go(FlowStep.routine),
      ),
      FlowStep.routine => RoutineScreen(
        onBack: _back,
        onAnalyze: () => _go(FlowStep.suitability),
      ),
      FlowStep.suitability => SuitabilityScreen(
        replacementSelected: _replacementSelected,
        onBack: _back,
        onReplacement: _replaceSelected,
        onFinal: () => _go(FlowStep.finalRoutine),
      ),
      FlowStep.finalRoutine => FinalRoutineScreen(
        onBack: _back,
        onCart: () => _go(FlowStep.cart),
      ),
      FlowStep.cart => CartScreen(
        onBack: _back,
        onPaid: () => _go(FlowStep.orderComplete),
      ),
      FlowStep.orderComplete => OrderCompleteScreen(
        onRoutine: () => _go(FlowStep.finalRoutine),
      ),
    };

    final showIndicator = _shouldShowIndicator(_step);
    final activeIndex = _getPageIndex(_step);

    return Scaffold(
      backgroundColor: WellLessColors.background,
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              transitionBuilder: (child, animation) {
                final isIncoming = child.key == ValueKey(_step);

                if (_step == FlowStep.code) {
                  if (isIncoming) {
                    // Incoming CodeScreen: slides up from bottom
                    final slideIn = Tween<Offset>(
                      begin: const Offset(0.0, 0.08),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slideIn, child: child),
                    );
                  } else {
                    // Outgoing IntroSplashScreen: slides up to top
                    final slideOut = Tween<Offset>(
                      begin: const Offset(0.0, -0.08),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInCubic));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slideOut, child: child),
                    );
                  }
                }

                return FadeTransition(opacity: animation, child: child);
              },
              child: KeyedSubtree(key: ValueKey(_step), child: screen),
            ),
          ),
          AnimatedOpacity(
            opacity: showIndicator ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 450),
            curve: const Cubic(0.22, 1.0, 0.36, 1.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: IgnorePointer(
                ignoring: !showIndicator,
                child: WellLessPageIndicator(activeIndex: activeIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WellLessPageIndicator extends StatelessWidget {
  const WellLessPageIndicator({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: const Cubic(0.22, 1.0, 0.36, 1.0),
          width: isActive ? 18.0 : 4.0,
          height: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          decoration: BoxDecoration(
            color: isActive ? WellLessColors.primary : WellLessColors.dim,
            borderRadius: BorderRadius.circular(2.0),
          ),
        );
      }),
    );
  }
}

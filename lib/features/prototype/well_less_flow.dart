import 'dart:async';

import 'package:flutter/material.dart';
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
    _runSplash();
  }

  Future<void> _runSplash() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _step != FlowStep.splashKorean) return;
    setState(() => _step = FlowStep.splashBrand);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _step != FlowStep.splashBrand) return;
    setState(() => _step = FlowStep.code);
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

  @override
  Widget build(BuildContext context) {
    final screen = switch (_step) {
      FlowStep.splashKorean => const KoreanSplashScreen(),
      FlowStep.splashBrand => const BrandSplashScreen(),
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: KeyedSubtree(key: ValueKey(_step), child: screen),
    );
  }
}

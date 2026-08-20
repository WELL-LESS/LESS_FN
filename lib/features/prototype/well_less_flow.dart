import 'dart:async';

import 'package:flutter/material.dart';
import 'package:well_less_app/core/network/ai_analysis_service.dart';
import 'package:well_less_app/core/network/well_less_api_service.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/ai_analysis.dart';
import 'package:well_less_app/features/prototype/mock_data.dart';
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
  bool _replacementSelected = false;
  final AiAnalysisService _aiAnalysisService = AiAnalysisService();
  final WellLessApiService _apiService = WellLessApiService();
  final Map<String, String> _capturedImages = {};
  final Set<String> _uploadedImagePaths = {};
  List<String> _selectedCategories = [];
  WellLessSession? _session;
  String? _routineId;
  String? _captureCategory;
  bool _creatingRoutine = false;
  AiRoutineAnalysis? _analysis;

  static const _categoryCodes = <String, String>{
    '클렌징젤': 'CLEANSING_FOAM_GEL',
    '클렌징폼': 'CLEANSING_FOAM_GEL',
    '클렌징티슈': 'CLEANSING_WATER_MILK',
    '클렌징오일': 'CLEANSING_OIL_BALM',
    '클렌징밤': 'CLEANSING_OIL_BALM',
    '필링&스크럽': 'EXFOLIATOR',
    '클렌징워터': 'CLEANSING_WATER_MILK',
    '클렌징밀크': 'CLEANSING_WATER_MILK',
    '스킨': 'SKIN_TONER',
    '토너': 'SKIN_TONER',
    '에센스': 'ESSENCE_SERUM_AMPOULE',
    '세럼': 'ESSENCE_SERUM_AMPOULE',
    '앰플': 'ESSENCE_SERUM_AMPOULE',
    '로션': 'LOTION',
    '미스트': 'MIST_OIL',
    '오일': 'MIST_OIL',
  };

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

  Future<String?> _verifyPersonalCode(String personalCode) async {
    try {
      final session = await _apiService.verifyPersonalCode(personalCode);
      if (!mounted) return '화면이 종료되었습니다. 다시 시도해주세요.';
      setState(() => _session = session);
      return null;
    } on WellLessApiException catch (error) {
      return error.message;
    }
  }

  Future<void> _prepareRoutine(List<String> categories) async {
    if (_creatingRoutine) return;
    final session = _session;
    if (session == null) {
      _showMessage('개인 코드 인증이 필요합니다.');
      return;
    }
    final categoryCodes = categories
        .map((category) => _categoryCodes[category])
        .whereType<String>()
        .toSet()
        .toList(growable: false);
    if (categoryCodes.isEmpty) {
      _showMessage('카테고리를 한 개 이상 선택해주세요.');
      return;
    }

    _creatingRoutine = true;
    try {
      final routineId = await _apiService.createRoutine(
        session: session,
        categoryCodes: categoryCodes,
      );
      if (!mounted) return;
      setState(() {
        _selectedCategories = List.of(categories);
        _capturedImages.clear();
        _uploadedImagePaths.clear();
        _routineId = routineId;
      });
      _go(FlowStep.productInput);
    } on WellLessApiException catch (error) {
      _showMessage(error.message);
    } finally {
      _creatingRoutine = false;
    }
  }

  Future<void> _startAnalysis() async {
    final session = _session;
    final routineId = _routineId;
    if (_capturedImages.isEmpty) {
      _showMessage('AI 분석을 위해 제품 사진을 먼저 촬영해주세요.');
      return;
    }
    if (session == null || routineId == null) {
      _showMessage('루틴 세션이 없습니다. 카테고리 선택부터 다시 진행해주세요.');
      return;
    }
    _go(FlowStep.loading);
    try {
      for (final entry in _capturedImages.entries) {
        if (_uploadedImagePaths.contains(entry.value)) continue;
        final categoryCode = _categoryCodes[entry.key];
        if (categoryCode == null) continue;
        await _apiService.uploadProductImage(
          session: session,
          routineId: routineId,
          categoryCode: categoryCode,
          imagePath: entry.value,
        );
        _uploadedImagePaths.add(entry.value);
      }
      final analysis = await _aiAnalysisService.analyzeRoutine(
        accessToken: session.accessToken,
        routineId: routineId,
        profileCode: session.skinTypeCode,
        imagePaths: _capturedImages.values.toList(growable: false),
      );
      if (!mounted) return;
      setState(() {
        _analysis = analysis;
        _history.add(_step);
        _step = FlowStep.routine;
      });
    } on AiAnalysisException catch (error) {
      if (!mounted) return;
      setState(() => _step = FlowStep.productInput);
      _showMessage(error.message);
    } on WellLessApiException catch (error) {
      if (!mounted) return;
      setState(() => _step = FlowStep.productInput);
      _showMessage(error.message);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

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
      FlowStep.code => CodeScreen(
        onSubmit: _verifyPersonalCode,
        onSuccess: () => _go(FlowStep.home),
      ),
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
        onContinue: _prepareRoutine,
      ),
      FlowStep.productInput => ProductInputScreen(
        categories: _selectedCategories,
        capturedImages: _capturedImages,
        onBack: _back,
        onCamera: (category) {
          _captureCategory = category;
          _go(FlowStep.camera);
        },
        onAnalyze: _startAnalysis,
      ),
      FlowStep.camera => CameraScreen(
        onCancel: _back,
        onCapture: (path) {
          final category = _captureCategory;
          if (category != null) {
            final previousPath = _capturedImages[category];
            if (previousPath != null) _uploadedImagePaths.remove(previousPath);
            _capturedImages[category] = path;
          }
          _back();
        },
      ),
      FlowStep.loading => LoadingScreen(onComplete: () {}),
      FlowStep.routine => RoutineScreen(
        onBack: _back,
        onAnalyze: () => _go(FlowStep.suitability),
        products: _analysis?.products
            .map(
              (product) => RoutineProduct(
                product.name,
                product.category,
                product.description,
              ),
            )
            .toList(growable: false),
      ),
      FlowStep.suitability => SuitabilityScreen(
        replacementSelected: _replacementSelected,
        onBack: _back,
        onReplacement: _replaceSelected,
        onFinal: () => _go(FlowStep.finalRoutine),
        analysis: _analysis,
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
  const WellLessPageIndicator({required this.activeIndex, super.key});

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

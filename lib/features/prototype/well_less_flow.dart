import 'dart:async';

import 'package:flutter/material.dart';
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
  final WellLessApiService _apiService = WellLessApiService();
  final Map<String, List<String>> _capturedImages = {};
  final List<String> _captureOrder = [];
  final Map<String, String> _uploadedInputIdsByPath = {};
  List<String> _selectedCategories = [];
  WellLessSession? _session;
  String? _routineId;
  String? _captureCategory;
  bool _creatingRoutine = false;
  AiRoutineAnalysis? _analysis;

  static const _demoProductNames = <String>[
    '독도 토너',
    '자작나무 수분 로션',
    '메노킨 선크림',
    '제주 알로에 수딩젤',
    '달바 화이트 트러플 엑소 인텐시브 세럼',
  ];

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
        _captureOrder.clear();
        _uploadedInputIdsByPath.clear();
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
    if (_capturedImages.isEmpty) {
      _showMessage('AI 분석을 위해 제품 사진을 먼저 촬영해주세요.');
      return;
    }

    // Hackathon demo mode: keep the camera experience, but avoid all image
    // uploads and OpenAI calls so the presentation is independent of quota
    // and network conditions.
    _go(FlowStep.loading);
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      _analysis = _buildDemoAnalysis();
      _step = FlowStep.routine;
    });
  }

  AiRoutineAnalysis _buildDemoAnalysis() {
    const products = <AiAnalyzedProduct>[
      AiAnalyzedProduct(
        name: '독도 토너',
        category: '토너',
        description: '판테놀·베타인·알란토인을 함유해 세안 후 피부결을 정돈하고 편안한 수분감을 더해주는 기본 토너입니다.',
        score: 60,
        ingredients: ['판테놀', '베타인', '알란토인', '해수'],
      ),
      AiAnalyzedProduct(
        name: '자작나무 수분 로션',
        category: '로션',
        description: '비타민C 계열과 보습 성분을 통해 피부톤과 수분 관리를 보완합니다. 다만 P축 역할이 선크림과 겹쳐 루틴 간소화를 위한 정리 검토 제품으로 선정됐습니다.',
        score: 55,
        ingredients: ['아스코빅애씨드(P)', '히알루론산(C)', '토코페롤(N)', '자작나무수액'],
      ),
      AiAnalyzedProduct(
        name: '메노킨 선크림',
        category: '선크림',
        description:
            '나이아신아마이드와 비타민C 계열이 O·P축을 보완하며, 마지막 단계에서 자외선으로부터 피부를 보호합니다.',
        score: 66,
        ingredients: ['병풀추출물(S)', '알로에베라잎수', '녹차추출물', '감초뿌리추출물'],
      ),
      AiAnalyzedProduct(
        name: '제주 알로에 수딩젤',
        category: '수딩젤',
        description: '알로에베라잎수와 병풀추출물이 피부에 수분을 공급하고 S축의 진정 관리를 보완합니다.',
        score: 73,
        ingredients: ['나이아신아마이드(O)', '비타민C 계열(P)', '세라마이드NP(D)', '자외선 차단 성분'],
      ),
      AiAnalyzedProduct(
        name: '달바 화이트 트러플 엑소 인텐시브 세럼',
        category: '세럼',
        description: '제품 성분 정보를 확인할 수 없어 피부 적합도 측정이 불가합니다.',
        score: 0,
        ingredients: [],
      ),
    ];
    return const AiRoutineAnalysis(
      products: products,
      overallScore: 68,
      summary: '5개 제품을 분석한 결과 현재 루틴 적합도는 68%입니다.',
      removeCandidates: <AiRemoveCandidate>[
        AiRemoveCandidate(
          product: '자작나무 수분 로션',
          reason: '선크림과 P축 역할이 겹쳐 루틴 간소화를 위한 정리를 검토할 수 있습니다.',
          scoreAfterRemoval: 72,
        ),
        AiRemoveCandidate(
          product: '달바 화이트 트러플 엑소 인텐시브 세럼',
          reason: '성분 정보 부족으로 적합도 측정이 불가합니다.',
          scoreAfterRemoval: 72,
        ),
      ],
    );
  }

  Future<void> _removeCapturedImage(String category, String imagePath) async {
    final inputId = _uploadedInputIdsByPath[imagePath];
    final session = _session;
    final routineId = _routineId;
    if (inputId != null && session != null && routineId != null) {
      try {
        await _apiService.deleteProductInput(
          session: session,
          routineId: routineId,
          inputId: inputId,
        );
      } on WellLessApiException catch (error) {
        _showMessage(error.message);
        return;
      }
    }
    if (!mounted) return;
    setState(() {
      final images = _capturedImages[category];
      images?.remove(imagePath);
      _captureOrder.remove(imagePath);
      if (images != null && images.isEmpty) _capturedImages.remove(category);
      _uploadedInputIdsByPath.remove(imagePath);
    });
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
        productNames: {
          for (var index = 0; index < _captureOrder.length; index++)
            _captureOrder[index]:
                _demoProductNames[index.clamp(0, _demoProductNames.length - 1)],
        },
        onBack: _back,
        onCamera: (category) {
          _captureCategory = category;
          _go(FlowStep.camera);
        },
        onRemove: _removeCapturedImage,
        onAnalyze: _startAnalysis,
      ),
      FlowStep.camera => CameraScreen(
        onCancel: _back,
        onCapture: (path) {
          final category = _captureCategory;
          if (category != null) {
            _capturedImages.putIfAbsent(category, () => <String>[]).add(path);
            _captureOrder.add(path);
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/ai_analysis.dart';
import 'package:well_less_app/features/prototype/screens/analysis_screens.dart';
import 'package:well_less_app/features/prototype/screens/commerce_screens.dart';
import 'package:well_less_app/features/prototype/screens/intake_screens.dart';
import 'package:well_less_app/main.dart';

void main() {
  testWidgets('splash advances to the personal code screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('더적게'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1900));

    expect(find.text('고객 번호를 입력해주세요.'), findsOneWidget);
    expect(find.text('WHS-2026-XXXX'), findsOneWidget);
  });

  testWidgets('all skin family cards open their type information', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(370, 824));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: WellLessTheme.dark,
        home: ReportScreen(onBack: () {}, onRegister: () {}),
      ),
    );

    await tester.tap(find.text('D'));
    await tester.pumpAndSettle();

    expect(find.text('건성 피부'), findsOneWidget);
    expect(find.text('DSP'), findsOneWidget);
  });

  testWidgets('AAC replacement selects in place and opens comparison', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(370, 824));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: WellLessTheme.dark,
        home: StatefulBuilder(
          builder: (context, setState) => SuitabilityScreen(
            replacementSelected: selected,
            onBack: () {},
            onReplacement: () => setState(() => selected = true),
            onFinal: () {},
          ),
        ),
      ),
    );

    final replaceButton = find.text('↻ AAC 교체').first;
    await tester.scrollUntilVisible(replaceButton, 180);
    await tester.tap(replaceButton);
    await tester.pumpAndSettle();

    expect(find.text('성분 비교'), findsOneWidget);
    expect(find.text('✓ AAC 교체'), findsOneWidget);
    expect(find.text('✓ AAC 제품으로 교체'), findsNothing);
  });

  testWidgets('confirmed removal keeps the red product frame visible', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(370, 824));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: WellLessTheme.dark,
        home: SuitabilityScreen(
          replacementSelected: false,
          onBack: () {},
          onReplacement: () {},
          onFinal: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final removeButton = find.text('× 제거').first;
    await tester.scrollUntilVisible(removeButton, 180);
    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    expect(find.text('✓ 제거 확정'), findsOneWidget);
    expect(find.text("Paula's Choice BHA 2%"), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AI routine list fits without bottom overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(370, 824));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: WellLessTheme.dark,
        home: RoutineScreen(onBack: () {}, onAnalyze: () {}),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();

    expect(find.text('Laneige 워터뱅크 블루 HA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('final routine fits the demo viewport without overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(370, 824));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: WellLessTheme.dark,
        home: FinalRoutineScreen(onBack: () {}, onCart: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.task_alt_rounded), findsOneWidget);
    expect(find.text('AAC 세이프 BHA 세럼'), findsOneWidget);
  });

  testWidgets('OpenAI analysis values appear in routine and score screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(370, 824));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const analysis = AiRoutineAnalysis(
      products: [
        AiAnalyzedProduct(
          name: 'OpenAI 분석 세럼',
          category: '세럼',
          description: '나이아신아마이드 성분 분석',
          score: 72,
          ingredients: ['나이아신아마이드'],
        ),
      ],
      overallScore: 72,
      summary: '촬영 제품의 루틴 적합도 분석 결과입니다.',
      removeCandidates: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: WellLessTheme.dark,
        home: SuitabilityScreen(
          replacementSelected: false,
          onBack: () {},
          onReplacement: () {},
          onFinal: () {},
          analysis: analysis,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('72'), findsWidgets);
    expect(find.text('OpenAI 분석 세럼'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

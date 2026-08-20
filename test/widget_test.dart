import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
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
}

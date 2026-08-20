import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:well_less_app/core/theme/well_less_theme.dart';
import 'package:well_less_app/features/prototype/well_less_flow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: WellLessColors.background,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: WellLessColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'WELL LESS',
    debugShowCheckedModeBanner: false,
    theme: WellLessTheme.dark,
    home: const WellLessFlow(),
  );
}

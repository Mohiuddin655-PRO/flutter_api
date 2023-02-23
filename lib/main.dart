import 'package:flutter/material.dart';
import 'package:flutter_api/feature/presentation/page/home/home_page.dart';

import 'core/constants/app_info.dart';
import 'core/constants/themes.dart';
import 'dependency_injection.dart' as di;
import 'on_generate_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      title: AppInfo.name,
      initialRoute: HomePage.route,
      onGenerateRoute: OnGenerateRoute.route,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nrouter/main_no_web_setup.dart'
    // https://dart.dev/interop/js-interop/package-web#conditional-imports
    if (dart.library.js_interop) 'package:nrouter/main_web_setup.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/page/root.dart';
import 'package:nrouter/page/search.dart';
import 'package:nrouter/page/setting.dart';
import 'package:nrouter/page/user.dart';
import 'package:nrouter/router.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: n.NRouterDelegate<RouterPage>(
        parserAndBuilder: parserAndBuilder,
        builder: (location, context) => switch (location) {
          RootPage() => location,
          SettingPage() => location,
          UserPage() => location,
          SearchPage() => location,
          _ => Scaffold(
              appBar: AppBar(
                title: const Text('404'),
              ),
              body: const Center(
                child: Text('404'),
              ),
            )
        },
        debug: true,
      ),
      routeInformationParser: n.NRouterRouteInformationParser(),
    );
  }
}

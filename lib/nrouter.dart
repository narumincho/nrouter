import 'package:flutter/material.dart';
import 'package:nrouter/no_web.dart'
    // https://dart.dev/interop/js-interop/package-web#conditional-imports
    if (dart.library.js_interop) 'package:nrouter/web.dart';
import 'package:nrouter/parser_and_builder.dart' as n;

export 'package:nrouter/parser_and_builder.dart';

class NRouterRouteInformationParser extends RouteInformationParser<Uri> {
  NRouterRouteInformationParser();

  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async {
    print(('called parseRouteInformation', routeInformation.uri));
    return routeInformation.uri;
  }

  @override
  RouteInformation? restoreRouteInformation(Uri configuration) {
    print(('called restoreRouteInformation', configuration));
    return RouteInformation(uri: configuration);
  }
}

class NRouterDelegate<T> extends RouterDelegate<Uri> with ChangeNotifier {
  NRouterDelegate({
    required this.parserAndBuilder,
    required this.builder,
  }) {
    print('init NRouterDelegate');
  }

  Uri? current;
  final n.ParserAndBuilder<T, Uri> parserAndBuilder;
  Widget Function(T, BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    print(('called build', current));
    return NRouter(
      routerDelegate: this,
      child: switch (current) {
        null => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        final parsed => builder(parserAndBuilder.parser(parsed), context)
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    print(('called popRoute', current));
    return true;
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    print(('called setNewRoutePath', configuration));
    current = configuration;
  }

  @override
  Future<void> setInitialRoutePath(Uri configuration) {
    print(('called setInitialRoutePath', configuration));
    current = configuration;
    return super.setInitialRoutePath(configuration);
  }
}

class NRouter<T> extends InheritedWidget {
  const NRouter({
    super.key,
    required this.routerDelegate,
    required super.child,
  });

  final NRouterDelegate<T> routerDelegate;

  static NRouter<T> of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<NRouter<T>>();
    if (result == null) {
      throw Exception('No NRouter found in context');
    }
    return result;
  }

  @override
  bool updateShouldNotify(NRouter<T> oldWidget) {
    return routerDelegate != oldWidget.routerDelegate;
  }
}

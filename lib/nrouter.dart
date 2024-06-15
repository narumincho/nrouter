import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

  IList<Uri> history = const IListConst([]);
  final n.ParserAndBuilder<T, Uri> parserAndBuilder;
  Widget Function(T, BuildContext) builder;
  final Key key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    print(('called build', history));

    switch (history.lastOrNull) {
      case null:
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   switch (locationHref()) {
        //     case final uri?:
        //       setNewRoutePath(uri);
        //       notifyListeners();
        //       break;
        //   }
        // });
        return NRouter(
          routerDelegate: this,
          child: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      default:
        return NRouter(
          routerDelegate: this,
          child: builder(parserAndBuilder.parser(history.lastOrNull!), context),
        );
    }
  }

  @override
  Future<bool> popRoute() async {
    print(('called popRoute', history));
    if (history.isNotEmpty) {
      history = history.removeLast();
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    print(('called setNewRoutePath', configuration));
    history = history.add(configuration);
  }

  // @override
  // Future<void> setInitialRoutePath(Uri configuration) {
  //   print(('called setInitialRoutePath', configuration));
  //   current = configuration;
  //   return super.setInitialRoutePath(configuration);
  // }

  void push(T route) {
    history = history.add(parserAndBuilder.builder(route));
    notifyListeners();
  }

  void replace(T route) {
    if (history.isEmpty) {
      history = history.add(parserAndBuilder.builder(route));
    } else {
      history = history.removeLast().add(parserAndBuilder.builder(route));
    }
    notifyListeners();
  }

  void pop() {
    if (canPop()) {
      history = history.removeLast();
      notifyListeners();
    }
  }

  bool canPop() {
    return history.length > 1;
  }
}

// ここの部分を riverpod を利用する形にしても良いかも
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

  void push(T route) {
    routerDelegate.push(route);
  }

  void replace(T route) {
    routerDelegate.replace(route);
  }

  void pop() {
    routerDelegate.pop();
  }

  bool canPop() {
    return routerDelegate.canPop();
  }
}

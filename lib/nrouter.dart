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
    routeInformation;
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
    cancelListenPopEvent = listenLocationChange((uri) {
      print('on pop $uri');
      nextIsBrowserBack = true;
    });
    print('init NRouterDelegate');
  }

  IList<Uri> history = const IListConst([]);
  final n.ParserAndBuilder<T, Uri> parserAndBuilder;
  Widget Function(T, BuildContext) builder;
  late void Function() cancelListenPopEvent;
  bool nextIsBrowserBack = false;

  @override
  void dispose() {
    cancelListenPopEvent();
    super.dispose();
  }

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
    print(('called setNewRoutePath', configuration, nextIsBrowserBack));
    if (isSameLast(configuration)) {
      print(('ignored in setNewRoutePath', history.lastOrNull, configuration));
      return;
    }
    if (nextIsBrowserBack) {
      nextIsBrowserBack = false;
      for (final entry in history.reversed) {
        if (entry == configuration) {
          return;
        }
        if (history.isNotEmpty) {
          history = history.removeLast();
        }
      }

      return;
    }
    history = history.add(configuration);
  }

  @override
  Uri get currentConfiguration {
    print(('called currentConfiguration', history));
    return history.lastOrNull ?? Uri.parse('/');
  }

  // @override
  // Future<void> setInitialRoutePath(Uri configuration) {
  //   print(('called setInitialRoutePath', configuration));
  //   history = IList([configuration]);
  //   return super.setInitialRoutePath(configuration);
  // }

  void push(T route) {
    print(('called push', route));
    final newUri = parserAndBuilder.builder(route);
    if (isSameLast(newUri)) {
      print(('ignored in push', history.lastOrNull, newUri));
      return;
    }
    history = history.add(parserAndBuilder.builder(route));
    notifyListeners();
  }

  void replace(T route) {
    if (history.isNotEmpty) {
      history = history.removeLast();
    }
    final newUri = parserAndBuilder.builder(route);
    history = history.add(newUri);

    print(('in replace Router.neglect', history));
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

  bool isSameLast(Uri uri) {
    return history.lastOrNull == uri;
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

  void replace(T route, BuildContext context) {
    Router.neglect(context, () {
      routerDelegate.replace(route);
    });
  }

  void pop() {
    routerDelegate.pop();
  }

  bool canPop() {
    return routerDelegate.canPop();
  }
}

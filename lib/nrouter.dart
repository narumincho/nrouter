import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:narumincho_util/narumincho_util.dart';
import 'package:nrouter/no_web.dart'
    // https://dart.dev/interop/js-interop/package-web#conditional-imports
    if (dart.library.js_interop) 'package:nrouter/web.dart';
import 'package:nrouter/parser_and_builder.dart' as n;

export 'package:nrouter/parser_and_builder.dart';

class NRouterRouteInformationParser
    extends RouteInformationParser<RouteInformation> {
  NRouterRouteInformationParser();

  @override
  Future<RouteInformation> parseRouteInformation(
      RouteInformation routeInformation) async {
    return routeInformation;
  }

  @override
  RouteInformation? restoreRouteInformation(RouteInformation configuration) {
    return configuration;
  }
}

class NRouterDelegate<T> extends RouterDelegate<RouteInformation>
    with ChangeNotifier {
  NRouterDelegate({
    required this.parserAndBuilder,
    required this.builder,
  }) {
    print('init NRouterDelegate');
  }

  IList<Uri> history = const IListConst([]);
  int currentIndex = 0;
  final n.ParserAndBuilder<T, Uri> parserAndBuilder;
  Widget Function(T, BuildContext) builder;
  late void Function() cancelListenPopEvent;

  @override
  void dispose() {
    cancelListenPopEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print((
      'called build',
      history.indexed
          .map((entry) =>
              entry.$2.toString() + (entry.$1 == currentIndex ? ' <' : ''))
          .safeJoin('\n')
    ));

    switch (history.elementAtOrNull(currentIndex)) {
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
  Future<void> setNewRoutePath(RouteInformation configuration) async {
    print(('called setNewRoutePath', configuration, configuration.state));
    if (isSameLast(configuration.uri)) {
      print(('ignored in setNewRoutePath', history.lastOrNull, configuration));
      return;
    }
    final state = configuration.state;
    if (state is int) {
      currentIndex = state;
    } else {
      currentIndex = history.length;
    }
    if (state is int && state < history.length) {
      for (final entry in history.reversed) {
        if (entry == configuration.uri) {
          return;
        }
        if (history.length > 1) {
          history = history.removeLast();
        }
      }

      return;
    }
    history = history.add(configuration.uri);
  }

  @override
  RouteInformation get currentConfiguration {
    print(('called currentConfiguration', history));
    return RouteInformation(
      uri: history.elementAtOrNull(currentIndex) ?? Uri.parse('/'),
      state: currentIndex,
    );
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
      historyBack();
      // history = history.removeLast();
      currentIndex = currentIndex - 1;
      notifyListeners();
    }
  }

  bool canPop() {
    return 0 < currentIndex;
  }

  bool isSameLast(Uri uri) {
    return history.elementAtOrNull(currentIndex) == uri;
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

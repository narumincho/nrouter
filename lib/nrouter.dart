import 'package:flutter/material.dart';
import 'package:nrouter/parser_and_builder.dart' as n;

export 'package:nrouter/parser_and_builder.dart';

class NRouterRouteInformationParser<T> extends RouteInformationParser<T> {
  NRouterRouteInformationParser(this.parserAndBuilder);

  final n.ParserAndBuilder<T, Uri> parserAndBuilder;

  @override
  Future<T> parseRouteInformation(RouteInformation routeInformation) async {
    return parserAndBuilder.parser(routeInformation.uri);
  }

  @override
  RouteInformation? restoreRouteInformation(T configuration) {
    return RouteInformation(uri: parserAndBuilder.builder(configuration));
  }
}

class NRouterDelegate<T> extends RouterDelegate<T> with ChangeNotifier {
  T? current;

  @override
  Widget build(BuildContext context) {
    print(('called build', current));
    return Scaffold(
      appBar: AppBar(
        title: const Text('nrouter test'),
      ),
      body: Text('$current'),
    );
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  Future<void> setNewRoutePath(T configuration) async {
    print(('called setNewRoutePath', configuration));
    current = configuration;
  }

  @override
  Future<void> setInitialRoutePath(T configuration) {
    print(('called setInitialRoutePath', configuration));
    current = configuration;
    return super.setInitialRoutePath(configuration);
  }
}

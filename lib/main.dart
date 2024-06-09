import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: NRouterDelegate<Sample>(),
      routeInformationParser: NRouterRouteInformationParser<Sample>(sample),
      backButtonDispatcher: 3,
    );
  }
}

@immutable
sealed class Sample {
  const Sample();
}

@immutable
class SampleRoot implements Sample {
  const SampleRoot();

  static final parserAndBuilder = n.uri(n.path0, n.map0).map<Sample>(
        (_) => const SampleRoot(),
        (parsed) => switch (parsed) {
          SampleRoot() => const (null, null),
          _ => throw Exception(),
        },
      );
}

@immutable
class SampleSetting implements Sample {
  const SampleSetting();

  static final parserAndBuilder =
      n.uri(n.path1(n.keyword('settings')), n.map0).map<Sample>(
            (_) => const SampleSetting(),
            (parsed) => switch (parsed) {
              SampleSetting() => const (null, null),
              _ => throw Exception(),
            },
          );
}

@immutable
class SampleUser implements Sample {
  const SampleUser({
    required this.id,
    required this.isEdit,
  });

  final int id;
  final bool isEdit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleUser && id == other.id && isEdit == other.isEdit;

  @override
  int get hashCode => Object.hash(id, isEdit);

  static final parserAndBuilder = n
      .uri(
        n.path2(n.keyword('user'), n.integer),
        n.mapOptionalValue('edit'),
      )
      .map<Sample>(
        (parsed) => SampleUser(id: parsed.$1.$2, isEdit: parsed.$2 != null),
        (parsed) => switch (parsed) {
          SampleUser(:final id, :final isEdit) => (
              (null, id),
              isEdit ? '' : null,
            ),
          _ => throw Exception(),
        },
      );
}

@immutable
class SampleSearch implements Sample {
  const SampleSearch({required this.query});

  final String query;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleSearch &&
          runtimeType == other.runtimeType &&
          query == other.query;

  @override
  int get hashCode => query.hashCode;

  static final parserAndBuilder = n
      .uri(
        n.path1(n.keyword('search')),
        n.mapOptionalValue('q'),
      )
      .map<Sample>(
        (raw) => SampleSearch(query: raw.$2 ?? ''),
        (parsed) => switch (parsed) {
          SampleSearch(:final query) => (null, query),
          _ => throw Exception(),
        },
      );
}

final sample = n.oneOf(IList([
  SampleRoot.parserAndBuilder,
  SampleSetting.parserAndBuilder,
  SampleUser.parserAndBuilder,
  SampleSearch.parserAndBuilder,
]));

class NRouterRouteInformationParser<T> extends RouteInformationParser<T> {
  // ignore: library_private_types_in_public_api
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

class NRouterDelegate<T> extends RouterDelegate<T> {
  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> setNewRoutePath(T configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}

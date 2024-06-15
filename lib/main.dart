import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nrouter/main_no_web_setup.dart'
    // https://dart.dev/interop/js-interop/package-web#conditional-imports
    if (dart.library.js_interop) 'package:nrouter/main_web_setup.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:url_launcher/link.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: n.NRouterDelegate<Sample>(
        parserAndBuilder: sample,
        builder: (location, context) => switch (location) {
          SampleRoot() => location,
          SampleSetting() => location,
          SampleUser() => location,
          SampleSearch() => location,
        },
      ),
      routeInformationParser: n.NRouterRouteInformationParser(),
      // backButtonDispatcher: ?,
    );
  }
}

@immutable
sealed class Sample {
  const Sample();
}

@immutable
class SampleRoot extends StatelessWidget implements Sample {
  const SampleRoot({super.key});

  static final parserAndBuilder = n.uri(n.path0, n.map0).map<Sample>(
        (_) => const SampleRoot(),
        (parsed) => switch (parsed) {
          SampleRoot() => const (null, null),
          _ => throw Exception(),
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('root'),
      ),
      body: const _CommonLinks(),
    );
  }
}

@immutable
class SampleSetting extends StatelessWidget implements Sample {
  const SampleSetting({super.key});

  static final parserAndBuilder =
      n.uri(n.path1(n.keyword('settings')), n.map0).map<Sample>(
            (_) => const SampleSetting(),
            (parsed) => switch (parsed) {
              SampleSetting() => const (null, null),
              _ => throw Exception(),
            },
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
      ),
      body: const _CommonLinks(),
    );
  }
}

@immutable
class SampleUser extends StatelessWidget implements Sample {
  const SampleUser({
    super.key,
    required this.id,
    required this.isEdit,
  });

  final int id;
  final bool isEdit;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user $id ${isEdit ? 'edit' : ''}'),
      ),
      body: const _CommonLinks(),
    );
  }
}

@immutable
class SampleSearch extends StatelessWidget implements Sample {
  const SampleSearch({super.key, required this.query});

  final String query;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search $query'),
      ),
      body: const _CommonLinks(),
    );
  }
}

class _CommonLinks extends StatelessWidget {
  const _CommonLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Link(
          uri: sample.builder(const SampleSetting()),
          builder: (context, followLink) =>
              TextButton(onPressed: followLink, child: const Text('settings')),
        ),
        Link(
          uri: sample.builder(const SampleUser(
            id: 1,
            isEdit: false,
          )),
          builder: (context, followLink) => TextButton(
              onPressed: followLink, child: const Text('user 1 isEdit false')),
        ),
        Link(
          uri: sample.builder(const SampleUser(
            id: 1,
            isEdit: true,
          )),
          builder: (context, followLink) => TextButton(
              onPressed: followLink, child: const Text('user 1 isEdit true')),
        ),
      ],
    );
  }
}

final sample = n.oneOf(IList([
  SampleRoot.parserAndBuilder,
  SampleSetting.parserAndBuilder,
  SampleUser.parserAndBuilder,
  SampleSearch.parserAndBuilder,
]));

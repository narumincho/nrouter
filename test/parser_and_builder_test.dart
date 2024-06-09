import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:test/test.dart';

@immutable
sealed class Sample {
  const Sample();
}

@immutable
class SampleRoot implements Sample {
  const SampleRoot();

  static final parserAndBuilder = n.ParserAndBuilder<Sample,
      (IList<String>, IMap<String, IList<String>>)>.custom(
    parser: (raw) {
      n.path0.parser(raw.$1);
      return const SampleRoot();
    },
    builder: (parsed) => switch (parsed) {
      SampleRoot() => const (IListConst([]), IMapConst({})),
      _ => throw Exception(),
    },
  );
}

@immutable
class SampleSetting implements Sample {
  const SampleSetting();

  static final parserAndBuilder = n.ParserAndBuilder<Sample,
      (IList<String>, IMap<String, IList<String>>)>.custom(
    parser: (raw) {
      n.path1(n.keyword('settings')).parser(raw.$1);
      return const SampleSetting();
    },
    builder: (parsed) => switch (parsed) {
      SampleSetting() => const (IListConst(['settings']), IMapConst({})),
      _ => throw Exception(),
    },
  );
}

@immutable
class SampleUser implements Sample {
  const SampleUser({required this.id});

  final int id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static final parserAndBuilder = n.ParserAndBuilder<Sample,
      (IList<String>, IMap<String, IList<String>>)>.custom(
    parser: (raw) {
      final (_, id) = n.path2(n.keyword('user'), n.integer).parser(raw.$1);
      return SampleUser(id: id);
    },
    builder: (parsed) => switch (parsed) {
      SampleUser(:final id) => (
          IList(['user', id.toString()]),
          const IMapConst({})
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

  static final parserAndBuilder = n.ParserAndBuilder<Sample,
      (IList<String>, IMap<String, IList<String>>)>.custom(
    parser: (raw) {
      n.path1(n.keyword('search')).parser(raw.$1);
      return SampleSearch(
        query: n.mapValue('q').parser(raw.$2).firstOrNull ?? '',
      );
    },
    builder: (parsed) => switch (parsed) {
      SampleSearch(:final query) => (
          const IListConst(['search']),
          IMap({
            'q': IList([query]),
          })
        ),
      _ => throw Exception(),
    },
  );
}

final sample = n.uriS.andThen(n.oneOf(IList([
  SampleRoot.parserAndBuilder,
  SampleSetting.parserAndBuilder,
  SampleUser.parserAndBuilder,
  SampleSearch.parserAndBuilder,
])));

void main() {
  test('ParserAndBuilder root', () {
    expect(sample.parser(Uri.parse('/')), const SampleRoot());
    expect(
      sample.builder(const SampleRoot()),
      Uri(
        pathSegments: [],
        queryParameters: {},
      ),
    );
  });

  test('ParserAndBuilder settings', () {
    expect(
      sample.parser(Uri.parse('/settings')),
      const SampleSetting(),
    );
    expect(
        sample.builder(const SampleSetting()),
        Uri(
          pathSegments: ['settings'],
          queryParameters: {},
        ));
  });

  test('ParserAndBuilder user', () {
    expect(
      sample.parser(Uri.parse('/user/1')),
      const SampleUser(id: 1),
    );
    expect(
      sample.builder(const SampleUser(id: 1)),
      Uri(pathSegments: ['user', '1'], queryParameters: {}),
    );
  });

  test('ParserAndBuilder search', () {
    expect(
      sample.parser(Uri.parse('/search?q=hello')),
      const SampleSearch(query: 'hello'),
    );
    expect(
      sample.builder(const SampleSearch(query: 'search')),
      Uri(
        pathSegments: ['search'],
        queryParameters: {'q': 'search'},
      ),
    );
  });
}

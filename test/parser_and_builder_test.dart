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

  static n
      .ParserAndBuilder<Sample, (IList<String>, IMap<String, IList<String>>)>
      parserAndBuilder() {
    final path = n.path2(n.keyword('user'), n.integer);
    return n.ParserAndBuilder<Sample,
        (IList<String>, IMap<String, IList<String>>)>.custom(
      parser: (raw) {
        final (_, id) = path.parser(raw.$1);
        return SampleUser(id: id, isEdit: false);
      },
      builder: (parsed) => switch (parsed) {
        SampleUser(:final id) => (
            path.builder((null, id)),
            const IMapConst({})
          ),
        _ => throw Exception(),
      },
    );
  }

  static n
      .ParserAndBuilder<Sample, (IList<String>, IMap<String, IList<String>>)>
      parserAndBuilderS() {
    return n.andThenRaw2<Sample, (Null, int), IList<String>, IList<String>,
        IMap<String, IList<String>>>(
      n.ParserAndBuilder.custom(
        parser: (raw) {
          return SampleUser(id: raw.$1.$2, isEdit: raw.$2.isNotEmpty);
        },
        builder: (parsed) => switch (parsed) {
          SampleUser(:final id, :final isEdit) => (
              (null, id),
              isEdit ? const IListConst(['true']) : const IListConst([])
            ),
          _ => throw Exception(),
        },
      ),
      n.andThenParsed2(n.path2S(), n.keyword('user'), n.integer),
      n.mapValue('edit'),
    );
  }
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
  SampleUser.parserAndBuilder(),
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
      const SampleUser(id: 1, isEdit: false),
    );
    expect(
      sample.builder(const SampleUser(id: 1, isEdit: false)),
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

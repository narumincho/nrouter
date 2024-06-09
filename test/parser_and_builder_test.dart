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

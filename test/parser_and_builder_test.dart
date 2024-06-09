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
}

@immutable
class SampleSetting implements Sample {
  const SampleSetting();
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
}

final sample = n.oneOf<Sample, IList<String>>(IList([
  n.parserAndBuilderPath0.map<Sample>(
      (_) => const SampleRoot(),
      (sample) => switch (sample) {
            SampleRoot() => null,
            _ => throw Exception(),
          }),
  n.path1(n.keyword('settings').map(
        (_) => const SampleSetting(),
        (newParsed) => switch (newParsed) {
          SampleSetting() => null,
          _ => throw Exception(),
        },
      )),
  n
      .path2(
        n.keyword('user'),
        n.integer,
      )
      .map(
        (prevParsed) => SampleUser(id: prevParsed.$2),
        (newParsed) => switch (newParsed) {
          SampleUser(:final id) => (null, id),
          _ => throw Exception(),
        },
      )
]));

void main() {
  test('ParserAndBuilder root', () {
    expect(sample.parser(const IListConst([])), const SampleRoot());
    expect(sample.builder(const SampleRoot()), const IListConst([]));
  });

  test('ParserAndBuilder settings', () {
    expect(
      sample.parser(const IListConst(['settings'])),
      const SampleSetting(),
    );
    expect(
      sample.builder(const SampleSetting()),
      const IListConst(['settings']),
    );
  });

  test('ParserAndBuilder user', () {
    expect(
      sample.parser(const IListConst(['user', '1'])),
      const SampleUser(id: 1),
    );
    expect(
      sample.builder(const SampleUser(id: 1)),
      const IListConst(['user', '1']),
    );
  });
}

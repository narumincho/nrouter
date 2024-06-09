import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart';
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
  const SampleUser(this.id);

  final int id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

final sample = ParserAndBuilder.oneOf<Sample, IList<String>>(IList([
  ParserAndBuilder.path0.map<Sample>((_) => const SampleRoot(),
      (sample) => sample is SampleRoot ? null : throw Exception()),
  ParserAndBuilder.path1(ParserAndBuilder.keyword('settings').map(
    (_) => const SampleSetting(),
    (newParsed) => newParsed is SampleSetting ? null : throw Exception(),
  )),
  ParserAndBuilder.path2(
    ParserAndBuilder.keyword('user'),
    ParserAndBuilder.integer,
  ).map(
      (prevParsed) => SampleUser(prevParsed.$2),
      (newParsed) =>
          newParsed is SampleUser ? (null, newParsed.id) : throw Exception()),
]));

void main() {
  test('ParserAndBuilder root', () {
    expect(sample.parser(const IListConst([])), const SampleRoot());
    expect(sample.builder(const SampleRoot()), const IListConst([]));
  });

  test('ParserAndBuilder settings', () {
    expect(
        sample.parser(const IListConst(['settings'])), const SampleSetting());
    expect(
        sample.builder(const SampleSetting()), const IListConst(['settings']));
  });

  test('ParserAndBuilder user', () {
    expect(sample.parser(const IListConst(['user', '1'])), const SampleUser(1));
    expect(
        sample.builder(const SampleUser(1)), const IListConst(['user', '1']));
  });
}

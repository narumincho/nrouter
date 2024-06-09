import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

// https://github.com/eernstg/invariant_collection/blob/main/lib/src/invariant_collection.dart
typedef _Inv<T> = T Function(T);
typedef ParserAndBuilder<Parsed, Raw>
    = _ParserAndBuilder<Parsed, _Inv<Parsed>, Raw, _Inv<Raw>>;

@immutable
class _ParserAndBuilder<Parsed, ParsedInv extends _Inv<Parsed>, Raw,
    RawInv extends _Inv<Raw>> {
  const _ParserAndBuilder.custom({
    required this.parser,
    required this.builder,
  });

  final Parsed Function(Raw raw) parser;
  final Raw Function(Parsed parsed) builder;

  ParserAndBuilder<NewParsed, Raw> map<NewParsed>(
    NewParsed Function(Parsed prevParsed) parserMap,
    Parsed Function(NewParsed newParsed) builderMap,
  ) =>
      ParserAndBuilder<NewParsed, Raw>.custom(
        parser: (raw) => parserMap(parser(raw)),
        builder: (parsed) => builder(builderMap(parsed)),
      );

  static ParserAndBuilder<Parsed, Raw> oneOf<Parsed, Raw>(
      IList<ParserAndBuilder<Parsed, Raw>> parsers) {
    return ParserAndBuilder<Parsed, Raw>.custom(
      parser: (pathSegment) {
        final errors = <Object>[];
        for (final parser in parsers) {
          try {
            return parser.parser(pathSegment);
          } catch (e) {
            errors.add(e);
          }
        }
        throw Exception('No parser matched $pathSegment $errors');
      },
      builder: (value) {
        final errors = <Object>[];
        for (final parser in parsers) {
          try {
            return parser.builder(value);
          } catch (e) {
            errors.add(e);
          }
        }
        throw Exception('builder error $value $errors');
      },
    );
  }

  static final integer = ParserAndBuilder<int, String>.custom(
    parser: (pathSegment) => int.parse(pathSegment),
    builder: (value) => value.toString(),
  );

  static ParserAndBuilder<Null, String> keyword(String name) =>
      ParserAndBuilder<Null, String>.custom(
        parser: (pathSegment) {
          if (pathSegment == name) {
            return null;
          }
          throw Exception('Expected $name, got $pathSegment');
        },
        builder: (_) => name,
      );

  static final ParserAndBuilder<Null, IList<String>> path0 =
      ParserAndBuilder<Null, IList<String>>.custom(
    parser: (pathSegments) {
      if (pathSegments.isNotEmpty) {
        throw Exception('Expected 0 path segment, got $pathSegments');
      }
      return null;
    },
    builder: (_) => const IListConst([]),
  );

  static ParserAndBuilder<S0, IList<String>> path1<S0>(
          ParserAndBuilder<S0, String> segment0) =>
      ParserAndBuilder<S0, IList<String>>.custom(
        parser: (pathSegments) {
          return switch (pathSegments.toList()) {
            [final pathSegment0] => segment0.parser(pathSegment0),
            _ => throw Exception('Expected 1 path segment, got $pathSegments'),
          };
        },
        builder: (value) => IList([segment0.builder(value)]),
      );

  static ParserAndBuilder<(S0, S1), IList<String>> path2<S0, S1>(
    ParserAndBuilder<S0, String> segment0,
    ParserAndBuilder<S1, String> segment1,
  ) =>
      ParserAndBuilder<(S0, S1), IList<String>>.custom(
        parser: (pathSegments) {
          return switch (pathSegments.toList()) {
            [final pathSegment0, final pathSegment1] => (
                segment0.parser(pathSegment0),
                segment1.parser(pathSegment1)
              ),
            _ => throw Exception('Expected 2 path segment, got $pathSegments'),
          };
        },
        builder: (value) => IList([
          segment0.builder(value.$1),
          segment1.builder(value.$2),
        ]),
      );

  static ParserAndBuilder<(S0, S1, S2), IList<String>> path3<S0, S1, S2>(
    ParserAndBuilder<S0, String> segment0,
    ParserAndBuilder<S1, String> segment1,
    ParserAndBuilder<S2, String> segment2,
  ) =>
      ParserAndBuilder<(S0, S1, S2), IList<String>>.custom(
        parser: (pathSegments) {
          return switch (pathSegments.toList()) {
            [final pathSegment0, final pathSegment1, final pathSegment2] => (
                segment0.parser(pathSegment0),
                segment1.parser(pathSegment1),
                segment2.parser(pathSegment2),
              ),
            _ => throw Exception('Expected 3 path segment, got $pathSegments')
          };
        },
        builder: (value) => IList([
          segment0.builder(value.$1),
          segment1.builder(value.$2),
          segment2.builder(value.$3),
        ]),
      );

  static ParserAndBuilder<(S0, S1, S2, S3), IList<String>>
      path4<S0, S1, S2, S3>(
    ParserAndBuilder<S0, String> segment0,
    ParserAndBuilder<S1, String> segment1,
    ParserAndBuilder<S2, String> segment2,
    ParserAndBuilder<S3, String> segment3,
  ) =>
          ParserAndBuilder<(S0, S1, S2, S3), IList<String>>.custom(
            parser: (pathSegments) {
              return switch (pathSegments.toList()) {
                [
                  final pathSegment0,
                  final pathSegment1,
                  final pathSegment2,
                  final pathSegment3
                ] =>
                  (
                    segment0.parser(pathSegment0),
                    segment1.parser(pathSegment1),
                    segment2.parser(pathSegment2),
                    segment3.parser(pathSegment3),
                  ),
                _ =>
                  throw Exception('Expected 4 path segment, got $pathSegments')
              };
            },
            builder: (value) => IList([
              segment0.builder(value.$1),
              segment1.builder(value.$2),
              segment2.builder(value.$3),
              segment3.builder(value.$4),
            ]),
          );

  static ParserAndBuilder<(S0, S1, S2, S3, S4), IList<String>>
      path5<S0, S1, S2, S3, S4>(
    ParserAndBuilder<S0, String> segment0,
    ParserAndBuilder<S1, String> segment1,
    ParserAndBuilder<S2, String> segment2,
    ParserAndBuilder<S3, String> segment3,
    ParserAndBuilder<S4, String> segment4,
  ) =>
          ParserAndBuilder<(S0, S1, S2, S3, S4), IList<String>>.custom(
            parser: (pathSegments) {
              return switch (pathSegments.toList()) {
                [
                  final pathSegment0,
                  final pathSegment1,
                  final pathSegment2,
                  final pathSegment3,
                  final pathSegment4
                ] =>
                  (
                    segment0.parser(pathSegment0),
                    segment1.parser(pathSegment1),
                    segment2.parser(pathSegment2),
                    segment3.parser(pathSegment3),
                    segment4.parser(pathSegment4),
                  ),
                _ =>
                  throw Exception('Expected 5 path segment, got $pathSegments')
              };
            },
            builder: (value) => IList([
              segment0.builder(value.$1),
              segment1.builder(value.$2),
              segment2.builder(value.$3),
              segment3.builder(value.$4),
              segment4.builder(value.$5),
            ]),
          );
}

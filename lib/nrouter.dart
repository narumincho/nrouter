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

  ParserAndBuilder<NewParsed, Raw> andThen<NewParsed>(
    ParserAndBuilder<NewParsed, Parsed> parserAndBuilder,
  ) =>
      ParserAndBuilder<NewParsed, Raw>.custom(
        parser: (raw) => parserAndBuilder.parser(parser(raw)),
        builder: (parsed) => builder(parserAndBuilder.builder(parsed)),
      );
}

ParserAndBuilder<Parsed, Raw> oneOf<Parsed, Raw>(
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

/// ```
/// 12
/// ```
final integer = ParserAndBuilder<int, String>.custom(
  parser: (pathSegment) => int.parse(pathSegment),
  builder: (value) => value.toString(),
);

/// ```
/// 12.34
/// ```
final number = ParserAndBuilder<num, String>.custom(
  parser: (pathSegment) => num.parse(pathSegment),
  builder: (value) => value.toString(),
);

/// ```
/// abc
/// ```
final string = ParserAndBuilder<String, String>.custom(
  parser: (pathSegment) => pathSegment,
  builder: (value) => value,
);

ParserAndBuilder<Null, String> keyword(String name) =>
    ParserAndBuilder<Null, String>.custom(
      parser: (pathSegment) {
        if (pathSegment == name) {
          return null;
        }
        throw Exception('Expected $name, got $pathSegment');
      },
      builder: (_) => name,
    );

/// ```
/// /
/// ```
final ParserAndBuilder<Null, IList<String>> path0 =
    ParserAndBuilder<Null, IList<String>>.custom(
  parser: (pathSegments) {
    if (pathSegments.isNotEmpty) {
      throw Exception('Expected 0 path segment, got $pathSegments');
    }
    return null;
  },
  builder: (_) => const IListConst([]),
);

/// ```
/// /segment0
/// ```
ParserAndBuilder<S0, IList<String>> path1<S0>(
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

/// ```
/// /segment0/segment1
/// ```
ParserAndBuilder<(S0, S1), IList<String>> path2<S0, S1>(
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

/// ```
/// /segment0/segment1
/// ```
ParserAndBuilder<(String, String), IList<String>> path2S() =>
    ParserAndBuilder<(String, String), IList<String>>.custom(
      parser: (pathSegments) {
        return switch (pathSegments.toList()) {
          [final pathSegment0, final pathSegment1] => (
              pathSegment0,
              pathSegment1
            ),
          _ => throw Exception('Expected 2 path segment, got $pathSegments'),
        };
      },
      builder: (value) => IList([
        value.$1,
        value.$2,
      ]),
    );

/// ```
/// /segment0/segment1/segment2
/// ```
ParserAndBuilder<(S0, S1, S2), IList<String>> path3<S0, S1, S2>(
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

/// ```
/// /segment0/segment1/segment2/segment3
/// ```
ParserAndBuilder<(S0, S1, S2, S3), IList<String>> path4<S0, S1, S2, S3>(
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
          _ => throw Exception('Expected 4 path segment, got $pathSegments')
        };
      },
      builder: (value) => IList([
        segment0.builder(value.$1),
        segment1.builder(value.$2),
        segment2.builder(value.$3),
        segment3.builder(value.$4),
      ]),
    );

/// ```
/// /segment0/segment1/segment2/segment3/segment4
/// ```
ParserAndBuilder<(S0, S1, S2, S3, S4), IList<String>> path5<S0, S1, S2, S3, S4>(
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
          _ => throw Exception('Expected 5 path segment, got $pathSegments')
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

/// ```
/// ?key=value
/// ```
ParserAndBuilder<IList<String>, IMap<String, IList<String>>> mapValues(
  String key,
) =>
    ParserAndBuilder<IList<String>, IMap<String, IList<String>>>.custom(
      parser: (map) => map.get(key) ?? const IListConst([]),
      builder: (value) => IMap({key: value}),
    );

/// ```
/// ?key=value
/// ```
ParserAndBuilder<String, IMap<String, IList<String>>> mapValue(
  String key,
) =>
    ParserAndBuilder<String, IMap<String, IList<String>>>.custom(
      parser: (map) => map.get(key)!.first,
      builder: (value) => IMap({
        key: IList([value]),
      }),
    );

/// ```
/// ?key=value
/// ```
ParserAndBuilder<String?, IMap<String, IList<String>>> mapOptionalValue(
  String key,
) =>
    ParserAndBuilder<String?, IMap<String, IList<String>>>.custom(
      parser: (map) => map.get(key)?.firstOrNull,
      builder: (value) => IMap({
        if (value != null) key: IList([value])
      }),
    );

/// We do not care what query parameters are specified. No query is generated.
final map0 = ParserAndBuilder<Null, IMap<String, IList<String>>>.custom(
  parser: (map) => null,
  builder: (value) => const IMapConst({}),
);

/// ```
/// ?key0=value0&key1=value1
/// ```
ParserAndBuilder<(S0, S1), IMap<String, IList<String>>> mapMarge2<S0, S1>(
  ParserAndBuilder<S0, IMap<String, IList<String>>> parserAndBuilder0,
  ParserAndBuilder<S1, IMap<String, IList<String>>> parserAndBuilder1,
) =>
    ParserAndBuilder<(S0, S1), IMap<String, IList<String>>>.custom(
      parser: (map) => (
        parserAndBuilder0.parser(map),
        parserAndBuilder1.parser(map),
      ),
      builder: (value) => IMap({
        ...parserAndBuilder0.builder(value.$1).unlock,
        ...parserAndBuilder1.builder(value.$2).unlock,
      }),
    );

/// ```
/// /pathSegment0/pathSegment1?key0=value0&key1=value1
/// ```
ParserAndBuilder<(PathSegments, Query), Uri> uri<PathSegments, Query>(
  ParserAndBuilder<PathSegments, IList<String>> pathSegmentsParserAndBuilder,
  ParserAndBuilder<Query, IMap<String, IList<String>>> queryParserAndBuilder,
) =>
    ParserAndBuilder<(PathSegments, Query), Uri>.custom(
      parser: (uri) => (
        pathSegmentsParserAndBuilder.parser(IList(uri.pathSegments)),
        queryParserAndBuilder.parser(
          IMap(uri.queryParametersAll.map((k, v) => MapEntry(k, IList(v)))),
        ),
      ),
      builder: (value) {
        return Uri(
          pathSegments: pathSegmentsParserAndBuilder.builder(value.$1),
          queryParameters: queryParserAndBuilder.builder(value.$2).unlock,
        );
      },
    );

/// ```
/// /pathSegment0/pathSegment1?key0=value0&key1=value1
/// ```
final uriParserAndBuilder =
    ParserAndBuilder<(IList<String>, IMap<String, IList<String>>), Uri>.custom(
  parser: (uri) => (
    IList(uri.pathSegments),
    (IMap(uri.queryParametersAll.map((k, v) => MapEntry(k, IList(v))))),
  ),
  builder: (value) => Uri(
    pathSegments: value.$1,
    queryParameters: value.$2.unlock,
  ),
);

ParserAndBuilder<(T0NP, T1NP), Raw> andThenParsed2<T0NP, T0P, T1NP, T1P, Raw>(
  ParserAndBuilder<(T0P, T1P), Raw> parserAndBuilder,
  ParserAndBuilder<T0NP, T0P> t0ParserAndBuilder,
  ParserAndBuilder<T1NP, T1P> t1ParserAndBuilder,
) =>
    ParserAndBuilder<(T0NP, T1NP), Raw>.custom(
      parser: (raw) {
        final parsed = parserAndBuilder.parser(raw);
        return (
          t0ParserAndBuilder.parser(parsed.$1),
          t1ParserAndBuilder.parser(parsed.$2),
        );
      },
      builder: (parsed) => parserAndBuilder.builder((
        t0ParserAndBuilder.builder(parsed.$1),
        t1ParserAndBuilder.builder(parsed.$2),
      )),
    );

ParserAndBuilder<T, (T0R, T1R)> merge2<T, T0, T1, T0R, T1R>(
  ParserAndBuilder<T, (T0, T1)> parserAndBuilder,
  ParserAndBuilder<T0, T0R> t0ParserAndBuilder,
  ParserAndBuilder<T1, T1R> t1ParserAndBuilder,
) =>
    ParserAndBuilder<T, (T0R, T1R)>.custom(
      parser: (raw) {
        return parserAndBuilder.parser((
          t0ParserAndBuilder.parser(raw.$1),
          t1ParserAndBuilder.parser(raw.$2),
        ));
      },
      builder: (parsed) {
        final (t0, t1) = parserAndBuilder.builder(parsed);
        return (
          t0ParserAndBuilder.builder(t0),
          t1ParserAndBuilder.builder(t1),
        );
      },
    );

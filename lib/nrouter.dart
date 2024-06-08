import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

@immutable
class PathSegmentParserAndBuilder<T> {
  PathSegmentParserAndBuilder.custom({
    required this.parser,
    required this.builder,
  });

  final Result<T, String> Function(String pathSegment) parser;
  final Result<String, String> Function(T value) builder;

  static PathSegmentParserAndBuilder<T> oneOf<T>(
      List<PathSegmentParserAndBuilder<T>> parsers) {
    return PathSegmentParserAndBuilder<T>.custom(
      parser: (pathSegment) {
        for (final parser in parsers) {
          final result = parser.parser(pathSegment);
          if (result.isSuccess) {
            return result;
          }
        }
        return Failure('No parser matched $pathSegment');
      },
      builder: (value) {
        for (final parser in parsers) {
          final result = parser.builder(value);
          if (result.isSuccess) {
            return result;
          }
        }
        throw ArgumentError('builder error $value');
      },
    );
  }

  static final integer = PathSegmentParserAndBuilder<int>.custom(
    parser: (pathSegment) => switch (int.tryParse(pathSegment)) {
      null => Failure('Expected integer, got $pathSegment'),
      final value => Success(value),
    },
    builder: (value) => Success(value.toString()),
  );

  static PathSegmentParserAndBuilder<Null> keyword(String name) =>
      PathSegmentParserAndBuilder<Never>.custom(
        parser: (pathSegment) {
          if (pathSegment == name) {
            return Success<Never, String>((() {
              throw Exception('Unreachable');
            })());
          }
          return Failure<Never, String>('Expected $name, got $pathSegment');
        },
        builder: (_) => Success(name),
      );
}

final routeList = [
  createRoute2(
    ((
      PathSegmentParserAndBuilder.keyword('user'),
      PathSegmentParserAndBuilder.integer
    )),
    (context, param) => 'Widget',
  ),
];

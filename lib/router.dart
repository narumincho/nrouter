import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nrouter/page/root.dart';
import 'package:nrouter/page/search.dart';
import 'package:nrouter/page/setting.dart';
import 'package:nrouter/page/user.dart';
import 'package:nrouter/parser_and_builder.dart' as n;

@immutable
class RouterPage {
  const RouterPage();
}

final parserAndBuilder = n.oneOf(IList([
  RootPage.parserAndBuilder,
  SettingPage.parserAndBuilder,
  UserPage.parserAndBuilder,
  SearchPage.parserAndBuilder,
]));

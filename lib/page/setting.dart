import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class SettingPage extends StatelessWidget implements RouterPage {
  const SettingPage({super.key});

  static final parserAndBuilder =
      n.uri(n.path1(n.keyword('settings')), n.map0).map<RouterPage>(
            (_) => const SettingPage(),
            (parsed) => switch (parsed) {
              SettingPage() => const (null, null),
              _ => throw Exception(),
            },
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: n.NRouter.of<RouterPage>(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  n.NRouter.of<RouterPage>(context).pop();
                },
              )
            : null,
        title: const Text('settings'),
      ),
      body: const CommonLinks(),
    );
  }
}

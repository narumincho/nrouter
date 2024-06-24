import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class RootPage extends StatelessWidget implements RouterPage {
  const RootPage({super.key});

  static final parserAndBuilder = n.uri(n.path0, n.map0).map<RouterPage>(
        (_) => const RootPage(),
        (parsed) => switch (parsed) {
          RootPage() => const (null, null),
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
        title: const Text('root'),
      ),
      body: const CommonLinks(),
    );
  }
}

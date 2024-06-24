import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class SampleNotFound extends StatelessWidget implements Sample {
  const SampleNotFound({super.key});

  static final parserAndBuilder = n.notFound().map<Sample>(
        (_) => const SampleNotFound(),
        (parsed) => switch (parsed) {
          SampleNotFound() => null,
          _ => throw Exception(),
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: n.NRouter.of<Sample>(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  n.NRouter.of<Sample>(context).pop();
                },
              )
            : null,
        title: const Text('root'),
      ),
      body: const CommonLinks(),
    );
  }
}

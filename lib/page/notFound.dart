import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class NotFoundPage extends StatelessWidget implements RouterPage {
  const NotFoundPage({super.key});

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
        title: const Text('not found'),
      ),
      body: const CommonLinks(),
    );
  }
}

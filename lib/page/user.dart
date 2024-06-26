import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class UserPage extends StatelessWidget implements RouterPage {
  const UserPage({
    super.key,
    required this.id,
    required this.isEdit,
  });

  final int id;
  final bool isEdit;

  static final parserAndBuilder = n
      .uri(
        n.path2(n.keyword('user'), n.integer),
        n.mapOptionalValue('edit'),
      )
      .map<RouterPage>(
        (parsed) => UserPage(id: parsed.$1.$2, isEdit: parsed.$2 != null),
        (parsed) => switch (parsed) {
          UserPage(:final id, :final isEdit) => (
              (null, id),
              isEdit ? '' : null,
            ),
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
        title: Text('user $id ${isEdit ? 'edit' : ''}'),
      ),
      body: const CommonLinks(),
    );
  }
}

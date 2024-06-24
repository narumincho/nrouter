import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/page/root.dart';
import 'package:nrouter/page/search.dart';
import 'package:nrouter/page/setting.dart';
import 'package:nrouter/page/user.dart';
import 'package:nrouter/router.dart';
import 'package:url_launcher/link.dart';

class CommonLinks extends StatelessWidget {
  const CommonLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Link(
          uri: parserAndBuilder.builder(const RootPage()),
          builder: (context, followLink) =>
              TextButton(onPressed: followLink, child: const Text('root')),
        ),
        Link(
          uri: parserAndBuilder.builder(const SettingPage()),
          builder: (context, followLink) => TextButton(
            onPressed: followLink,
            child: const Text('settings'),
          ),
        ),
        Link(
          uri: parserAndBuilder.builder(const UserPage(
            id: 1,
            isEdit: false,
          )),
          builder: (context, followLink) => TextButton(
            onPressed: followLink,
            child: const Text('user 1 isEdit false'),
          ),
        ),
        Link(
          uri: parserAndBuilder.builder(const UserPage(
            id: 1,
            isEdit: true,
          )),
          builder: (context, followLink) => TextButton(
            onPressed: followLink,
            child: const Text('user 1 isEdit true'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            n.NRouter.of<RouterPage>(context)
                .push(const UserPage(id: 1, isEdit: false));
          },
          child: const Text('push user 1'),
        ),
        ElevatedButton(
          onPressed: () {
            n.NRouter.of<RouterPage>(context)
                .replace(const UserPage(id: 1, isEdit: false), context);
          },
          child: const Text('replace user 1'),
        ),
        Link(
          uri: parserAndBuilder.builder(const SearchPage(
            query: 'sample',
          )),
          builder: (context, followLink) => TextButton(
            onPressed: followLink,
            child: const Text('search query sample'),
          ),
        ),
      ],
    );
  }
}

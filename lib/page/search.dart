import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class SearchPage extends StatefulWidget implements RouterPage {
  const SearchPage({super.key, required this.query});

  final String query;

  static final parserAndBuilder = n
      .uri(
        n.path1(n.keyword('search')),
        n.mapOptionalValue('q'),
      )
      .map<RouterPage>(
        (raw) => SearchPage(query: raw.$2 ?? ''),
        (parsed) => switch (parsed) {
          SearchPage(:final query) => (null, query),
          _ => throw Exception(),
        },
      );

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    print('search init ${widget.query}');
    _controller
      ..text = widget.query
      ..addListener(() {
        print('search query ${_controller.text}');
        if (widget.query != _controller.text) {
          n.NRouter.of<RouterPage>(context)
              .replace(SearchPage(query: _controller.text), context);
        }
      });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

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
        title: Text('search query ${widget.query}'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'query',
            ),
          ),
        ),
        const CommonLinks(),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nrouter/nrouter.dart' as n;
import 'package:nrouter/router.dart';
import 'package:nrouter/widget/common_links.dart';

@immutable
class SampleSearch extends StatefulWidget implements Sample {
  const SampleSearch({super.key, required this.query});

  final String query;

  static final parserAndBuilder = n
      .uri(
        n.path1(n.keyword('search')),
        n.mapOptionalValue('q'),
      )
      .map<Sample>(
        (raw) => SampleSearch(query: raw.$2 ?? ''),
        (parsed) => switch (parsed) {
          SampleSearch(:final query) => (null, query),
          _ => throw Exception(),
        },
      );

  @override
  State<SampleSearch> createState() => _SampleSearchState();
}

class _SampleSearchState extends State<SampleSearch> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('search query ${widget.query}');
    _controller
      ..text = widget.query
      ..addListener(() {
        print('search query ${_controller.text}');

        n.NRouter.of<Sample>(context)
            .replace(SampleSearch(query: _controller.text), context);
      });
  }

  @override
  void didUpdateWidget(covariant SampleSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = widget.query;
  }

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

import 'package:trading/common/ui_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: UItext.back,
            onPressed: () {
              context.go('/');
            },
          ),
          title: const Text(UItext.apptitle),
        ),
        body: const Center(
            child: Text(
          UItext.notfoundPage,
          textAlign: TextAlign.center,
        )));
  }
}

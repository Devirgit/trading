import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyCategory extends StatelessWidget {
  const EmptyCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxDecor.header(
      iconHeader: Image.asset(
        "assets/default/stock.png",
        width: 32,
        height: 32,
      ),
      header: const Text(UItext.emptyCategoryTitle,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: UIColor.h1Color,
          )),
      action: const SizedBox(
        height: 50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
            UItext.emptyCategory,
            textAlign: TextAlign.center,
          )),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            backgroundColor: UIColor.primaryColor,
            onPressed: () => context.go('/profile'),
            child: const Icon(Icons.perm_identity_outlined),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

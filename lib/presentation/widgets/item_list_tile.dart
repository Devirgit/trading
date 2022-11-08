import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile(
      {Key? key,
      required this.leading,
      required this.trailing,
      required this.subTraling,
      required this.subTitle,
      required this.title,
      this.onTap})
      : super(key: key);

  final Widget leading;
  final String title;
  final String subTitle;
  final Widget trailing;
  final Widget subTraling;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: leading,
                )
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: UIColor.h2Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                          color: UIColor.h3Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    )
                  ]),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                trailing,
                const SizedBox(
                  height: 5.0,
                ),
                subTraling
              ],
            ),
          ],
        ),
      ),
    );
  }
}

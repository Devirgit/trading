import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class ExchangeVolume extends StatelessWidget {
  const ExchangeVolume(
      {Key? key, required this.startVolume, required this.endVolume})
      : super(key: key);

  final String startVolume;
  final String endVolume;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text(
            startVolume,
            textAlign: TextAlign.left,
            style: const TextStyle(
                letterSpacing: 1.25,
                color: UIColor.fontColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            child: Icon(
              Icons.arrow_right_alt,
              size: 14,
              color: UIColor.fontColor,
            ),
          ),
          Flexible(
            child: Text(
              endVolume,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  letterSpacing: 1.25,
                  color: UIColor.fontColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

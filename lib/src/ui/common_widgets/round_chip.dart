import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';

class RoundChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontsize;

  const RoundChip(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.textColor,
      required this.horizontalPadding,
      required this.verticalPadding,
      required this.fontsize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding, // 5 padding top and bottom
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: backgroundColor),
          child: Text(
            this.text,
            style: TextStyle(color: this.textColor, fontSize: fontsize),
          ),
        ),
      ],
    );
  }
}

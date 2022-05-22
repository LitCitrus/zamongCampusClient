//일단은 사용중

import 'package:flutter/material.dart';

import 'vertical_spacing.dart';

class CenterSentence extends StatelessWidget {
  final String sentence;
  final double verticalSpace;
  const CenterSentence(
      {Key? key, required this.sentence, required this.verticalSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      VerticalSpacing(of: verticalSpace),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            sentence,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      )
    ]);
  }
}

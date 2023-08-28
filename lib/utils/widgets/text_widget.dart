import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.fontColor,
    required this.textAlign,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(text,overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: textAlign,style: TextStyle(
      fontSize: fontSize,fontWeight: fontWeight,color: fontColor),
    );
  }
}

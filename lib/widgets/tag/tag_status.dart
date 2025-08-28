import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class TagStatus extends StatelessWidget {
  const TagStatus({
    super.key,
    required this.text,
    this.type = TagStatusType.neutral,
  });

  final String text;
  final TagStatusType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.d16,
        vertical: Dimens.d4,
      ),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(Dimens.d4),
      ),
      child: Text(
        text,
        style: TextStyles.label1().copyWith(color: type.textColor),
      ),
    );
  }
}

enum TagStatusType {
  info(backgroundColor: Color(0xFFEAF7FF), textColor: Color(0xFF006AD3)),
  success(backgroundColor: Color(0xFFDCFCE3), textColor: Color(0xFF279780)),
  warning(backgroundColor: Color(0xFFFEF3CC), textColor: Color(0xFFCA7A05)),
  danger(backgroundColor: Color(0xFFFFE4D7), textColor: Color(0xFFFF3838)),
  neutral(backgroundColor: Color(0xFFF2F2F2), textColor: Color(0xFF676767)),
  // specific case for learn
  deepLemon(backgroundColor: Color(0xFFFDCE1B), textColor: Color(0xFF676767));

  final Color backgroundColor;
  final Color textColor;

  const TagStatusType({required this.backgroundColor, required this.textColor});
}

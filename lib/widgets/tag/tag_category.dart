import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class TagCategory extends StatelessWidget {
  const TagCategory({
    super.key,
    required this.text,
    this.type = TagCategoryType.plain,
  });

  final String text;
  final TagCategoryType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.d12,
        vertical: Dimens.d4,
      ),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(Dimens.d20),
      ),
      child: Text(
        text,
        style: TextStyles.label2().copyWith(color: type.textColor),
      ),
    );
  }
}

enum TagCategoryType {
  plain(backgroundColor: Color(0xFFF2F2F2), textColor: Color(0xFF979797)),
  crismon(backgroundColor: Color(0xFFFFE4D7), textColor: Color(0xFFFF3838)),
  gamboge(backgroundColor: Color(0xFFFEF3CC), textColor: Color(0xFFCA7A05)),
  eucalyptus(backgroundColor: Color(0xFFDCFCE3), textColor: Color(0xFF279780)),
  mint(backgroundColor: Color(0xFFDCFCE3), textColor: Color(0xFF39B58F)),
  mintSolid(backgroundColor: Color(0xFF39B58F), textColor: Colors.white),
  deepLemon(backgroundColor: Color(0xFFFEF9D1), textColor: Color(0xFF795705)),
  royalNavy(backgroundColor: Color(0xFFEAF7FF), textColor: Color(0xFF006AD3));

  final Color backgroundColor;
  final Color textColor;

  const TagCategoryType({
    required this.backgroundColor,
    required this.textColor,
  });
}

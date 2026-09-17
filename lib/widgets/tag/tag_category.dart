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
  eucalyptus(backgroundColor: Color(0xFFE7E0FF), textColor: Color(0xFF3A1D8F)),
  mint(backgroundColor: Color(0xFFE7E0FF), textColor: Color(0xFF5B37D0)),
  mintSolid(backgroundColor: Color(0xFF3A1D8F), textColor: Colors.white),
  deepLemon(backgroundColor: Color(0xFFFEF9D1), textColor: Color(0xFF795705)),
  royalNavy(backgroundColor: Color(0xFFEAF7FF), textColor: Color(0xFF006AD3));

  final Color backgroundColor;
  final Color textColor;

  const TagCategoryType({
    required this.backgroundColor,
    required this.textColor,
  });
}

import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key, required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.d16,
        Dimens.d16,
        Dimens.d8,
        Dimens.d16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.d50),
        child: Image.network(
          avatarUrl,
          width: Dimens.d48,
          height: Dimens.d48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ClipRect(
              child: (avatarUrl.isSvg())
                  ? SvgPicture.network(avatarUrl)
                  : Assets.images.avatar.svg(width: Dimens.d48),
            );
          },
        ),
      ),
    );
  }
}

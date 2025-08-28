import 'package:farm/features/account/account/model/account_menu_item.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key, required this.menuItem});

  final AccountMenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (menuItem.url.isNotEmpty) {
          // IntentUtils.openBrowserURL(url: menuItem.url);
        } else {
          if (menuItem.action != null) {
            menuItem.action!();
          }
        }
      },
      child: Ink(
        padding: const EdgeInsets.all(Dimens.d8),
        child: Row(
          children: [
            Align(child: menuItem.icon),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: Dimens.d10,
                  right: Dimens.d16,
                ),
                child: Text(menuItem.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

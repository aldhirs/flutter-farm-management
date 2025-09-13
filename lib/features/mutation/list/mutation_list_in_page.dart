import 'package:auto_route/auto_route.dart';
import 'package:farm/features/mutation/list/mutation_list_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MutationListInPage extends StatelessWidget {
  const MutationListInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MutationListPage(isIn: true);
  }
}

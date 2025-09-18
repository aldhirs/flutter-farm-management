import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_bloc.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_event.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_state.dart';
import 'package:farm/features/cattle/search/widgets/search_bottom_sheet.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/views/common_scaffold.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class CattleSearchPage extends StatefulWidget {
  const CattleSearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends BasePageState<CattleSearchPage, CattleSearchBloc>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.add(Initiated());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addManualBottomSheet.call();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CattleSearchBloc, CattleSearchState>(
          listenWhen: (previous, current) =>
              previous.successMessage != current.successMessage,
          listener: (context, state) async {
            if (state.successMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.successMessage,
                type: ToastType.succes,
              );
            }
          },
        ),
        BlocListener<CattleSearchBloc, CattleSearchState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
          listener: (context, state) async {
            if (state.errorMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.errorMessage,
                type: ToastType.error,
              );
            }
          },
        ),
        BlocListener<CattleSearchBloc, CattleSearchState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null) {
              navigator.pop();
              ToastHelper().showToast(
                context: context,
                message:
                    "Data sapi ${state.cattle?.ear_tag.defaultValue('-')} berhasil ditemukan",
                type: ToastType.succes,
              );
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<CattleSearchBloc, CattleSearchState>(
      builder: (context, state) {
        return CommonScaffold(
          body: ListView(children: [_identityWidget(state)]),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _addButton(),
        );
      },
    );
  }

  Widget _addButton() {
    return FloatingActionButton.extended(
      heroTag: 'addBtn',
      backgroundColor: AppColors.current.eucalyptus700,
      onPressed: _addManualBottomSheet,
      label: Text(
        'Cari Sapi',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: const Icon(LucideIcons.search, color: Colors.white),
    );
  }

  void _addManualBottomSheet() async {
    await navigator.showBottomSheet(
      isScrollControlled: true,
      SearchBottomSheet(bloc: bloc, onDismiss: () => navigator.pop()),
    );
  }

  Widget _identityWidget(CattleSearchState state) {
    final cattle = state.cattle;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail items
            _detailItem(
              "ID",
              (cattle?.id).defaultValue("-"),
              Icons.fingerprint,
            ),
            _detailItem(
              "Ear Tag",
              (cattle?.ear_tag).defaultValue("-"),
              Icons.confirmation_number,
            ),
            _detailItem(
              "RFID",
              (cattle?.rfid_tag).defaultValue("-"),
              Icons.qr_code_2_rounded,
            ),
            _detailItem(
              "Kandang & Pen",
              "${(cattle?.pen?.name_barn).orEmpty()} - ${(cattle?.pen?.name).orEmpty()}",
              Icons.home_work_outlined,
            ),
            _detailItem(
              "Status",
              (cattle?.statusLabel()).defaultValue("-"),
              Icons.verified_user,
            ),
            _detailItem(
              "Bobot Terakhir",
              "${(cattle?.actual_weight).defaultZero()} Kg",
              Icons.monitor_weight,
            ),
            _detailItem(
              "Jenis Kelamin",
              (cattle?.genderLabel()).orEmpty(),
              Icons.male_outlined,
            ),
            _detailItem("Grade", (cattle?.level?.name).orEmpty(), Icons.star),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value, IconData icon, {Widget? tag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black87.withOpacity(0.15),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.label2().copyWith(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyles.body1().copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (tag != null) tag,
        ],
      ),
    );
  }
}

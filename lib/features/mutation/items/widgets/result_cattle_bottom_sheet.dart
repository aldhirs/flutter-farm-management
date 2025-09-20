import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/mutation/items/bloc/mutation_items_bloc.dart';
import 'package:farm/features/mutation/items/bloc/mutation_items_state.dart';
import 'package:farm/features/mutation/items/widgets/detail_bottom_sheet.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultCattleBottomSheet extends StatefulWidget {
  const ResultCattleBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
    required this.onTap,
  });

  final MutationItemsBloc bloc;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  @override
  State<ResultCattleBottomSheet> createState() =>
      _ResultCattleBottomSheetState();
}

class _ResultCattleBottomSheetState extends State<ResultCattleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Dimens.d16),
      alignment: Alignment.topLeft,
      height:
          MediaQuery.of(context).size.height *
          0.75, // biar bottomsheet cukup tinggi
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Konfirmasi Penambahan Item",
              style: TextStyles.heading5(),
            ),
          ),
          const SizedBox(height: 8),
          _errorWidget(),

          /// scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Column(
                children: [
                  DetailBottomSheet(
                    item: widget.bloc.state.mutation,
                    onDismiss: () {},
                    showBottomSheet: true,
                    isShowTitle: false,
                  ),
                  _animalIdentityWidget(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// sticky button
          _addButton(),
        ],
      ),
    );
  }

  Widget _animalIdentityWidget() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        initiallyExpanded: true, // otomatis terbuka
        title: Text("Identitas Sapi", style: TextStyles.body1()),
        subtitle: Text(
          (widget.bloc.state.cattle?.ear_tag).defaultValue("-"),
          style: TextStyles.label2(),
        ),
        children: [
          ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getCattleItems().length,
            itemBuilder: (context, index) {
              final item = _getCattleItems()[index];
              return _itemWidget(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _itemWidget(ListItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.name,
              style: TextStyles.body2().copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              item.description.defaultValue('-'),
              textAlign: TextAlign.end,
              style: TextStyles.body2(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<MutationItemsBloc, MutationItemsState>(
        buildWhen: (p, c) => p.addErrorMessage != c.addErrorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.addErrorMessage.isNotEmpty,
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TickerView(
                    type: TickerViewType.danger,
                    message: state.addErrorMessage,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addButton() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<MutationItemsBloc, MutationItemsState>(
        buildWhen: (p, c) =>
            p.addLoading != c.addLoading || p.cattle != c.cattle,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Button(
              type: ButtonType.primary,
              leftIcon: const Icon(Icons.add, color: Colors.white),
              text: 'Tambahkan ke Item Mutasi',
              fulLWidth: true,
              loading: state.addLoading,
              onPressed: widget.onTap,
            ),
          );
        },
      ),
    );
  }

  List<ListItem> _getCattleItems() {
    final data = widget.bloc.state.cattle ?? const Cattle();
    return [
      ListItem(name: 'ID', description: data.id),
      ListItem(name: 'RFID', description: data.rfid_tag),
      ListItem(name: 'Kandang', description: data.pen?.name_barn ?? '-'),
      ListItem(name: 'Pen', description: data.pen?.name ?? '-'),
      ListItem(name: 'Ear Tag', description: data.ear_tag),
      ListItem(name: 'Bobot', description: '${data.actual_weight} KG'),
      ListItem(name: 'Ras', description: data.id_breed),
      ListItem(name: 'Jenis Kelamin', description: data.genderLabel()),
      ListItem(name: 'Status', description: data.statusLabel()),
    ];
  }
}

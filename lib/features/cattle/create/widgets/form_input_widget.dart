import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_bloc.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_event.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormInputWidget extends StatefulWidget {
  FormInputWidget({super.key, required this.bloc, this.rfid});

  final CattleCreateBloc bloc;
  String? rfid;

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  final TextEditingController _rfidController = TextEditingController();
  final TextEditingController _earTagController = TextEditingController();
  final TextEditingController _penController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  late final ValueNotifier<List<DropdownCheckboxModel>> _receptionItems;
  late final ValueNotifier<List<DropdownCheckboxModel>> _barnItems;

  @override
  void initState() {
    _rfidController.text = widget.rfid.defaultValue('-');
    _receptionItems = ValueNotifier([]);
    _barnItems = ValueNotifier([]);
    super.initState();
  }

  @override
  void dispose() {
    _barnItems.dispose();
    _rfidController.dispose();
    _earTagController.dispose();
    _penController.dispose();
    _receptionItems.dispose();
    _stationController.dispose();
    _supplierController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TickerView(
            type: TickerViewType.info,
            message:
                "Formulir ini digunakan untuk menambahkan data sapi secara manual ketika RFID diterima tapi tidak ditemukan di database, atau ketika RFID sama sekali tidak tersedia.",
          ),
          const SizedBox(height: 8),
          _errorWidget(),
          const SizedBox(height: 16),
          _textInputRFID(),
          const SizedBox(height: 14),
          _textInputEarTag(),
          const SizedBox(height: 14),
          _dropdownReceptions(),
          _dropdownBreed(),
          _dropdownSuppliers(),
          _dropdownPoo(),
          // _dropdownGender(),
          // _dropdownBarn(),
          // _dropdownPen(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _dropdownBreed() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) =>
            p.breeds != c.breeds || p.selectedBreed != c.selectedBreed,
        builder: (context, state) {
          return DropdownViewField(
            controller: _breedController,
            title: 'Breed',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.breeds
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedBreed?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.breeds
                  .where((item) => item.id.toString() == value.first)
                  .first;
              widget.bloc.add(BreedChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _textInputRFID() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        builder: (context, state) {
          return TextInputField(
            controller: _rfidController,
            label: 'RFID',
            enabled: false,
            hintText: 'RFID',
            keyboardType: TextInputType.number,
            additionalInfo: "Otomatis terisi ketika RFID diterima",
            prefixIcon: Icon(
              Icons.barcode_reader,
              color: AppColors.current.mint700,
            ),
          );
        },
      ),
    );
  }

  Widget _textInputEarTag() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        builder: (context, state) {
          return TextInputField(
            controller: _earTagController,
            label: 'Ear Tag',
            hintText: 'Masukkan Ear Tag',
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.earbuds, color: AppColors.current.mint700),
            onChanged: (value) {
              widget.bloc.add(EarTagChanged(value: value));
            },
            additionalInfo:
                "Masukkan ear tag sapi untuk memudahkan proses identifikasi.",
          );
        },
      ),
    );
  }

  Widget _dropdownReceptions() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) =>
            p.receptions != c.receptions ||
            p.selectedReception != c.selectedReception,
        builder: (context, state) {
          // 🔥 jadwalkan update setelah frame, biar nggak bentrok dengan build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _receptionItems.value = state.receptions
                .map(
                  (item) => DropdownCheckboxModel(
                    id: item.reception.id,
                    text: item.reception.title,
                    selected: item.id == state.selectedReception?.id,
                  ),
                )
                .toList();
          });

          return DropdownViewField(
            title: 'Shipment',
            showSearchBar: true,
            searchHint: "cari minimal 3 karakter",
            doOnKeywordSearch: (keyword) {
              widget.bloc.add(GetReceptions(search: keyword));
            },
            items: _receptionItems, // ✅ satu instance sepanjang lifecycle
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.receptions.firstWhere(
                (item) => item.reception.id.toString() == value.first,
              );
              widget.bloc.add(ReceptionChanged(value: selected.reception));
              _breedController.text = '';
              _supplierController.text = '';
              _stationController.text = '';
            },
          );
        },
      ),
    );
  }

  Widget _dropdownSuppliers() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) =>
            p.suppliers != c.suppliers ||
            p.selectedSupplier != c.selectedSupplier,
        builder: (context, state) {
          return DropdownViewField(
            controller: _supplierController,
            title: 'IMP',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.suppliers
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedSupplier?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.suppliers
                  .where((item) => item.id.toString() == value.first)
                  .first;
              widget.bloc.add(SupplierChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownPoo() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) =>
            p.stations != c.stations || p.selectedStation != c.selectedStation,
        builder: (context, state) {
          return DropdownViewField(
            controller: _stationController,
            title: 'POO',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.stations
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedSupplier?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.stations
                  .where((item) => item.id.toString() == value.first)
                  .first;
              widget.bloc.add(StationChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) => p.errorMessage != c.errorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.errorMessage.isNotEmpty,
            child: TickerView(
              type: TickerViewType.danger,
              message: state.errorMessage,
            ),
          );
        },
      ),
    );
  }
}

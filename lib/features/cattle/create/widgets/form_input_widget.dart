import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_bloc.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_event.dart';
import 'package:farm/features/cattle/create/bloc/cattle_create_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_field.dart';
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
          _dropdownSuppliers(),
          _dropdownBreed(),
          _dropdownLevel(),
          _dropdownGender(),
          // _dropdownBarn(),
          // _dropdownPen(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _dropdownGender() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) => p.selectedGender != c.selectedGender,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Jenis Kelamin',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              genderMap.entries
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.key,
                      text: item.value,
                      selected: item.key == state.selectedGender,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = genderMap.entries
                  .where((item) => item.key == value.first)
                  .first;
              widget.bloc.add(GenderChanged(value: selected.key));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownBreed() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) => p.breeds != c.breeds,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Ras',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.breeds
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id,
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
                  .where((item) => item.id == value.first)
                  .first;
              widget.bloc.add(BreedChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownBarn() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) => p.barns != c.barns,
        builder: (context, state) {
          // 🔥 jadwalkan update setelah frame, biar nggak bentrok dengan build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _barnItems.value = state.barns
                .map(
                  (item) => DropdownCheckboxModel(
                    id: item.id,
                    text: item.name,
                    selected: item.id == state.selectedBarn?.id,
                    notes: item.category,
                  ),
                )
                .toList();
          });
          return DropdownViewField(
            title: 'Kandang',
            items: _barnItems,
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            showSearchBar: true,
            searchHint: "cari minimal 3 karakter",
            doOnKeywordSearch: (keyword) {
              widget.bloc.add(GetBarns(search: keyword));
            },
            onSelectedItems: (List<String> value) {
              final selected = state.barns
                  .where((item) => item.id == value.first)
                  .first;
              widget.bloc.add(BarnChanged(barn: selected));
              _penController.text = "";
            },
          );
        },
      ),
    );
  }

  Widget _dropdownPen() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        builder: (context, state) {
          return DropdownViewPenField(
            controller: _penController,
            title: 'Pen Tujuan',
            items: ValueNotifier<List<Pen>>(
              state.pens
                  .map(
                    (item) => item.copyWith(
                      selected: item.id == state.selectedPen?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            sheetSize: BottomSheetSize.full,
            emptyStateMessage: state.selectedBarn == null
                ? 'Silakan pilih kandang terlebih dahulu.'
                : 'Data tidak ditemukan',
            onSelectedItems: (List<Pen> value) {
              widget.bloc.add(PenChanged(pen: value.first));
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

  Widget _dropdownLevel() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CattleCreateBloc, CattleCreateState>(
        buildWhen: (p, c) => p.levels != c.levels,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Grade',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.levels
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedLevel?.id,
                      notes:
                          'Estimasi Penggemukan: ${item.estimation_day} Hari',
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.levels
                  .where((item) => item.id.toString() == value.first)
                  .first;
              widget.bloc.add(LevelChanged(value: selected));
            },
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
                    id: item.id.toString(),
                    text: item.bl_number,
                    selected: item.id == state.selectedReception?.id,
                  ),
                )
                .toList();
          });

          return DropdownViewField(
            title: 'Reception',
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
                (item) => item.id.toString() == value.first,
              );
              widget.bloc.add(ReceptionChanged(value: selected));
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
        buildWhen: (p, c) => p.suppliers != c.suppliers,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Supplier',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.suppliers
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.company_name,
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

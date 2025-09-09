import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/widgets/dropdownview/dropdown_input_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_pen_bottomsheet.dart';
import 'package:flutter/material.dart';

class DropdownViewPenField extends StatefulWidget {
  DropdownViewPenField({
    super.key,
    required this.title,
    required this.dropdownType,
    required this.items,
    required this.navigator,
    required this.onSelectedItems,
    this.showSearchBar = false,
    this.dismissible = true,
    this.doOnKeywordSearch,
    this.searchHint = '',
    this.controller,
    this.searchDebounceDuration = const Duration(seconds: 1),
    this.maxSelection,
    this.sheetSize = BottomSheetSize.fitContent,
    this.emptyStateMessage,
  });

  final Function(String keyword)? doOnKeywordSearch;
  final bool showSearchBar;
  final bool dismissible;
  final String title;
  final String searchHint;
  final ValueChanged<List<Pen>> onSelectedItems;
  final ValueNotifier<List<Pen>> items;
  final AppNavigator navigator;
  final DropdownTypeEnum dropdownType;
  TextEditingController? controller;
  final Duration searchDebounceDuration;
  final int? maxSelection;
  final BottomSheetSize sheetSize;
  final String? emptyStateMessage;

  @override
  State<StatefulWidget> createState() => _DropdownViewPenFieldState();
}

class _DropdownViewPenFieldState extends State<DropdownViewPenField> {
  TextEditingController _controller = TextEditingController();
  bool isShowDropdown = false;
  String searchText = '';
  DropdownInputState textInputState = DropdownInputState.inactive;

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      setState(() {
        _controller = widget.controller ?? TextEditingController();
      });
    }

    return SafeArea(
      child: ValueListenableBuilder<List<Pen>>(
        valueListenable: widget.items,
        builder: (context, items, _) {
          final selectedItems = items.where((item) => item.selected).toList();

          if (selectedItems.isNotEmpty) {
            if (widget.dropdownType == DropdownTypeEnum.single) {
              _controller.text =
                  "${selectedItems.first.name_barn} -  ${selectedItems.first.name}";
            } else {
              _controller.text = '${selectedItems.length} opsi dipilih';
            }
          } else {
            if (_controller.value.text.isEmpty) {
              _controller.clear();
            }
          }

          return DropdownInputField(
            controller: _controller,
            dropdownInputState: textInputState,
            label: widget.title,
            hintText: widget.searchHint,
            isShowDropdown: isShowDropdown,
            onTap: _onShowBottomsheet,
          );
        },
      ),
    );
  }

  void _onShowBottomsheet() {
    _toggleDropdown(true);
    textInputState = DropdownInputState.active;

    widget.navigator.showBottomSheet(
      DropdownViewPenBottomsheet(
        title: widget.title,
        searchHint: widget.searchHint,
        items: widget.items,
        navigator: widget.navigator,
        hasSearchBar: widget.showSearchBar,
        onChoose: (value) => _onChoose(value),
        onDismiss: _onDismiss,
        dismissible: widget.dismissible,
        doOnKeywordSearch: widget.doOnKeywordSearch,
        searchDebounceDuration: widget.searchDebounceDuration,
        maxSelection: widget.maxSelection,
        sheetSize: widget.sheetSize,
        emptyStateMessage: widget.emptyStateMessage,
      ),
      isDismissible: widget.dismissible,
      onDismiss: _onDismiss,
      isScrollControlled: true,
      isContentPlain: false,
      enableDrag: false,
    );
  }

  void _toggleDropdown(bool toggle) {
    setState(() {
      isShowDropdown = toggle;
    });
  }

  Future<void> _onChoose(List<Pen> items) async {
    final selectedItems = items.where((item) => item.selected).toList();
    widget.items.value = items;

    widget.onSelectedItems.call(selectedItems);

    if (selectedItems.isNotEmpty) {
      _controller.text =
          "${selectedItems.first.name_barn}  - ${selectedItems.first.name}";
    } else {
      _controller.clear();
      FocusScope.of(context).unfocus();
    }

    await _onDismiss();
  }

  Future<void> _onDismiss() async {
    _toggleDropdown(false);
    FocusScope.of(context).unfocus();
    textInputState = DropdownInputState.inactive;
    setState(() {});
  }
}

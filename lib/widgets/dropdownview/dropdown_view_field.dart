import 'package:farm/constants/enum_constants.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/widgets/dropdownview/dropdown_input_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:flutter/material.dart';

import 'dropdown_view_bottomsheet.dart';

class DropdownViewField extends StatefulWidget {
  DropdownViewField({
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
  final ValueChanged<List<String>> onSelectedItems;
  final ValueNotifier<List<DropdownCheckboxModel>> items;
  final AppNavigator navigator;
  final DropdownTypeEnum dropdownType;
  TextEditingController? controller;
  final Duration searchDebounceDuration;
  final int? maxSelection;
  final BottomSheetSize sheetSize;
  final String? emptyStateMessage;

  @override
  State<StatefulWidget> createState() => _DropdownViewFieldState();
}

class _DropdownViewFieldState extends State<DropdownViewField> {
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
      child: ValueListenableBuilder<List<DropdownCheckboxModel>>(
        valueListenable: widget.items,
        builder: (context, items, _) {
          final selectedItems = items.where((item) => item.selected).toList();

          if (selectedItems.isNotEmpty) {
            if (widget.dropdownType == DropdownTypeEnum.single) {
              _controller.text = selectedItems.first.text;
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
      DropdownViewBottomsheet(
        title: widget.title,
        searchHint: widget.searchHint,
        items: widget.items,
        navigator: widget.navigator,
        hasSearchBar: widget.showSearchBar,
        onChoose: (value) => _onChoose(value),
        onDismiss: _onDismiss,
        dropdownType: widget.dropdownType,
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

  Future<void> _onChoose(List<DropdownCheckboxModel> items) async {
    final selectedItems = items.where((item) => item.selected).toList();
    widget.items.value = items;

    widget.onSelectedItems.call(
      selectedItems.map((item) => item.text).toList(),
    );

    if (selectedItems.isNotEmpty) {
      _controller.text = widget.dropdownType == DropdownTypeEnum.single
          ? selectedItems.first.text
          : '${selectedItems.length} opsi dipilih';
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

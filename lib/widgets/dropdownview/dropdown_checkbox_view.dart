import 'package:dartx/dartx.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/widgets/dropdownview/dropdown_checkbox_bottomsheet.dart';
import 'package:farm/widgets/dropdownview/dropdown_input_field.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
 DropdownCheckboxView(
            title: "Bidang/Industri",
            searchHint: "Cari bidang studi/industri",
            items: [
              const DropdownCheckboxModel(text: "Satu", selected: false),
              const DropdownCheckboxModel(text: "Dua", selected: false),
              const DropdownCheckboxModel(text: "Tiga", selected: false),
              const DropdownCheckboxModel(text: "Tiga2", selected: false),
              const DropdownCheckboxModel(text: "Tiga3", selected: false),
              const DropdownCheckboxModel(text: "Tiga4", selected: false),
              const DropdownCheckboxModel(text: "Tiga5", selected: false),
              const DropdownCheckboxModel(text: "Tiga6", selected: false),
              const DropdownCheckboxModel(text: "Tiga7", selected: false),
            ],
            navigator: navigator,
            onSelectedItems: (val) {
              print(val);
            },
          ),
 */

class DropdownCheckboxView extends StatefulWidget {
  DropdownCheckboxView({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.navigator,
    required this.onSelectedItems,
    this.showSearchBar = false,
    this.dismissible = true,
    this.doOnKeywordSearch,
    this.searchDebounceDuration = const Duration(seconds: 1),
    this.maxSelection,
  });
  final Function(String keyword)? doOnKeywordSearch;
  final bool showSearchBar;
  final bool dismissible;
  final String title;
  final String searchHint;
  final ValueChanged<List<String>> onSelectedItems;
  final ValueNotifier<List<DropdownCheckboxModel>> items;
  final AppNavigator navigator;
  TextEditingController? controller;
  final Duration searchDebounceDuration;
  final int? maxSelection;

  @override
  State<StatefulWidget> createState() => _DropdownCheckboxViewState();
}

class _DropdownCheckboxViewState extends State<DropdownCheckboxView> {
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
            _controller.text = '${selectedItems.length} opsi dipilih';
          } else {
            if (_controller.value.text.isEmpty) {
              _controller.clear();
            }
          }

          return DropdownInputField(
            controller: _controller,
            dropdownInputState: textInputState,
            label: widget.title,
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
      DropdownCheckboxBottomsheet(
        title: widget.title,
        searchHint: widget.searchHint,
        items: widget.items,
        navigator: widget.navigator,
        doOnKeywordSearch: widget.doOnKeywordSearch,
        hasSearchBar: true,
        onChoose: (value) {
          _onChoose(value);
        },
        onDismiss: _onDismiss,
        dismissible: widget.dismissible,
        searchDebounceDuration: widget.searchDebounceDuration,
        maxSelection: widget.maxSelection,
      ),
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
    final selectedItems = items.filter((item) => item.selected).toList();
    // widget.items = items;
    widget.onSelectedItems.call(
      selectedItems.map((item) => item.text).toList(),
    );
    if (selectedItems.isNotEmpty) {
      _controller.text = '${selectedItems.length} opsi dipilih';
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

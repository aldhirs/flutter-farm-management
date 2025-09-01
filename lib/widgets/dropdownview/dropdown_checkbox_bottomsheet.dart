import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:flutter/material.dart';

class DropdownCheckboxBottomsheet extends StatefulWidget {
  const DropdownCheckboxBottomsheet({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.navigator,
    required this.onDismiss,
    required this.onChoose,
    required this.dismissible,
    this.doOnKeywordSearch,
    this.hasSearchBar = false,
    this.searchDebounceDuration,
    this.maxSelection,
  });

  final String title;
  final String searchHint;
  final ValueNotifier<List<DropdownCheckboxModel>> items;
  final ValueChanged<List<DropdownCheckboxModel>> onChoose;
  final GestureTapCallback onDismiss;
  final AppNavigator navigator;
  final bool dismissible;
  final bool hasSearchBar;
  final Function(String keyword)? doOnKeywordSearch;
  final Duration? searchDebounceDuration;
  final int? maxSelection;

  @override
  State<StatefulWidget> createState() => _DropdownCheckboxBottomsheetState();
}

class _DropdownCheckboxBottomsheetState
    extends State<DropdownCheckboxBottomsheet> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  late List<DropdownCheckboxModel> selectedItems;
  late List<DropdownCheckboxModel> originalItems;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<DropdownCheckboxModel> sortSelectedFirst(
    List<DropdownCheckboxModel> items,
  ) {
    return [...items]
      ..sort((a, b) => (b.selected ? 1 : 0).compareTo(a.selected ? 1 : 0));
  }

  Future<void> _onChoose() async {
    widget.onChoose.call(selectedItems);
    await widget.navigator.pop();
  }

  void _onSearchChanged(String text) {
    if (widget.searchDebounceDuration == null) {
      _applySearch(text);
    } else {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }
      _debounce = Timer(
        widget.searchDebounceDuration ?? const Duration(seconds: 1),
        () => _applySearch(text),
      );
    }
  }

  void _applySearch(String text) {
    setState(() {
      searchText = text;
      final lowerKeyword = text.toLowerCase();

      final filtered = originalItems.where((item) {
        return item.selected || item.text.toLowerCase().contains(lowerKeyword);
      }).toList();

      selectedItems = sortSelectedFirst(filtered);
      widget.items.value = filtered;
    });

    if (widget.doOnKeywordSearch != null) {
      widget.doOnKeywordSearch!(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(Dimens.d16),
          child: Text(widget.title, style: TextStyles.body1()),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
        //   child: SearchBarWidget(
        //     hint: widget.searchHint,
        //     controller: _searchController,
        //     onSearch: _onSearch,
        //     onChanged: _onSearchChanged,
        //     onEndActionClicked: _onSearchClear,
        //   ),
        // ),
        const SizedBox(height: Dimens.d8),
        SizedBox(
          height: ViewUtils.screenHeight() * 0.34,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: selectedItems.length,
            itemBuilder: (context, index) {
              final selectedItem = selectedItems[index];
              bool selected = selectedItem.selected;
              return GestureDetector(
                key: UniqueKey(),
                onTap: () {
                  _onItemSelected(index, !selected);
                  selected = !selected;
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimens.d16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedItem.text,
                          style: TextStyles.label1(),
                        ),
                      ),
                      CheckboxButton(value: selected),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(
                left: Dimens.d16,
                right: Dimens.d16,
              ),
              child: Divider(
                thickness: Dimens.d1,
                color: AppColors.current.neutral500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.d16,
            vertical: Dimens.d8,
          ),
          child: Button(
            fulLWidth: true,
            type: ButtonType.primary,
            size: ButtonSize.medium,
            text: 'Pilih',
            onPressed: _onChoose,
          ),
        ),
        const SizedBox(height: Dimens.d16),
      ],
    );
  }

  Future<void> _onItemSelected(int index, bool selected) async {
    final currentItems = widget.items.value;

    if (selected &&
        widget.maxSelection != null &&
        selectedItems.where((item) => item.selected).length >=
            widget.maxSelection!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maksimal seleksi ${widget.maxSelection.toString()}'),
        ),
      );
      return;
    }

    final item = selectedItems[index];
    final updatedItem = item.copyWith(selected: selected);
    selectedItems[index] = updatedItem;

    final originalIndex = originalItems.indexWhere((i) => i.id == item.id);
    if (originalIndex != -1) {
      originalItems[originalIndex] = updatedItem;
    }

    final newList = currentItems
        .map((i) => i.id == item.id ? updatedItem : i)
        .toList();
    widget.items.value = newList;
  }

  void _onSearch(text) {
    selectedItems.filter(
      (item) => item.selected == false && item.text.contains(text),
    );
  }

  void _onSearchClear() {
    _searchController.clear();

    // Kembalikan ke list original (tanpa memanggil doOnKeywordSearch)
    setState(() {
      searchText = '';
      selectedItems = sortSelectedFirst(originalItems);
      widget.items.value = List.from(originalItems); // restore list awal ke UI
    });
  }

  // void _onResetSelection() {
  //   final resetList = widget.items.value.map((item) => item.copyWith(selected: false)).toList();
  //   widget.items.value = resetList;
  //   setState(() {
  //     selectedItems = resetList;
  //     originalItems = resetList;
  //   });
  // }
}

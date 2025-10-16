import 'dart:async';

import 'package:farm/constants/enum_constants.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/inputs/search_bar_widget.dart';
import 'package:flutter/material.dart';

class DropdownViewBottomsheet extends StatefulWidget {
  const DropdownViewBottomsheet({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    required this.navigator,
    required this.onDismiss,
    required this.onChoose,
    required this.dropdownType,
    required this.dismissible,
    this.doOnKeywordSearch,
    this.hasSearchBar = false,
    this.searchDebounceDuration,
    this.maxSelection,
    this.emptyStateMessage,
    this.sheetSize = BottomSheetSize.fitContent, // 👈 default existing
  });

  final String title;
  final String searchHint;
  final ValueNotifier<List<DropdownCheckboxModel>> items;
  final ValueChanged<List<DropdownCheckboxModel>> onChoose;
  final GestureTapCallback onDismiss;
  final AppNavigator navigator;
  final DropdownTypeEnum dropdownType;
  final bool dismissible;
  final bool hasSearchBar;
  final Function(String keyword)? doOnKeywordSearch;
  final Duration? searchDebounceDuration;
  final int? maxSelection;
  final BottomSheetSize sheetSize; // 👈 new config
  final String? emptyStateMessage;

  @override
  State<StatefulWidget> createState() => _DropdownViewBottomsheetState();
}

class _DropdownViewBottomsheetState extends State<DropdownViewBottomsheet> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  late List<DropdownCheckboxModel> selectedItems;
  late List<DropdownCheckboxModel> originalItems;
  Timer? _debounce;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    originalItems = List.from(widget.items.value);
    if (DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
        DropdownTypeEnum.multiple) {
      selectedItems = sortSelectedFirst(originalItems);
    } else {
      selectedItems = List.from(originalItems);
    }
    _isInitialLoad = false;
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

  Future<void> _onChoose() async {
    widget.onChoose.call(selectedItems);
    _isInitialLoad = true; // 👉 supaya next open, terurut lagi
    await widget.navigator.pop();
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      widget.searchDebounceDuration ?? const Duration(milliseconds: 800),
      () async {
        setState(() {
          searchText = text;
        });

        if (text.isEmpty) {
          // Restore ke data default (parent bisa isi ulang items.value dengan all data)
          widget.doOnKeywordSearch?.call('');
          return;
        }

        if (text.length < 3) {
          // Kalau kurang dari 3 huruf, jangan fetch
          return;
        }

        // Trigger API lewat callback parent
        widget.doOnKeywordSearch?.call(text);
      },
    );
  }

  void _onSearchClear() {
    _searchController.clear();

    // Kembalikan ke list original (tanpa memanggil doOnKeywordSearch)
    setState(() {
      searchText = '';
      selectedItems =
          DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
              DropdownTypeEnum.multiple
          ? sortSelectedFirst(originalItems)
          : List.from(originalItems);

      widget.items.value = List.from(originalItems); // restore list awal ke UI
    });
  }

  void _onResetSelection() async {
    final resetList = widget.items.value
        .map((item) => item.copyWith(selected: false))
        .toList();
    widget.items.value = resetList;
    setState(() {
      selectedItems = resetList;
      originalItems = resetList;
    });
    widget.onChoose.call(resetList);
    await widget.navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Jangan ubah selectedItems setiap build!
    // Biarkan posisi list tetap stabil selama user memilih
    if (_isInitialLoad) {
      if (DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
          DropdownTypeEnum.multiple) {
        selectedItems = sortSelectedFirst(originalItems);
      } else {
        selectedItems = List.from(originalItems);
      }
      _isInitialLoad = false;
    }
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget(),
        _searchBarWidget(),
        const SizedBox(height: Dimens.d8),
        DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
                DropdownTypeEnum.single
            ? _listSingleSelect()
            : _listMultipleSelect(),
        _footerWidget(),
        const SizedBox(height: Dimens.d16),
      ],
    );

    switch (widget.sheetSize) {
      case BottomSheetSize.full:
        return SizedBox(height: ViewUtils.screenHeight() * 0.9, child: content);
      case BottomSheetSize.half:
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: content,
        );
      case BottomSheetSize.fitContent:
      default:
        return content;
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   originalItems = List.from(widget.items.value);
  //   if (DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
  //       DropdownTypeEnum.single) {
  //     selectedItems = List.from(originalItems);
  //   } else {
  //     selectedItems = sortSelectedFirst(originalItems);
  //   }
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _titleWidget(),
  //       _searchBarWidget(),
  //       const SizedBox(height: Dimens.d8),
  //       DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
  //               DropdownTypeEnum.single
  //           ? _listSingleSelect()
  //           : _listMultipleSelect(),
  //       _footerWidget(),
  //       const SizedBox(height: Dimens.d16),
  //     ],
  //   );
  // }

  Widget _titleWidget() {
    return Visibility(
      visible: widget.title.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.all(Dimens.d16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: TextStyles.heading5()),
            if (DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
                DropdownTypeEnum.multiple)
              TextButton(
                onPressed: _onResetSelection,
                child: Text(
                  'Batalkan',
                  style: TextStyles.label2().copyWith(
                    color: AppColors.current.mint700,
                  ),
                ),
              ),
            if (widget.sheetSize == BottomSheetSize.full)
              TextButton(
                onPressed: () => widget.navigator.pop(),
                child: Text(
                  'Tutup',
                  style: TextStyles.label2().copyWith(
                    color: AppColors.current.mint700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _searchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
      child: Visibility(
        visible: widget.hasSearchBar,
        child: Column(
          children: [
            SearchBarWidget(
              hint: widget.searchHint,
              controller: _searchController,
              onSearch: (_) {},
              onChanged: _onSearchChanged,
              onEndActionClicked: _onSearchClear,
            ),
          ],
        ),
      ),
    );
  }

  Widget _listSingleSelect() {
    return ValueListenableBuilder<List<DropdownCheckboxModel>>(
      valueListenable: widget.items,
      builder: (context, value, _) {
        if (value.isEmpty) {
          return _emptyStateWidget();
        }

        final List<DropdownCheckboxModel> selectedItems = List.from(
          value,
        ); // langsung sync

        return SizedBox(
          height: value.length > 7 ? ViewUtils.screenHeight() * 0.78 : null,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: selectedItems.length,
            itemBuilder: (context, index) {
              final selectedItem = selectedItems[index];
              final selected = selectedItem.selected;
              return GestureDetector(
                onTap: () {
                  for (int i = 0; i < selectedItems.length; i++) {
                    selectedItems[i] = selectedItems[i].copyWith(
                      selected: i == index,
                    );
                  }
                  widget.onChoose.call(selectedItems);
                  widget.navigator.pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.d16,
                    vertical: Dimens.d8,
                  ),
                  color: selectedItem.color,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: _highlightMatch(
                                selectedItem.text,
                                searchText,
                              ),
                            ),
                            Visibility(
                              visible: selectedItem.notes.isNotEmpty,
                              child: Text(
                                selectedItem.notes,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyles.label4(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check, color: AppColors.current.mint700),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Padding(
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
        );
      },
    );
  }

  Widget _listMultipleSelect() {
    return ValueListenableBuilder<List<DropdownCheckboxModel>>(
      valueListenable: widget.items,
      builder: (context, value, _) {
        if (value.isEmpty) {
          return _emptyStateWidget();
        }

        // selectedItems = sortSelectedFirst(List.from(value));
        selectedItems = List.from(value); // biarkan urutan asli, no sort
        final isLimitReached =
            widget.maxSelection != null &&
            selectedItems.where((item) => item.selected).length >=
                widget.maxSelection!;

        return Column(
          children: [
            SizedBox(
              height: value.length > 12
                  ? ViewUtils.screenHeight() * 0.65
                  : null,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final selectedItem = selectedItems[index];
                  final selected = selectedItem.selected;
                  final isDisabled = isLimitReached && !selected;

                  return GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () => _onItemSelected(index, !selected),
                    child: Opacity(
                      opacity: isDisabled ? 0.4 : 1.0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: Dimens.d16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: _highlightMatch(
                                  selectedItem.text,
                                  searchText,
                                ),
                              ),
                            ),
                            CheckboxButton(
                              value: selected,
                              isEnabled: !isDisabled,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Padding(
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
            if (isLimitReached)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.d16,
                  vertical: Dimens.d8,
                ),
                child: Text(
                  'Maksimal seleksi ${widget.maxSelection.toString()}',
                  style: TextStyles.label2().copyWith(
                    color: AppColors.current.crimson500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _footerWidget() {
    return Visibility(
      visible:
          DropdownTypeEnum.getEnum(widget.dropdownType.value) ==
          DropdownTypeEnum.multiple,
      child: Padding(
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
    );
  }

  TextSpan _highlightMatch(String text, String keyword) {
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();

    final matchIndex = lowerText.indexOf(lowerKeyword);
    if (matchIndex == -1 || keyword.length < 3) {
      return TextSpan(text: text, style: TextStyles.body1());
    }

    return TextSpan(
      children: [
        TextSpan(
          text: text.substring(0, matchIndex),
          style: TextStyles.body1(),
        ),
        TextSpan(
          text: text.substring(matchIndex, matchIndex + keyword.length),
          style: TextStyles.body1().copyWith(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: text.substring(matchIndex + keyword.length),
          style: TextStyles.body1(),
        ),
      ],
    );
  }

  Widget _emptyStateWidget() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.d16),
      child: Center(
        child: Text(
          widget.emptyStateMessage.defaultValue('Data tidak ditemukan'),
          style: TextStyles.label1(),
        ),
      ),
    );
  }
}

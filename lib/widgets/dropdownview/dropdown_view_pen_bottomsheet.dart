import 'dart:async';

import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:flutter/material.dart';

class DropdownViewPenBottomsheet extends StatefulWidget {
  const DropdownViewPenBottomsheet({
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
    this.emptyStateMessage,
    this.sheetSize = BottomSheetSize.fitContent, // 👈 default existing
  });

  final String title;
  final String searchHint;
  final ValueNotifier<List<Pen>> items;
  final ValueChanged<List<Pen>> onChoose;
  final GestureTapCallback onDismiss;
  final AppNavigator navigator;
  final bool dismissible;
  final bool hasSearchBar;
  final Function(String keyword)? doOnKeywordSearch;
  final Duration? searchDebounceDuration;
  final int? maxSelection;
  final BottomSheetSize sheetSize; // 👈 new config
  final String? emptyStateMessage;

  @override
  State<StatefulWidget> createState() => _DropdownViewPenBottomsheetState();
}

class _DropdownViewPenBottomsheetState
    extends State<DropdownViewPenBottomsheet> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  late List<Pen> selectedItems;
  late List<Pen> originalItems;
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

  List<Pen> sortSelectedFirst(List<Pen> items) {
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
        return item.selected || item.name.toLowerCase().contains(lowerKeyword);
      }).toList();

      selectedItems = filtered;

      widget.items.value = filtered;
    });

    if (widget.doOnKeywordSearch != null) {
      widget.doOnKeywordSearch!(text);
    }
  }

  // void _onSearchChanged(String text) {
  //   if (_debounce?.isActive ?? false) {
  //     _debounce!.cancel();
  //   }
  //
  //   _debounce = Timer(widget.searchDebounceDuration, () {
  //     setState(() {
  //       searchText = text;
  //       final lowerKeyword = text.toLowerCase();
  //
  //       // Filter originalItems berdasarkan pencarian
  //       final filtered = originalItems
  //           .where((item) => item.selected || item.text.toLowerCase().contains(lowerKeyword))
  //           .toList();
  //
  //       // Sesuaikan selectedItems sesuai dengan hasil filter
  //       if (DropdownTypeEnum.getEnum(widget.dropdownType.value) == DropdownTypeEnum.multiple) {
  //         selectedItems = sortSelectedFirst(filtered);
  //       } else {
  //         selectedItems = filtered;
  //       }
  //
  //       // Update ValueNotifier dengan hasil filter
  //       widget.items.value = filtered;
  //     });
  //
  //     // Jika ada fungsi pencarian tambahan, panggil
  //     if (widget.doOnKeywordSearch != null) {
  //       widget.doOnKeywordSearch!(text);
  //     }
  //   });
  // }

  void _onSearchClear() {
    _searchController.clear();

    // Kembalikan ke list original (tanpa memanggil doOnKeywordSearch)
    setState(() {
      searchText = '';
      selectedItems = List.from(originalItems);

      widget.items.value = List.from(originalItems); // restore list awal ke UI
    });
  }

  void _onResetSelection() {
    final resetList = widget.items.value
        .map((item) => item.copyWith(selected: false))
        .toList();
    widget.items.value = resetList;
    setState(() {
      selectedItems = resetList;
      originalItems = resetList;
    });
  }

  @override
  Widget build(BuildContext context) {
    originalItems = List.from(widget.items.value);
    selectedItems = List.from(originalItems);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget(),
        _searchBarWidget(),
        const SizedBox(height: Dimens.d8),
        _listSingleSelect(),
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
        child: Text('Search'),
        // SearchBarWidget(
        //   hint: widget.searchHint,
        //   controller: _searchController,
        //   onSearch: (_) {},
        //   onChanged: _onSearchChanged,
        //   onEndActionClicked: _onSearchClear,
        // ),
      ),
    );
  }

  Widget _listSingleSelect() {
    return ValueListenableBuilder<List<Pen>>(
      valueListenable: widget.items,
      builder: (context, value, _) {
        if (value.isEmpty) {
          return _emptyStateWidget();
        }

        return SizedBox(
          height: value.length > 7 ? ViewUtils.screenHeight() * 0.78 : null,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: selectedItems.length,
            itemBuilder: (context, index) {
              final selectedItem = selectedItems[index];
              final selected = selectedItem.selected;
              final int total = selectedItem.capacity;
              final int filled = selectedItem.cattle_count;
              final int available = total - filled;
              return GestureDetector(
                onTap: () {
                  for (int i = 0; i < selectedItems.length; i++) {
                    selectedItems[i] = selectedItems[i].copyWith(
                      selected: i == index,
                    );
                  }
                  widget.onChoose.call(selectedItems);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    widget.navigator.pop();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimens.d10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.d16,
                    vertical: Dimens.d8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.current.mint200
                        : AppColors.current.neutral100,
                    border: BoxBorder.all(
                      width: 3,
                      color: selected
                          ? AppColors.current.mint300
                          : AppColors.current.neutral500,
                    ),
                    borderRadius: BorderRadius.circular(Dimens.d10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.home_outlined,
                                      size: 18,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        selectedItem.name_barn,
                                        style: TextStyles.label1(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.meeting_room_outlined,
                                      size: 18,
                                      color: Colors.indigo,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        selectedItem.name,
                                        style: TextStyles.label2().copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            /// Progress bar futuristis
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: selectedItem.getPercentage(),
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  selectedItem.getGradientColor(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tersedia: $available ekor",
                                  style: TextStyles.body3().copyWith(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  "$filled / $total ekor",
                                  style: TextStyles.body3().copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(left: Dimens.d16, right: Dimens.d16),
              child: SizedBox(height: 8),
            ),
          ),
        );
      },
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
    if (searchText.isEmpty || searchText.length < 3) {
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
    return const SizedBox.shrink();
  }
}

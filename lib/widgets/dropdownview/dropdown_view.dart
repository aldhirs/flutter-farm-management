import 'package:dartx/dartx.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/dropdownview/dropdown_input_field.dart';
import 'package:flutter/material.dart';

class DropdownView extends StatefulWidget {
  DropdownView({
    super.key,
    required this.title,
    required this.items,
    required this.navigator,
    required this.selectedFilterChanged,
    this.controller,
  });

  final String title;
  final ValueChanged<String> selectedFilterChanged;
  final List<String> items;
  final AppNavigator navigator;
  TextEditingController? controller;

  @override
  State<StatefulWidget> createState() => _DropdownViewState();
}

class _DropdownViewState extends State<DropdownView> {
  bool isShowDropdown = false;
  DropdownInputState textInputState = DropdownInputState.inactive;

  @override
  Widget build(BuildContext context) {
    return DropdownInputField(
      controller: widget.controller,
      dropdownInputState: textInputState,
      label: widget.title,
      isShowDropdown: isShowDropdown,
      onTap: () {
        textInputState = DropdownInputState.active;
        isShowDropdown = true;
        widget.navigator.showBottomSheet(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(Dimens.d16),
                child: Text('Jenis Kelamin', style: TextStyles.body2()),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      isShowDropdown = false;
                      textInputState = DropdownInputState.inactive;
                      widget.controller?.text = widget.items[index];
                      widget.selectedFilterChanged(
                        (widget.controller?.text).orEmpty(),
                      );
                      await widget.navigator.pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: Dimens.d16,
                        vertical: Dimens.d8,
                      ),
                      child: Text(
                        widget.items[index],
                        style: TextStyles.label1(),
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
            ],
          ),
          isScrollControlled: true,
          isDismissible: false,
          isContentPlain: false,
          enableDrag: false,
          onDismiss: () {
            setState(() {
              isShowDropdown = false;
            });
          },
        );
      },
    );
  }
}

import 'package:farm/resources/dimens/dimens.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    this.hint = 'Cari disini',
    this.enabled = true,
    required this.controller,
    this.onEndActionClicked,
    this.onSearch,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hint;
  final VoidCallback? onEndActionClicked;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  String getText() => _controller.text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      controller: widget.controller,
      enabled: widget.enabled,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        prefixIcon: Align(
          widthFactor: Dimens.d1,
          heightFactor: Dimens.d1,
          child: Icon(Icons.search, color: AppColors.current.neutral700),
        ),
        suffixIcon: widget.enabled
            ? _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.current.neutral700,
                      ),
                      onPressed: () {
                        setState(() {
                          if (widget.onEndActionClicked != null) {
                            widget.onEndActionClicked!();
                          }
                          _controller.clear();
                        });
                      },
                    )
                  : null
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: Dimens.d12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.d10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.d10),
          borderSide: BorderSide(
            color: AppColors.current.royalNavy500,
            width: Dimens.d1,
          ),
        ),
      ),
      onSubmitted: (value) => {
        if (widget.onSearch != null) {widget.onSearch!(value)},
      },
      onChanged: widget.onChanged,
    );
  }
}

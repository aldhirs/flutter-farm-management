import 'package:flutter/material.dart';

class DropdownFullField extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const DropdownFullField({
    Key? key,
    required this.label,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownFullField> createState() => _DropdownFullFieldState();
}

class _DropdownFullFieldState extends State<DropdownFullField> {
  String? _selectedValue;

  void _openBottomSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // biar full screen
      backgroundColor: Colors.white,
      builder: (context) {
        String? tempSelected = _selectedValue;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Divider(height: 1),

                  // List pilihan
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.options.length,
                      itemBuilder: (context, index) {
                        final option = widget.options[index];
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: tempSelected,
                          onChanged: (value) {
                            setModalState(() {
                              tempSelected = value;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  // Sticky button
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    color: Colors.white,
                    child: ElevatedButton(
                      onPressed: tempSelected == null
                          ? null
                          : () {
                              Navigator.pop(context, tempSelected);
                            },
                      child: const Text("Pilih"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedValue = result;
      });
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openBottomSheet,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          _selectedValue ?? "Pilih ${widget.label}",
          style: TextStyle(
            color: _selectedValue == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}

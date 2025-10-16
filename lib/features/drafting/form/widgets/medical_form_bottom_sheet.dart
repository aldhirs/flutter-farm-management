import 'dart:io';

import 'package:farm/constants/enum_constants.dart';
import 'package:farm/extensions/bool.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalFormBottomSheet extends StatefulWidget {
  const MedicalFormBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
    required this.scrollController,
  });

  final DraftingFormBloc bloc;
  final VoidCallback onDismiss;
  final ScrollController scrollController;

  @override
  State<MedicalFormBottomSheet> createState() => _MedicalFormBottomSheetState();
}

class _MedicalFormBottomSheetState extends State<MedicalFormBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    widget.bloc.add(const MedicalInit());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<DraftingFormBloc, DraftingFormState>(
        listenWhen: (previous, current) =>
            previous.isMedicalSuccess != current.isMedicalSuccess,
        listener: (context, state) {
          if (state.isMedicalSuccess) {
            ToastHelper().showToast(
              context: context,
              message: 'Medis sapi berhasil di perbarui',
              type: ToastType.succes,
            );
            widget.bloc.navigator.pop();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Container(
                  padding: const EdgeInsets.all(Dimens.d16),
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text("Input Medis Sapi", style: TextStyles.heading5()),
                      const SizedBox(height: 8),
                      _errorWidget(),
                      const SizedBox(height: 4),
                      const TickerView(
                        type: TickerViewType.info,
                        message:
                            'Isi data medis sapi pada formulir di bawah, lalu tekan “Lanjut” untuk menyimpan. Menekan “Tutup” akan membatalkan penyimpanan.',
                      ),
                      const SizedBox(height: 16),
                      _dropdownType(),
                      _dropdownStatus(),
                      _textInputNote(),
                      _textInputInfection(),

                      // _fileUploader(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -4), // arah ke atas
                    blurRadius: 8, // lembutnya bayangan
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  BlocProvider.value(
                    value: widget.bloc,
                    child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
                      buildWhen: (p, c) => p.loading != c.loading,
                      builder: (context, state) {
                        return Button(
                          fulLWidth: true,
                          type: state.loading
                              ? ButtonType.disabled
                              : ButtonType.primary,
                          loading: state.loading,
                          text: 'Lanjut',
                          onPressed: () {
                            widget.bloc.add(const OnSubmitMedical());
                          },
                        );
                      },
                    ),
                  ),
                  Button(
                    fulLWidth: true,
                    type: ButtonType.ghost,
                    text: 'Tutup',
                    onPressed: widget.onDismiss,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInputInfection() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CheckboxButton(
                    value: state.isInfection,
                    onChanged: (value) {
                      widget.bloc.add(
                        InfectionChanged(value: value.defaultFalse()),
                      );
                    },
                  ),
                  InkWell(
                    child: Text("Infeksius", style: TextStyles.body1()),
                    onTap: () => widget.bloc.add(
                      InfectionChanged(value: !state.isInfection),
                    ),
                  ),
                ],
              ),
              Text(
                "Ceklis infeksius ini jika sapi terdeteksi infeksi.",
                style: TextStyles.label2(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _textInputNote() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        builder: (context, state) {
          return TextInputField(
            controller: _controller,
            label: 'Keterangan',
            hintText: 'Keterangan',
            maxLines: 4,
            onChanged: (value) {
              widget.bloc.add(MedicalNoteChanged(value: value));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownType() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.medicalTypes != c.medicalTypes,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Jenis Medis',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              state.medicalTypes
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item.id.toString(),
                      text: item.name,
                      selected: item.id == state.selectedMedicalType?.id,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = state.medicalTypes
                  .where((item) => item.id.toString() == value.first)
                  .first;
              widget.bloc.add(MedicalTypeChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _dropdownStatus() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.medicalTypes != c.medicalTypes,
        builder: (context, state) {
          return DropdownViewField(
            title: 'Status Medis',
            items: ValueNotifier<List<DropdownCheckboxModel>>(
              medicalStatusMap.values
                  .map(
                    (item) => DropdownCheckboxModel(
                      id: item,
                      text: item,
                      selected: item == state.medicalStatus,
                    ),
                  )
                  .toList(),
            ),
            navigator: widget.bloc.navigator,
            dropdownType: DropdownTypeEnum.single,
            onSelectedItems: (List<String> value) {
              final selected = medicalStatusMap.values
                  .where((item) => item == value.first)
                  .first;
              widget.bloc.add(MedicalStatusChanged(value: selected));
            },
          );
        },
      ),
    );
  }

  Widget _fileUploader() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.medicalFile != c.medicalFile,
        builder: (context, state) {
          final path = state.medicalFile ?? '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text("Lampiran File Medis", style: TextStyles.body2()),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.current.neutral300),
                    color: AppColors.current.neutral500,
                  ),
                  child: path?.isNotEmpty == true
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  path.endsWith(".jpg") ||
                                      path.endsWith(".jpeg") ||
                                      path.endsWith(".png")
                                  ? Image.file(
                                      File(path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.insert_drive_file,
                                            color:
                                                AppColors.current.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              path.split('/').last,
                                              style: TextStyles.body2(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                color: AppColors.current.neutral700,
                                onPressed: () {
                                  widget.bloc.add(const MedicalFileRemoved());
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: AppColors.current.primaryColor,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Unggah File Medis",
                                style: TextStyles.body2(),
                              ),
                              Text(
                                "(klik untuk memilih file)",
                                style: TextStyles.label2(),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text("Upload foto medis (opsional).", style: TextStyles.label2()),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      widget.bloc.add(MedicalFileAdded(filePath: result.files.single.path!));
    } else {
      ToastHelper().showToast(
        context: context,
        message: 'Tidak ada file dipilih.',
        type: ToastType.warning,
      );
    }
  }

  Widget _errorWidget() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.medicalErrorMessage != c.medicalErrorMessage,
        builder: (context, state) {
          return Visibility(
            visible: state.medicalErrorMessage.isNotEmpty,
            child: TickerView(
              type: TickerViewType.danger,
              message: state.medicalErrorMessage,
            ),
          );
        },
      ),
    );
  }
}

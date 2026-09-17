import 'dart:io';

import 'package:farm/constants/enum_constants.dart';
import 'package:farm/extensions/bool.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/draft_form_layout.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/checkbox/checkbox_button.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_field.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalFormBottomSheet extends StatefulWidget {
  const MedicalFormBottomSheet({
    super.key,
    required this.bloc,
    required this.onDismiss,
    this.scrollController,
  });

  final DraftingFormBloc bloc;
  final VoidCallback onDismiss;
  final ScrollController? scrollController;

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

        /// Lembar ini punya tinggi, dan tombolnya menempel di bawah tinggi itu.
        ///
        /// Isinya paling panjang di antara empat lembar drafting, jadi badannya
        /// digulung sementara tombol "Lanjut" tetap terlihat. Susunan itu hanya
        /// mungkin bila tingginya diketahui: `Flexible` di dalam kolom yang
        /// tingginya tak terbatas tidak punya sisa ruang untuk dibagi, dan
        /// Flutter menolak melukisnya. Dibatasi 85% layar — cukup untuk terbaca
        /// sebagai lembar yang menumpang, bukan halaman penuh.
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Dimens.d20,
                      Dimens.d4,
                      Dimens.d20,
                      Dimens.d24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _header(),
                        const SizedBox(height: Dimens.d4),
                        DraftFieldColumn(
                          children: [
                            _dropdownType(),
                            _dropdownStatus(),
                            _textInputNote(),
                            _textInputInfection(),
                          ],
                        ),
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
                padding: const EdgeInsets.only(
                  left: Dimens.d20,
                  right: Dimens.d20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: Dimens.d16),
                    DraftSheetActions(
                      submit: _submitButton(),
                      onDismiss: widget.onDismiss,
                    ),
                    const SizedBox(height: Dimens.d16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.loading != c.loading,
        builder: (context, state) {
          return Button(
            fulLWidth: true,
            type: state.loading ? ButtonType.disabled : ButtonType.primary,
            loading: state.loading,
            text: 'Lanjut',
            onPressed: () {
              widget.bloc.add(const OnSubmitMedical());
            },
          );
        },
      ),
    );
  }

  Widget _header() {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) => p.medicalErrorMessage != c.medicalErrorMessage,
        builder: (context, state) {
          return DraftSheetHeader(
            title: 'Medis Sapi',
            subtitle: 'Catat hasil pemeriksaan dan status kesehatannya.',
            errorMessage: state.medicalErrorMessage,
            hint:
                'Isi seluruh bidang lalu tekan "Lanjut" untuk menyimpan. '
                'Menekan "Tutup" membatalkan isian.',
          );
        },
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
}

import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/widgets/cattle_identity_sheet.dart';
import 'package:farm/features/drafting/form/widgets/draft_form_layout.dart';
import 'package:farm/features/drafting/form/widgets/identity_form_widget.dart';
import 'package:farm/features/drafting/form/widgets/growth_form_widget.dart';
import 'package:farm/features/drafting/form/widgets/medical_form_widget.dart';
import 'package:farm/features/drafting/form/widgets/treatment_form_widget.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DraftingFormPage extends StatefulWidget {
  const DraftingFormPage({super.key, this.rfid, this.cattle});

  final String? rfid;
  final Cattle? cattle;

  @override
  State<DraftingFormPage> createState() => _DraftingFormPageState();
}

class _DraftingFormPageState
    extends BasePageState<DraftingFormPage, DraftingFormBloc> {
  @override
  void initState() {
    bloc.add(Initiated(rfid: widget.rfid, cattle: widget.cattle));
    super.initState();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DraftingFormBloc, DraftingFormState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.errorMessage,
                type: ToastType.error,
              );
            }
          },
        ),
        BlocListener<DraftingFormBloc, DraftingFormState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) {
            if (state.cattle.id.isNotEmpty &&
                !state.isIdentitySuccess &&
                (!state.cattle.isAvailableToDrafting())) {
              navigator.showAppDialog(
                useRootNavigator: true,
                barrierDismissible: false,
                Popup(
                  title: 'Sapi Sudah di Drafting',
                  illustration: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // adjust radius
                    child: Assets.images.ilCowDenied.image(
                      height: Dimens.d240,
                      fit: BoxFit.cover,
                    ),
                  ),
                  description: [
                    const TextSpan(
                      text:
                          'Data sapi ini sudah melalui proses drafting sebelumnya.',
                    ),
                  ],
                  positiveButtonText: "Kembali",
                  onPositiveButtonPressed: () async {
                    await navigator.pop();
                    await navigator.pop();
                  },
                ),
              );
              return;
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(
        titleText: 'Input Drafting Sapi',
        forceMaterialTransparency: false,
      ),
      body: ResponsiveWidget(
        mobile: _contentView(ViewUtils.screenWidth(), false),
        tabletPotrait: _contentView(ViewUtils.screenWidth() * 0.4, true),
        tabletLandscape: _contentView(ViewUtils.screenWidth() * 0.3, true),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _finishButton(),
    );
  }

  Widget _contentView(double width, bool isTablet) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) =>
            p.cattle != c.cattle ||
            p.loading != c.loading ||
            p.listItems != c.listItems,
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty == true) {
            return _errorWidget();
          }
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              /// Ruang bawah disisakan untuk tombol "Selesai" yang mengambang.
              ///
              /// Tanpanya, kartu langkah terakhir berhenti tepat di bawah
              /// tombol dan tidak pernah bisa digeser keluar dari bawahnya.
              padding: const EdgeInsets.fromLTRB(
                Dimens.d16,
                Dimens.d16,
                Dimens.d16,
                Dimens.d96,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _animalIdentityWidget(state),
                  const SizedBox(height: Dimens.d20),
                  _progressWidget(),
                  const SizedBox(height: Dimens.d12),
                  const TickerView(
                    type: TickerViewType.warning,
                    message:
                        "Data hanya akan tersimpan bila formulir dilanjutkan. Menutup formulir akan membatalkan data yang telah diisi.",
                  ),
                  const SizedBox(height: Dimens.d16),
                  DraftFieldColumn(
                    gap: Dimens.d12,
                    children: [
                      IdentityFormWidget(bloc: bloc, navigator: navigator),
                      GrowthFormWidget(bloc: bloc, navigator: navigator),
                      TreatmentFormWidget(bloc: bloc, navigator: navigator),
                      MedicalFormWidget(bloc: bloc, navigator: navigator),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _errorWidget() {
    final isNotFound = bloc.state.errorMessage.contains('record not found');
    return EmptyState(
      title: isNotFound ? 'Data tidak ditemukan' : 'Terjadi Kesalahan',
      description: isNotFound
          ? 'Data sapi tidak dapat ditemukan. Silakan buat data baru.'
          : bloc.state.errorMessage,
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Assets.images.ilCowDenied.image(
          height: Dimens.d240,
          fit: BoxFit.cover,
        ),
      ),
      isEnabledPositifButton: isNotFound,
      buttonText: isNotFound ? 'Buat Data Sapi Baru' : 'Mengerti',
      isButtonFullWidth: true,
      leftIconButton: const Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        if (isNotFound) {
          final result = await navigator.push(
            AppRouteInfo.cattleCreate(rfid: widget.rfid),
          );
          if (result != null) {
            bloc.add(GetCattle(cattle: result as Cattle));
          }
        } else {
          navigator.pop();
        }
      },
    );
  }

  /// Kemajuan pengisian: berapa dari empat langkah yang sudah beres.
  ///
  /// Keempat kartu di bawahnya sudah menandai keadaannya masing-masing, tapi
  /// satu per satu. Baris ini menjawab pertanyaan yang berbeda dan lebih sering
  /// ditanyakan di lapangan — apakah sapi ini masih menyisakan pekerjaan —
  /// tanpa perlu menghitung sendiri empat ikon centang.
  Widget _progressWidget() {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<DraftingFormBloc, DraftingFormState>(
        buildWhen: (p, c) =>
            p.isIdentitySuccess != c.isIdentitySuccess ||
            p.isGrowthSuccess != c.isGrowthSuccess ||
            p.isTreatmentSuccess != c.isTreatmentSuccess ||
            p.isMedicalSuccess != c.isMedicalSuccess,
        builder: (context, state) {
          final done = [
            state.isIdentitySuccess,
            state.isGrowthSuccess,
            state.isTreatmentSuccess,
            state.isMedicalSuccess,
          ].where((value) => value).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Perbarui Data',
                      style: TextStyles.body2().copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.current.mint800,
                      ),
                    ),
                  ),
                  Text(
                    '$done dari 4 langkah',
                    style: TextStyles.label3().copyWith(
                      color: AppColors.current.neutral600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.d8),
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.d8),
                child: LinearProgressIndicator(
                  value: done / 4,
                  minHeight: Dimens.d6,
                  backgroundColor: AppColors.current.mint200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.current.mint700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Kartu sapi di kepala halaman; keterangan lengkapnya ada di lembar bawah.
  Widget _animalIdentityWidget(DraftingFormState state) {
    final colors = AppColors.current;
    final earTag = state.cattle.ear_tag;
    final rfid = state.cattle.rfid_tag;

    /// Yang dibesarkan adalah nomor yang sapinya memang punya.
    ///
    /// Sapi yang sedang didrafting justru sering belum ber-ear tag — memberinya
    /// ear tag adalah salah satu langkah di halaman ini — sehingga menjadikan
    /// ear tag sebagai judul membuat kartunya berkepala tanda hubung. RFID
    /// selalu ada, karena itulah yang dipindai untuk sampai ke sini.
    final hasEarTag = earTag.isNotEmpty;
    final title = hasEarTag ? earTag : rfid.defaultValue('-');
    final titleLabel = hasEarTag ? 'Ear Tag' : 'RFID';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Dimens.d20),
      child: InkWell(
        onTap: () => _onShowIdentity(state),
        borderRadius: BorderRadius.circular(Dimens.d20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.d20),
            border: Border.all(color: colors.neutral300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.d16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: Dimens.d44,
                      height: Dimens.d44,
                      decoration: BoxDecoration(
                        color: colors.mint200,
                        borderRadius: BorderRadius.circular(Dimens.d14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.pets,
                        size: Dimens.d20,
                        color: colors.mint700,
                      ),
                    ),
                    const SizedBox(width: Dimens.d14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleLabel,
                            style: TextStyles.label3().copyWith(
                              color: colors.neutral600,
                            ),
                          ),
                          const SizedBox(height: Dimens.d2),
                          Text(
                            title,
                            style: TextStyles.heading6().copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.mint800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (state.cattle.statusLabel().isNotEmpty)
                      TagCategory(
                        text: state.cattle.statusLabel(),
                        type: TagCategoryType.mint,
                      ),
                  ],
                ),
                const SizedBox(height: Dimens.d12),
                Divider(height: 1, thickness: 1, color: colors.neutral300),
                const SizedBox(height: Dimens.d12),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            hasEarTag
                                ? Icons.qr_code_2_outlined
                                : Icons.sell_outlined,
                            size: Dimens.d14,
                            color: colors.neutral600,
                          ),
                          const SizedBox(width: Dimens.d6),
                          Expanded(
                            child: Text(
                              hasEarTag
                                  ? rfid.defaultValue('-')
                                  : 'Ear tag belum ditentukan',
                              style: TextStyles.label2().copyWith(
                                color: colors.neutral600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Dimens.d8),
                    Text(
                      'Lihat detail',
                      style: TextStyles.label2().copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.mint700,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: Dimens.d18,
                      color: colors.mint700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onShowIdentity(DraftingFormState state) {
    navigator.showBottomSheet(
      CattleIdentitySheet(
        earTag: state.cattle.ear_tag,
        rfid: state.cattle.rfid_tag,
        status: state.cattle.statusLabel(),
        items: state.listItems,
      ),
      isScrollControlled: true,
    );
  }

  Widget _finishButton() {
    final isNotFound = bloc.state.errorMessage.contains('record not found');
    return FloatingActionButton.extended(
      backgroundColor: AppColors.current.mint700,
      onPressed: () {
        final state = bloc.state;
        if (state.isIdentitySuccess ||
            state.isGrowthSuccess ||
            state.isMedicalSuccess ||
            state.isTreatmentSuccess) {
          ToastHelper().showToast(
            context: context,
            message: 'Data drafting sapi berhasil disimpan.',
            type: ToastType.succes,
          );
        }
        navigator.pop();
      },
      label: Text(
        !isNotFound ? 'Selesai' : 'Kembali',
        style: TextStyles.button2().copyWith(color: Colors.white),
      ),
      icon: Icon(
        !isNotFound ? Icons.done : Icons.chevron_left,
        color: Colors.white,
      ),
    );
  }
}

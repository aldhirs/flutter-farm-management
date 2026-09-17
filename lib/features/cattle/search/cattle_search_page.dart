import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/medical/medical.dart';
import 'package:farm/domain/entities/treatment/treatment.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_bloc.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_event.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_state.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/views/common_scaffold.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button_text.dart';
import 'package:farm/widgets/toast/toast.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class CattleSearchPage extends StatefulWidget {
  const CattleSearchPage({super.key, this.rfid, this.cattle, this.connection});

  final String? rfid;
  final Cattle? cattle;
  final BluetoothConnection? connection;

  @override
  State<StatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends BasePageState<CattleSearchPage, CattleSearchBloc>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.add(Initiated(cattle: widget.cattle, rfid: widget.rfid));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CattleSearchBloc, CattleSearchState>(
          listenWhen: (previous, current) =>
              previous.successMessage != current.successMessage,
          listener: (context, state) async {
            if (state.successMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.successMessage,
                type: ToastType.succes,
              );
            }
          },
        ),
        BlocListener<CattleSearchBloc, CattleSearchState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
          listener: (context, state) async {
            if (state.errorMessage.isNotEmpty) {
              ToastHelper().showToast(
                context: context,
                message: state.errorMessage,
                type: ToastType.error,
              );
            }
          },
        ),
        BlocListener<CattleSearchBloc, CattleSearchState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null) {
              ToastHelper().showToast(
                context: context,
                message:
                    "Data sapi ${state.cattle?.ear_tag.defaultValue('-')} telah ditemukan.",
                type: ToastType.succes,
              );
            }
          },
        ),
      ],
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<CattleSearchBloc, CattleSearchState>(
      builder: (context, state) {
        final cattle = state.cattle ?? const Cattle();
        return CommonScaffold(
          backgroundColor: state.cattle == null
              ? Colors.white
              : AppColors.current.neutral400,
          body: state.cattle == null
              ? _emptyWidget()
              : CustomScrollView(
                  slivers: [
                    /// HEADER dengan gradient
                    SliverAppBar(
                      expandedHeight: 210,
                      pinned: true,
                      elevation: 0,

                      /// Bilah dan latarnya sewarna.
                      ///
                      /// Sebelumnya bilahnya putih dengan ikon hitam sementara
                      /// latarnya ungu, jadi selama menyusut ikon segar-ulang
                      /// berjalan sebagai bentuk gelap di atas ungu tua —
                      /// nyaris tidak terlihat justru di tengah gerakan.
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.current.mint800,
                      actions: [
                        IconButton(
                          icon: const Icon(LucideIcons.refreshCw, size: 18),
                          onPressed: () => bloc.add(const OnRefresh()),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        /// Identitas ternak, rata kiri.
                        ///
                        /// Ear tag adalah nomor yang dibaca orang dari badan
                        /// sapinya, jadi ia yang dibesarkan. Lingkaran putih
                        /// 84px berisi ikon sapi sebelumnya menempati bagian
                        /// terbesar kepala halaman tanpa mengabarkan apa pun —
                        /// yang membuka layar ini sudah tahu sedang melihat
                        /// seekor sapi.
                        background: Container(
                          color: AppColors.current.mint800,
                          child: SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.14,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            Dimens.d12,
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: Dimens.d20,
                                          height: Dimens.d20,
                                          child: Assets.icons.icCow.image(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: Dimens.d10),
                                      TagCategory(
                                        text: cattle.statusLabel(),
                                        type: TagCategoryType.plain,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimens.d14),
                                  Text(
                                    (cattle.ear_tag).defaultValue('-'),
                                    style: TextStyles.heading2().copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      height: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: Dimens.d4),
                                  Text(
                                    "RFID ${cattle.rfid_tag.defaultValue('-')}",
                                    style: TextStyles.label2().copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.72,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// BODY CONTENT
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: Dimens.d16,
                          bottom: Dimens.d24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// INFO CARD HORIZONTAL
                            /// Selokan kiri-kanan diatur oleh padding daftar,
                            /// bukan oleh SizedBox penyangga.
                            ///
                            /// Penyangganya dulu 16 di kiri tetapi 8 di kanan,
                            /// sehingga kartu terakhir berhenti lebih dekat ke
                            /// tepi layar daripada kartu pertama memulainya.
                            SizedBox(
                              height: 84,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d16,
                                ),
                                children: [
                                  _buildInfoChip(
                                    "Status",
                                    cattle.statusLabel(),
                                    cattle.statusColor(),
                                  ),
                                  _buildInfoChip(
                                    "Bobot",
                                    "${cattle.actual_weight} Kg",
                                    Colors.blue,
                                  ),
                                  _buildInfoChip(
                                    "Shipment",
                                    (cattle.reception?.title).defaultValue('-'),
                                    Colors.indigo,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Dimens.d16),

                            /// Dua belas baris dipecah menjadi tiga kelompok.
                            ///
                            /// Sebelumnya semuanya satu daftar seragam: ear
                            /// tag bersebelahan dengan POO, dan kandang dengan
                            /// breed. Orang yang membuka layar ini datang
                            /// dengan satu pertanyaan — di mana sapinya, atau
                            /// dari mana asalnya — dan daftar tanpa kelompok
                            /// memaksanya membaca dua belas baris untuk
                            /// menemukan satu.
                            _detailGroup("Lokasi", [
                              _buildDetailRow(
                                "Feedlot",
                                (appBloc.state.selectedProject?.name).orEmpty(),
                              ),
                              _buildDetailRow(
                                "Kandang",
                                (cattle.pen?.name_barn).orEmpty(),
                              ),
                              _buildDetailRow(
                                "Pen",
                                (cattle.pen?.name).orEmpty(),
                              ),
                            ]),
                            _detailGroup("Identitas", [
                              _buildDetailRow("Ear Tag", cattle.ear_tag),
                              _buildDetailRow("RFID", cattle.rfid_tag),
                              _buildDetailRow("Status", cattle.statusLabel()),
                              _buildDetailRow(
                                "Bobot Akhir",
                                "${cattle.actual_weight} kg",
                              ),
                            ]),
                            _detailGroup("Asal", [
                              _buildDetailRow(
                                "Shipment",
                                (cattle.reception?.title).defaultValue('-'),
                              ),
                              _buildDetailRow("Breed", cattle.id_breed),
                              _buildDetailRow("POO", cattle.id_station),
                              _buildDetailRow("IMP", cattle.id_supplier),
                              _buildDetailRow(
                                "Tanggal dibuat",
                                cattle.created_at.formatDateString(
                                  format: DateConstant.UTC,
                                  newFormat: DateConstant.DATETIME_FULL_MONTH,
                                ),
                              ),
                            ]),

                            const SizedBox(height: 16),

                            /// RIWAYAT PERAWATAN
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildSectionTitle(
                                "Riwayat Perawatan",
                                state.treatments.isNotEmpty,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildTreatmentList(state.treatments),
                            ),

                            const SizedBox(height: 16),

                            /// CATATAN MEDIS
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildSectionTitle("Catatan Medis", false),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildMedicalList(state.medicals),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  /// Satu kelompok keterangan, dengan judulnya sendiri.
  Widget _detailGroup(String title, List<Widget> rows) {
    return Container(
      margin: const EdgeInsets.fromLTRB(Dimens.d16, 0, Dimens.d16, Dimens.d12),
      padding: const EdgeInsets.symmetric(vertical: Dimens.d8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d20),
        border: Border.all(color: AppColors.current.neutral300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              title,
              style: TextStyles.label2().copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.current.mint700,
              ),
            ),
          ),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyles.label2().copyWith(
                color: AppColors.current.neutral600,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.defaultValue('-'),
              textAlign: TextAlign.end,
              style: TextStyles.label2().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.current.mint800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CHIP CARD HORIZONTAL
  /// Kartu ringkas di baris atas.
  ///
  /// Nilainya memakai satu warna, bukan satu warna per kartu. Biru untuk bobot
  /// dan indigo untuk shipment tidak pernah berarti apa-apa; warna yang
  /// berbeda-beda tanpa aturan mengajari orang bahwa warna di layar ini boleh
  /// diabaikan — lalu warna status, yang benar-benar berarti, ikut diabaikan.
  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: Dimens.d12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d16),
        border: Border.all(color: AppColors.current.neutral300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyles.label3().copyWith(
              color: AppColors.current.neutral600,
            ),
          ),
          const SizedBox(height: Dimens.d4),
          Text(
            value,
            style: TextStyles.body2().copyWith(
              color: AppColors.current.mint800,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget _buildSectionTitle(String title, bool showSeeAllButton) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.body2().copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.current.mint800,
            ),
          ),
          showSeeAllButton
              ? ButtonText(
                  text: "Lihat Semua",
                  onPressed: () {
                    navigator.push(
                      AppRouteInfo.cattleTreatments(cattle: bloc.state.cattle!),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildTreatmentList(List<Treatment> items) {
    if (items.isEmpty) {
      return const Center(child: Text("Data tidak tersedia"));
    }
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  LucideIcons.heartHandshake,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (item.treatment_type?.name).defaultValue('-'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.notes,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.created_at.formatDateString(
                        format: DateConstant.UTC,
                        newFormat: DateConstant.DATETIME_FULL_MONTH,
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicalList(List<Medical> items) {
    if (items.isEmpty) {
      return const Center(child: Text("Data tidak tersedia"));
    }

    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.is_infection
                        ? [Colors.red.shade400, Colors.red.shade700]
                        : [Colors.green.shade400, Colors.green.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  LucideIcons.shieldPlus,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (item.medical_type?.name).defaultValue('-'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.is_infection ? 'Infeksius' : 'Non Infeksius',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.notes,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.created_at.formatDateString(
                        format: DateConstant.UTC,
                        newFormat: DateConstant.DATETIME_FULL_MONTH,
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _emptyWidget() {
    if (bloc.state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return EmptyState(
      title: 'Ups!',
      description: 'Data Sapi Tidak Ditemukan.',
      imageAssets: ClipRRect(
        borderRadius: BorderRadius.circular(20), // adjust radius
        child: Assets.images.ilNotFound.image(
          height: Dimens.d240,
          fit: BoxFit.contain,
        ),
      ),
      buttonText: "Kembali",
      isButtonFullWidth: true,
      leftIconButton: const Icon(LucideIcons.arrowLeft, color: Colors.white),
      onPressed: () => navigator.pop(),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/medical/medical.dart';
import 'package:farm/domain/entities/treatment/treatment.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_bloc.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_event.dart';
import 'package:farm/features/cattle/search/bloc/cattle_search_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/views/common_scaffold.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/toast/toast.dart';
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
                      expandedHeight: 200,
                      pinned: true,
                      elevation: 0,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF25AFCB),
                                AppColors.current.mint500,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsetsGeometry.all(16),
                                  child: Assets.icons.icCow.image(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                (cattle.ear_tag).defaultValue('-'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "RFID: ${cattle.rfid_tag.defaultValue('-')}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// BODY CONTENT
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// INFO CARD HORIZONTAL
                            SizedBox(
                              height: 80,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  const SizedBox(width: 16),
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
                                    "Kelamin",
                                    cattle.genderLabel(),
                                    Colors.indigo,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                            // ====== Detail Sapi (Vertical Card) ======
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                    "Feedlot",
                                    (appBloc.state.selectedProject?.name)
                                        .orEmpty(),
                                  ),
                                  _buildDetailRow("Ear Tag", cattle.ear_tag),
                                  _buildDetailRow("RFID", cattle.rfid_tag),
                                  _buildDetailRow(
                                    "Status",
                                    cattle.statusLabel(),
                                  ),
                                  _buildDetailRow(
                                    "Bobot Akhir",
                                    "${cattle.actual_weight} kg",
                                  ),
                                  _buildDetailRow(
                                    "Tanggal dibuat",
                                    cattle.created_at.formatDateString(
                                      format: DateConstant.UTC,
                                      newFormat:
                                          DateConstant.DATETIME_FULL_MONTH,
                                    ),
                                  ),
                                  _buildDetailRow(
                                    "Kandang",
                                    (cattle.pen?.name_barn).orEmpty(),
                                  ),
                                  _buildDetailRow(
                                    "Pen",
                                    (cattle.pen?.name).orEmpty(),
                                  ),
                                  _buildDetailRow(
                                    "Jenis Kelamin",
                                    cattle.genderLabel(),
                                  ),
                                  _buildDetailRow(
                                    "Grade",
                                    (cattle.level?.name).orEmpty(),
                                  ),
                                  _buildDetailRow(
                                    "Reception",
                                    (cattle.reception?.bl_number).orEmpty(),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// RIWAYAT PERAWATAN
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildSectionTitle("Riwayat Perawatan"),
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
                              child: _buildSectionTitle("Catatan Medis"),
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
              style: TextStyles.body2().copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.defaultValue('-'),
              textAlign: TextAlign.end,
              style: TextStyles.body2(),
            ),
          ),
        ],
      ),
    );
  }

  /// CHIP CARD HORIZONTAL
  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12, bottom: 4, top: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
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

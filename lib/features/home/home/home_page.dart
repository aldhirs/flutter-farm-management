import 'package:auto_route/auto_route.dart';
import 'dart:async';

import 'package:farm/app/bloc/app_bloc.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/app/bloc/app_state.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/features/home/home/bloc/home_bloc.dart';
import 'package:farm/features/home/home/bloc/home_event.dart';
import 'package:farm/features/home/home/bloc/home_state.dart';
import 'package:farm/features/home/home/widgets/cattle_search_bottom_sheet.dart';
import 'package:farm/features/home/home/widgets/quick_action_card.dart';
import 'package:farm/features/scan/scan_page.dart';
import 'package:farm/navigation/app_route_info.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/enum/dropdown_type_enum.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/dropdownview/dropdown_model.dart';
import 'package:farm/widgets/dropdownview/dropdown_view_bottomsheet.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage, HomeBloc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeStats;
  late final Animation<Offset> _slideStats;
  String? selectedValue = "Option 1";

  @override
  void initState() {
    super.initState();
    _initAnimation();
    appBloc.add(const GetProjects(showProject: false));
    // Feedlot bisa sudah tersimpan dari sesi sebelumnya, jadi angka Discover
    // dimuat di sini juga — bukan hanya saat pengguna berganti feedlot.
    bloc.add(const Initiated());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPageListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.showProjects != current.showProjects,
          listener: (context, state) async {
            if (!state.showProjects) {
              return;
            }
            _showFeedlot(state);
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) => previous.cattle != current.cattle,
          listener: (context, state) async {
            if (state.cattle != null && state.cattleDestination == 1) {
              navigator.popAndPush(
                AppRouteInfo.cattleSearch(cattle: state.cattle),
              );
            } else if (state.cattle != null && state.cattleDestination == 2) {
              navigator.popAndPush(
                AppRouteInfo.draftingForm(cattle: state.cattle),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (BuildContext context) => appBloc),
      ],
      child: CommonScaffold(
        backgroundColor: AppColors.current.neutral400,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.current.mint700,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// Satu gerakan masuk, bukan lima.
                ///
                /// Sebelumnya tiap bagian punya fade-and-slide sendiri, yang
                /// membuat beranda bergoyang berurutan setiap kali dibuka —
                /// mahal dilihat, dan menunda papan angka yang justru jadi
                /// alasan orang membuka layar ini.
                _fadeSlide(
                  fade: _fadeStats,
                  slide: _slideStats,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _greeting(),
                      const SizedBox(height: 14),
                      _feedlotPlate(),
                      const SizedBox(height: 28),
                      _sectionTitle('Menunggu dikerjakan'),
                      _discoverLastUpdated(),
                      const SizedBox(height: 12),
                      _tallyBoard(),
                      const SizedBox(height: 28),
                      _sectionTitle('Kerjakan'),
                      const SizedBox(height: 12),
                      _menuGrid(),
                    ],
                  ),
                ),
                const SizedBox(height: 62),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Menyegarkan apa yang benar-benar terlihat di beranda.
  ///
  /// Dua permintaan, bukan satu: daftar feedlot (dipakai kartu di atas dan
  /// pemilih feedlot) dan angka Discover. Yang ditunggu hanya angkanya, karena
  /// itulah yang berubah di depan mata pengguna — menunggu keduanya hanya
  /// membuat indikator berputar lebih lama tanpa menampilkan apa pun yang baru.
  Future<void> _onRefresh() async {
    appBloc.add(const GetProjects(showProject: false));

    final completer = Completer<void>();
    bloc.add(Refreshed(completer: completer));
    await completer.future;
  }

  void _onShowFeedlotAlert() {
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        title: 'Feedlot belum diisi',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20), // adjust radius
          child: Assets.images.ilCowFeedlot.image(
            height: Dimens.d140,
            fit: BoxFit.cover,
          ),
        ),
        description: [
          const TextSpan(
            text:
                "Silakan untuk memilih feedlot terlebih dahulu untuk melanjutkan aktivitas.",
          ),
        ],
        positiveButtonText: "Pilih Feedlot",
        onPositiveButtonPressed: () async {
          navigator.pop();
          appBloc.add(const ShowProjects());
        },
      ),
    );
  }

  void _onMenuClicked(AppRouteInfo route) async {
    if (appBloc.state.selectedProject == null) {
      _onShowFeedlotAlert();
    } else {
      await navigator.push(route);
      // await navigator.pushRoute(DashboardRoute());
    }
  }

  void _showFeedlot(AppState state) {
    navigator.showBottomSheet(
      DropdownViewBottomsheet(
        title: 'Pilih Feedlot',
        searchHint: '',
        items: ValueNotifier<List<DropdownCheckboxModel>>(
          state.projects
              .map(
                (item) => DropdownCheckboxModel(
                  text: item.name,
                  selected: item.id == state.selectedProject?.id,
                ),
              )
              .toList(),
        ),
        navigator: navigator,
        onDismiss: () {},
        onChoose: (value) {
          final selected = value.where((item) => item.selected).first;
          final selectedProject = state.projects
              .where((item) => item.name == selected.text)
              .first;
          appBloc.add(SelectedProject(project: selectedProject));
          bloc.add(const Initiated());
        },

        dropdownType: DropdownTypeEnum.single,
        dismissible: true,
      ),
      onDismiss: () {
        appBloc.add(const DismissProjects());
      },
    );
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Satu kurva saja: seluruh isi beranda masuk bersamaan.
    final statsCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.45, curve: Curves.easeOut),
    );
    _fadeStats = Tween(begin: 0.0, end: 1.0).animate(statsCurve);
    _slideStats = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(statsCurve);

    // Kick off the animation on first build
    _controller.forward();
  }

  Widget _fadeSlide({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  Widget _greeting() {
    return Text(
      'Halo, ${(appBloc.state.userData?.full_name).defaultValue('')}',
      style: TextStyles.body2().copyWith(color: AppColors.current.neutral800),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyles.body2().copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.current.mint800,
      ),
    );
  }

  /// Papan nama feedlot.
  ///
  /// Satu-satunya tempat yang boleh ramai di layar ini. Feedlot adalah syarat
  /// bagi semua hal lain — tanpa memilihnya, tidak ada angka dan tidak ada menu
  /// yang bisa dibuka — jadi ia dibuat sebesar itu justru supaya pertanyaan
  /// "saya sedang di kandang mana" terjawab dari jarak sebelum layar dibaca.
  ///
  /// Gradien lama diganti bidang pekat satu warna: gradien biru-ke-ungu tidak
  /// mengabarkan apa pun, dan di bawah matahari perbedaan dua warna terang itu
  /// hilang sama sekali.
  Widget _feedlotPlate() {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (p, c) => p.selectedProject != c.selectedProject,
      builder: (context, state) {
        final project = state.selectedProject;
        final bool chosen = project != null;

        return Material(
          color: chosen
              ? AppColors.current.mint700
              : AppColors.current.mint800.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(Dimens.d20),
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimens.d20),
            onTap: () => appBloc.add(const GetProjects(showProject: true)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feedlot',
                          style: TextStyles.label3().copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chosen ? project.name : 'Belum dipilih',
                          style: TextStyles.heading3().copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          chosen
                              ? 'Ketuk untuk berpindah feedlot'
                              : 'Ketuk untuk memilih feedlot',
                          style: TextStyles.label3().copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.chevronsUpDown,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Papan hitung: empat angka dalam satu bidang, dipisah garis rambut.
  ///
  /// Empat kartu terpisah dengan bayangan masing-masing membuat keempatnya
  /// terbaca sebagai empat benda; padahal ini satu papan tally — empat kolom
  /// dari satu hitungan yang sama, untuk satu feedlot, pada satu waktu.
  Widget _tallyBoard() {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (p, c) => p.selectedProject != c.selectedProject,
      builder: (context, appState) {
        return BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (p, c) =>
              p.discoverSummary != c.discoverSummary ||
              p.discoverLoading != c.discoverLoading,
          builder: (context, state) {
            final summary = state.discoverSummary;
            final bool hasFeedlot = appState.selectedProject != null;
            final bool ready = hasFeedlot && summary != null;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.d20),
                border: Border.all(color: AppColors.current.neutral300),
              ),

              /// IntrinsicHeight memberi baris ini tinggi yang terbatas.
              ///
              /// Garis pemisah antar kolom perlu setinggi kolom tertinggi, dan
              /// itulah yang dilakukan CrossAxisAlignment.stretch — tetapi
              /// stretch hanya bisa bekerja bila tinggi barisnya diketahui.
              /// Di dalam daftar yang bisa digulir tingginya tidak terbatas,
              /// sehingga stretch meminta tinggi tak hingga dan seluruh beranda
              /// gagal ditata. IntrinsicHeight mengukur kolom terlebih dulu,
              /// lalu memberi baris tinggi setara kolom tertinggi.
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _tallyCell(
                      'Draf sapi',
                      ready ? summary.draftCattle : null,

                      /// Satu-satunya kolom yang bisa ditekan.
                      ///
                      /// Tiga kolom lain sudah punya menunya sendiri di bawah;
                      /// sapi yang menunggu didrafting tidak punya, dan angka
                      /// inilah satu-satunya jalan menuju daftarnya.
                      onTap: hasFeedlot
                          ? () => navigator.push(
                              const AppRouteInfo.draftingList(),
                            )
                          : null,
                    ),
                    _tallyDivider(),
                    _tallyCell('Draf jual', ready ? summary.draftSales : null),
                    _tallyDivider(),
                    _tallyCell(
                      'Mutasi masuk',
                      ready ? summary.mutationIn : null,
                    ),
                    _tallyDivider(),
                    _tallyCell(
                      'Mutasi keluar',
                      ready ? summary.mutationOut : null,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _tallyDivider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(vertical: 14),
      color: AppColors.current.neutral300,
    );
  }

  /// Satu kolom papan hitung.
  ///
  /// Nol ditulis redup, bukan sepekat angka lain. Keduanya sama-sama jawaban,
  /// tetapi hanya satu yang berarti ada pekerjaan; menyamakan tebalnya membuat
  /// mata harus membaca keempat kolom untuk tahu mana yang menuntut sesuatu.
  ///
  /// Tanda hubung berarti belum ada jawaban sama sekali — feedlot belum dipilih
  /// atau angkanya gagal dimuat — dan itu keadaan yang berbeda dari nol.
  Widget _tallyCell(String label, int? value, {VoidCallback? onTap}) {
    final bool empty = value == null;
    final bool zero = value == 0;

    final Color numberColor = empty
        ? AppColors.current.neutral600
        : zero
        ? AppColors.current.neutral600
        : AppColors.current.mint700;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimens.d16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                empty ? '-' : '$value',
                style: TextStyles.heading2().copyWith(
                  color: numberColor,
                  fontWeight: zero || empty ? FontWeight.w500 : FontWeight.w700,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyles.label3().copyWith(
                  color: AppColors.current.neutral800,
                  height: 1.25,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menu dua kolom, bukan tiga.
  ///
  /// Sasaran sentuh jadi hampir dua kali lebih lebar. Layar ini dipakai di luar
  /// kandang, satu tangan, sering sambil memegang pemindai — dan tiga kolom
  /// kartu kecil adalah ukuran yang dirancang untuk jari yang santai.
  Widget _menuGrid() {
    final items = <_HomeMenuEntry>[
      _HomeMenuEntry(
        icon: LucideIcons.alignEndVertical,
        label: 'Drafting',

        /// Menuju daftar sapi yang menunggu didrafting, bukan langsung ke
        /// dialog pemilihan metode.
        ///
        /// Memindai tetap tersedia lewat tombol pemindai di bilah bawah, dan
        /// di sanalah tempatnya: memindai adalah cara MEMBUKA satu ekor, bukan
        /// gerbang menuju pekerjaan drafting. Menu ini membawa ke pekerjaannya
        /// — daftar yang menunggu — sehingga petugas bisa melihat berapa
        /// banyak yang tersisa sebelum memutuskan mulai dari mana.
        onTap: () => _onMenuClicked(const AppRouteInfo.draftingList()),
        primary: true,
      ),
      _HomeMenuEntry(
        icon: LucideIcons.search,
        label: 'Cari Sapi',
        onTap: _onSearchCattleClicked,
      ),
      _HomeMenuEntry(
        icon: LucideIcons.layers,
        label: 'Pen Drafting',
        onTap: () => _onMenuClicked(const AppRouteInfo.penDrafting()),
      ),
      _HomeMenuEntry(
        icon: LucideIcons.plus,
        label: 'Tambah Sapi',
        onTap: () => _onMenuClicked(const AppRouteInfo.cattleCreate()),
      ),
      _HomeMenuEntry(
        icon: LucideIcons.shuffle,
        label: 'Mutasi',
        onTap: () => _onMenuClicked(const AppRouteInfo.mutationNavBar()),
      ),
      _HomeMenuEntry(
        icon: LucideIcons.dollarSign,
        label: 'Penjualan',
        onTap: () => _onMenuClicked(const AppRouteInfo.sales()),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.4,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: items
          .map(
            (item) => QuickActionCard(
              icon: item.icon,
              label: item.label,
              onTap: item.onTap,
              primary: item.primary,
            ),
          )
          .toList(),
    );
  }

  /// Baris "Terakhir diperbarui" di bawah judul Discover.
  ///
  /// Waktunya berasal dari server, dan hanya muncul bila ada angka yang
  /// menyertainya. Sebelumnya baris ini mencetak jam telepon apa adanya,
  /// sehingga selalu menampilkan "baru saja" — termasuk ketika feedlot belum
  /// dipilih dan tidak ada satu pun angka di layar, dan termasuk ketika
  /// pemuatan gagal dan angka yang terlihat sudah basi.
  Widget _discoverLastUpdated() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) => p.discoverSummary != c.discoverSummary,
      builder: (context, state) {
        final lastUpdated = state.discoverSummary?.lastUpdated;
        if (lastUpdated == null || lastUpdated.isEmpty) {
          return const SizedBox.shrink();
        }

        return Text(
          "Terakhir diperbarui: ${lastUpdated.formatDateString(format: DateConstant.UTC, newFormat: DateConstant.DATETIME_FULL_MONTH)}",
          style: TextStyles.label3(),
        );
      },
    );
  }

  void _onSearchCattleClicked() async {
    if (appBloc.state.selectedProject == null) {
      _onShowFeedlotAlert();
      return;
    }
    navigator.showAppDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      Popup(
        closeVisibility: true,
        title: 'Cari Sapi',
        illustration: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Assets.images.ilCowSearch.image(
            height: Dimens.d160,
            fit: BoxFit.cover,
          ),
        ),
        description: const [
          TextSpan(
            text:
                'Silakan pilih metode dalam pencarian sapi menggunakan alat pemindai atau manual berdasarakan ear tag.',
          ),
        ],
        positiveButtonText: "Cari dengan Alat",
        negativeButtonText: "Cari Manual",
        onNegativeButtonPressed: _searchCattleManualBottomSheet,
        onPositiveButtonPressed: () async {
          await navigator.popAndPush(
            const AppRouteInfo.scan(route: DEST_CATTLE_DETAIL),
          );
        },
      ),
    );
  }

  void _searchCattleManualBottomSheet() async {
    await navigator.pop();
    await navigator.showBottomSheet(
      isScrollControlled: true,
      CattleSearchBottomSheet(bloc: bloc, onDismiss: () => navigator.pop()),
    );
  }
}

/// Satu entri menu beranda.
class _HomeMenuEntry {
  const _HomeMenuEntry({
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Pekerjaan utama petugas di layar ini.
  ///
  /// Hanya satu yang boleh ditandai. Aksen dipakai sekali supaya ia berarti
  /// "mulai dari sini"; dipakai di enam kartu sekaligus ia tidak berarti apa-apa.
  final bool primary;
}

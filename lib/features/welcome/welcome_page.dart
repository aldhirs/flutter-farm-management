import 'package:auto_route/auto_route.dart';
import 'package:farm/app/bloc/app_event.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/env_constants.dart';
import 'package:farm/features/welcome/bloc/welcome_bloc.dart';
import 'package:farm/features/welcome/bloc/welcome_event.dart';
import 'package:farm/features/welcome/bloc/welcome_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends BasePageState<WelcomePage, WelcomeBloc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeMark;
  late Animation<double> _scaleMark;
  late Animation<double> _fadeName;
  late Animation<Offset> _slideName;
  late Animation<double> _fadeTagline;
  late Animation<Offset> _slideTagline;
  late Animation<double> _fadeButton;
  late Animation<Offset> _slideButton;

  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());
    appBloc.add(const Clear());

    _initAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Tanda gambar di atas ubin putih.
  ///
  /// Logonya ungu pekat dengan latar tembus pandang, jadi di atas bidang ungu
  /// ia nyaris hilang. Ubin putih mengembalikan kontrasnya sekaligus membuat
  /// tanda ini terbaca sebagai lencana aplikasi — bentuk yang sama dengan ikon
  /// yang baru saja ditekan orang di layar utama ponselnya.
  Widget _mark() {
    return Container(
      padding: const EdgeInsets.all(Dimens.d16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d28),
      ),
      child: Assets.images.logo.image(height: Dimens.d88, width: Dimens.d88),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(
      builder: (context, state) {
        return CommonScaffold(
          backgroundColor: AppColors.current.mint800,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.d24,
                vertical: Dimens.d24,
              ),

              /// Satu gerakan masuk untuk seluruh layar.
              ///
              /// Sebelumnya tanda gambar berputar di sumbu X selama 600ms
              /// sebelum judul dan tombol menyusul. Yang ditunda oleh putaran
              /// itu adalah satu-satunya tombol di layar — orang yang membuka
              /// aplikasi untuk bekerja harus menunggu animasi selesai sebelum
              /// bisa menekannya.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _fadeMark,
                    child: ScaleTransition(scale: _scaleMark, child: _mark()),
                  ),
                  const SizedBox(height: Dimens.d32),
                  FadeTransition(
                    opacity: _fadeName,
                    child: SlideTransition(
                      position: _slideName,
                      child: Text(
                        EnvConstants.appName,
                        style: TextStyles.heading1().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimens.d12),
                  FadeTransition(
                    opacity: _fadeTagline,
                    child: SlideTransition(
                      position: _slideTagline,
                      child: Text(
                        'Catat ternak, kandang, dan perpindahannya langsung '
                        'dari lapangan.',
                        style: TextStyles.body2().copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  FadeTransition(
                    opacity: _fadeButton,
                    child: SlideTransition(
                      position: _slideButton,
                      child: ResponsiveWidget(
                        mobile: SizedBox(
                          width: double.infinity,
                          child: _buttons(),
                        ),
                        tabletPotrait: SizedBox(
                          width: ViewUtils.screenWidth() * 0.6,
                          child: _buttons(),
                        ),
                        tabletLandscape: SizedBox(
                          width: ViewUtils.screenWidth() * 0.3,
                          child: _buttons(),
                        ),
                      ),
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

  Widget _buttons() {
    return Button(
      size: ButtonSize.medium,
      type: ButtonType.primary,
      fulLWidth: true,
      onPressed: () {
        bloc.add(const LoginPressed());
      },
      text: 'Mulai',
    );
  }

  /// Satu urutan masuk, dibaca dari atas ke bawah.
  ///
  /// Bagian-bagiannya menyusul berurutan, bukan serentak, supaya mata
  /// mengikuti satu arah: lencana, nama, kalimat, lalu tombol. Seluruhnya
  /// selesai di bawah satu detik.
  ///
  /// Tombolnya tidak pernah menahan siapa pun. FadeTransition tetap menerima
  /// sentuhan meski masih tembus pandang, dan bagiannya sudah selesai pada 80%
  /// durasi — orang yang sudah hafal letak tombolnya bisa langsung menekan
  /// tanpa menunggu animasi usai.
  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Animation<double> fade(double begin, double end) => CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );

    Animation<Offset> rise(double begin, double end) =>
        Tween(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(begin, end, curve: Curves.easeOutCubic),
          ),
        );

    _fadeMark = fade(0.00, 0.40);

    /// Lencana membesar sedikit, tidak berputar.
    ///
    /// Skala kecil terbaca sebagai benda yang mendekat; putaran terbaca sebagai
    /// pertunjukan, dan pertunjukan itu yang dulu menahan tombol selama 600ms.
    _scaleMark = Tween(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _fadeName = fade(0.18, 0.55);
    _slideName = rise(0.18, 0.55);

    _fadeTagline = fade(0.30, 0.68);
    _slideTagline = rise(0.30, 0.68);

    _fadeButton = fade(0.45, 0.80);
    _slideButton = rise(0.45, 0.80);

    _controller.forward();
  }
}

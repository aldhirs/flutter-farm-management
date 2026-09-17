import 'package:auto_route/auto_route.dart';
import 'package:dartx/dartx.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/auth/login/bloc/login_bloc.dart';
import 'package:farm/features/auth/login/bloc/login_event.dart';
import 'package:farm/features/auth/login/bloc/login_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/buttons/button_text.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:farm/widgets/popup/popup.dart';
import 'package:farm/widgets/ticker/ticker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  final String? messageSuccessChangePassword;

  const LoginPage({super.key, this.messageSuccessChangePassword});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage, LoginBloc>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controllerEmail;
  late AnimationController _controller;

  late Animation<double> _fadeHeader;
  late Animation<Offset> _slideHeader;
  late Animation<double> _fadeSheet;
  late Animation<Offset> _slideSheet;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    bloc.add(
      Initiated(
        messageChangePassword: widget.messageSuccessChangePassword.orEmpty(),
        fcmToken: appBloc.state.fcmToken,
      ),
    );

    _initAnimation();
  }

  /// Dua bagian saja: kepala turun, lembar naik.
  ///
  /// Gerakannya menjelaskan susunan layar — bidang merek di atas, lembar kerja
  /// yang naik menutupinya — bukan sekadar menghidupkan halaman. Durasinya
  /// pendek karena layar ini dibuka untuk mengetik, dan kolom pertama sudah
  /// bisa disentuh jauh sebelum gerakannya selesai.
  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeHeader = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.55, curve: Curves.easeOut),
    );
    _slideHeader = Tween(begin: const Offset(0, -0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _fadeSheet = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.85, curve: Curves.easeOut),
    );
    _slideSheet = Tween(begin: const Offset(0, 0.10), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerEmail.dispose();
    super.dispose();
  }

  /// Tanda gambar di atas ubin putih, sama seperti layar sambutan.
  ///
  /// Logonya ungu pekat di atas latar tembus pandang, jadi ia butuh bidang
  /// terang untuk bisa terlihat di atas kepala berwarna ungu.
  Widget _mark() {
    return Container(
      padding: const EdgeInsets.all(Dimens.d12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.d20),
      ),
      child: Assets.images.logo.image(height: Dimens.d56, width: Dimens.d56),
    );
  }

  /// Kepala berwarna: tanda gambar dan sapaan.
  ///
  /// Warna merek muncul di layar pertama yang dilihat orang setiap pagi,
  /// bukan hanya setelah ia masuk. Bidang gelap juga lebih terbaca di bawah
  /// matahari daripada kartu putih yang memantul.
  Widget _header() {
    return Container(
      width: double.infinity,
      color: AppColors.current.mint800,
      padding: const EdgeInsets.fromLTRB(
        Dimens.d24,
        Dimens.d32,
        Dimens.d24,
        Dimens.d32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mark(),
          const SizedBox(height: Dimens.d20),
          Text(
            'Masuk',
            style: TextStyles.heading2().copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: Dimens.d8),
          Text(
            'Gunakan akun yang diberikan perusahaan Anda.',
            style: TextStyles.body3().copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fields() {
    return Column(
      children: [
        _errorWidget(),
        _textInputEmailWidget(),
        const SizedBox(height: Dimens.d16),
        _textInputPasswordWidget(),
        const SizedBox(height: Dimens.d4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonText(
              text: "Lupa Kata Sandi?",
              onPressed: () {
                showDialog(
                  useRootNavigator: false,
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => _popupInputForgotPassword(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return CommonScaffold(
          body: ResponsiveWidget(
            mobile: _viewPage(),
            tabletPotrait: _viewTabletContent(),
            tabletLandscape: _viewTabletContent(),
          ),
        );
      },
    );
  }

  Widget _viewTabletContent() {
    return Center(
      child: SizedBox(width: ViewUtils.screenWidth() * 0.6, child: _viewPage()),
    );
  }

  /// Kepala berwarna, lalu lembar putih yang naik menutupinya.
  ///
  /// Pembagiannya bukan hiasan: bidang berwarna adalah merek, lembar putih
  /// adalah tempat orang bekerja. Lembar itu juga memberi papan ketik sesuatu
  /// untuk didorong — seluruh isinya bisa digulir, sehingga kolom kata sandi
  /// tidak pernah tertutup papan ketik pada layar pendek.
  Widget _viewPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeTransition(
            opacity: _fadeHeader,
            child: SlideTransition(position: _slideHeader, child: _header()),
          ),
          Transform.translate(
            offset: const Offset(0, -Dimens.d24),
            child: FadeTransition(
              opacity: _fadeSheet,
              child: SlideTransition(
                position: _slideSheet,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.current.neutral100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimens.d28),
                      topRight: Radius.circular(Dimens.d28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    Dimens.d16,
                    Dimens.d28,
                    Dimens.d16,
                    Dimens.d32,
                  ),
                  child: Column(
                    children: [
                      _fields(),
                      const SizedBox(height: Dimens.d24),
                      _loginButtonWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<LoginBloc, LoginState> _textInputEmailWidget() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          current.emailValid ||
          current.loginInvalid ||
          previous.respError != current.respError,
      builder: (context, state) {
        var errorText = state.email.isEmpty
            ? 'Input alamat email'
            : 'Alamat email tidak valid';
        if (state.respError?.isNotEmpty == true) {
          errorText = '';
        }
        return _container(
          TextInputField(
            controller: _controllerEmail,
            textInputState:
                (!state.emailValid && state.loginInvalid) ||
                    state.respError?.isNotEmpty == true
                ? TextInputState.error
                : null,
            errorText: errorText,
            keyboardType: TextInputType.emailAddress,
            label: 'Alamat E-Mail',
            hintText: 'Alamat E-Mail',
            onChanged: (value) {
              bloc.add(OnInputEmailChanged(email: value));
            },
          ),
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> _textInputPasswordWidget() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          current.loginInvalid ||
          previous.respError != current.respError,
      builder: (context, state) {
        var errorText = state.password.isEmpty
            ? 'Input Kata Sandi'
            : 'Kata sandi tidak valid';
        if (state.respError?.isNotEmpty == true) {
          errorText = '';
        }
        return _container(
          TextInputField(
            textInputState:
                (state.password.isEmpty && state.loginInvalid) ||
                    state.respError?.isNotEmpty == true
                ? TextInputState.error
                : null,
            obscureText: true,
            errorText: errorText,
            enableToggleObscure: true,
            label: 'Kata Sandi',
            hintText: 'Kata Sandi',
            onChanged: (value) {
              bloc.add(OnInputPasswordChanged(password: value));
            },
          ),
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> _errorWidget() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.respError != current.respError,
      builder: (context, state) {
        return Visibility(
          visible: state.respError?.isNotEmpty == true,
          child: Column(
            children: [
              _container(
                TickerView(
                  type: TickerViewType.danger,
                  message: state.respError.orEmpty(),
                ),
              ),
              const SizedBox(height: Dimens.d24),
            ],
          ),
        );
      },
    );
  }

  BlocBuilder<LoginBloc, LoginState> _loginButtonWidget() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.isButtonVisible != current.isButtonVisible ||
          previous.isButtonLoginPressed != current.isButtonLoginPressed,
      builder: (context, state) => _container(
        SizedBox(
          height: Dimens.d48,
          child: Button(
            type: state.isButtonVisible
                ? ButtonType.primary
                : ButtonType.disabled,
            fulLWidth: true,
            loading: state.isButtonLoginPressed,
            onPressed: () {
              ViewUtils.hideKeyboard(context);
              bloc.add(const ClearError());
              bloc.add(const OnLoginPressed());
            },
            text: 'Masuk',
          ),
        ),
      ),
    );
  }

  Container _container(Widget child) {
    return Container(
      padding: const EdgeInsets.only(left: Dimens.d8, right: Dimens.d8),
      child: child,
    );
  }

  Widget _popupInputForgotPassword() {
    bloc.add(
      InitForgotPassword(
        title: 'Lupa Kata Sandi',
        subtitle: [
          TextSpan(
            text:
                'Masukkan alamat e-mail akun Anda. Instruksi untuk membuat '
                'kata sandi baru akan dikirim ke sana.',
          ),
        ],
        buttonTitle: 'Kirim Instruksi',
      ),
    );
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Stack(
            children: [
              Popup(
                textFieldVisibility: true,
                closeVisibility: true,
                textInputTitle: 'Alamat E-Mail',
                textInputHint: 'nama@perusahaan.com',
                title: 'Lupa Kata Sandi',

                /// Keterangan diberikan langsung di sini.
                ///
                /// Sebelumnya kalimatnya dititipkan lewat event
                /// `InitForgotPassword`, tetapi penanganan event itu hanya
                /// memancarkan ulang state tanpa menyimpan apa pun — jadi
                /// dialognya selalu terbuka tanpa satu kalimat penjelas.
                description: [
                  TextSpan(
                    text:
                        'Masukkan alamat e-mail akun Anda. Instruksi untuk '
                        'membuat kata sandi baru akan dikirim ke sana.',
                  ),
                ],
                positiveButtonText: 'Kirim Instruksi',
                positiveButtonType: ButtonType.primary,
                isLoading: false,
                onPositiveButtonPressed: () {
                  navigator.pop();
                  FocusScope.of(context).unfocus();
                  // bloc.add(const ForgotPasswordEmailReceived());
                },
                onChanged: (value) {
                  // bloc.add(EmailForgotPasswordChanged(email: value));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

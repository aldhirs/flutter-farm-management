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

class _LoginPageState extends BasePageState<LoginPage, LoginBloc> {
  late TextEditingController _controllerEmail;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _initData();
    bloc.add(
      Initiated(
        messageChangePassword: widget.messageSuccessChangePassword.orEmpty(),
        fcmToken: appBloc.state.fcmToken,
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return CommonScaffold(body: ResponsiveWidget(mobile: _viewPage()));
      },
    );
  }

  // ignore: unused_element
  Widget _viewPagePortrait() {
    return Column(
      children: [
        const SizedBox(height: Dimens.d48),
        Center(child: Assets.images.logo.image(height: Dimens.d48)),
        _viewTabletContent(),
      ],
    );
  }

  Widget _viewTabletContent() {
    return Container(
      margin: const EdgeInsets.all(Dimens.d46),
      padding: const EdgeInsets.only(
        left: Dimens.d16,
        right: Dimens.d16,
        top: Dimens.d24,
        bottom: Dimens.d24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(Dimens.d12),
      ),
      child: _viewPage(),
    );
  }

  Widget _viewPage() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: Dimens.d16,
            right: Dimens.d16,
            top: Dimens.d16,
            bottom: Dimens.d16,
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: Dimens.d36),
                _headerTitleWidget(),
                const SizedBox(height: Dimens.d24),
                _errorWidget(),
                _textInputEmailWidget(),
                const SizedBox(height: Dimens.d16),
                _textInputPasswordWidget(),
                const SizedBox(height: Dimens.d4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonText(
                      text: "Lupa Password?",
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
                const SizedBox(height: Dimens.d8),
                _loginButtonWidget(),
                const SizedBox(height: Dimens.d48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initData() async {}

  Widget _headerTitleWidget() {
    return Column(
      children: [
        Text(
          'Masuk',
          style: TextStyles.heading6().copyWith(
            color: AppColors.current.royalNavy900,
          ),
        ),
        const SizedBox(height: Dimens.d8),
      ],
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
        subtitle: [TextSpan(text: 'Silakan masukkan alamat e-mail')],
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
                textInputTitle: 'E-Mail',
                textInputHint: 'Alamat E-Mail',
                title: 'Kata Sandi',
                positiveButtonText: 'Kirim',
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

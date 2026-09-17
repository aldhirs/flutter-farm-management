import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/features/account/change_password/bloc/change_password_bloc.dart';
import 'package:farm/features/account/change_password/bloc/change_password_event.dart';
import 'package:farm/features/account/change_password/bloc/change_password_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends BasePageState<ChangePasswordPage, ChangePasswordBloc> {
  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.neutral400,
      appBar: CommonAppBar(titleText: 'Ubah Kata Sandi'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.d16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _intro(),
              const SizedBox(height: Dimens.d24),
              _oldPasswordField(),
              const SizedBox(height: Dimens.d16),
              _newPasswordField(),
              const SizedBox(height: Dimens.d16),
              _confirmPasswordField(),
              _serverError(),
              const SizedBox(height: Dimens.d32),
              _submitButton(),
              const SizedBox(height: Dimens.d24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _intro() {
    return Text(
      'Setelah kata sandi diganti, Anda tetap masuk di perangkat ini. '
      'Perangkat lain yang masih terbuka akan meminta Anda masuk kembali.',
      style: TextStyles.label2().copyWith(color: AppColors.current.neutral800),
    );
  }

  Widget _oldPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      bloc: bloc,
      buildWhen: (p, c) =>
          p.oldPassword != c.oldPassword ||
          p.submitted != c.submitted ||
          p.errorMessage != c.errorMessage,
      builder: (context, state) {
        /// Galat dari server hampir selalu tentang kolom ini — "kata sandi lama
        /// tidak sesuai" — jadi kolomnya ikut ditandai ketika server menolak.
        final bool invalid =
            (state.submitted && !state.oldValid) ||
            state.errorMessage.isNotEmpty;
        return TextInputField(
          label: 'Kata Sandi Saat Ini',
          hintText: 'Kata Sandi Saat Ini',
          obscureText: true,
          enableToggleObscure: true,
          textInputState: invalid ? TextInputState.error : null,
          errorText: state.oldValid ? '' : 'Masukkan kata sandi saat ini',
          onChanged: (value) => bloc.add(OldPasswordChanged(value: value)),
        );
      },
    );
  }

  Widget _newPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      bloc: bloc,
      buildWhen: (p, c) =>
          p.newPassword != c.newPassword ||
          p.oldPassword != c.oldPassword ||
          p.submitted != c.submitted,
      builder: (context, state) {
        String errorText = 'Minimal $kMinPasswordLength karakter';
        if (state.newIsSameAsOld) {
          errorText = 'Kata sandi baru harus berbeda dari yang sekarang';
        }

        final bool invalid =
            state.submitted && (!state.newValid || state.newIsSameAsOld);

        return TextInputField(
          label: 'Kata Sandi Baru',
          hintText: 'Kata Sandi Baru',
          obscureText: true,
          enableToggleObscure: true,
          textInputState: invalid ? TextInputState.error : null,
          errorText: errorText,

          /// Syaratnya disebut sejak awal, bukan hanya ketika dilanggar.
          additionalInfo: state.newPassword.isEmpty
              ? 'Minimal $kMinPasswordLength karakter'
              : null,
          onChanged: (value) => bloc.add(NewPasswordChanged(value: value)),
        );
      },
    );
  }

  Widget _confirmPasswordField() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      bloc: bloc,
      buildWhen: (p, c) =>
          p.confirmPassword != c.confirmPassword ||
          p.newPassword != c.newPassword ||
          p.submitted != c.submitted,
      builder: (context, state) {
        return TextInputField(
          label: 'Konfirmasi Kata Sandi Baru',
          hintText: 'Ulangi Kata Sandi Baru',
          obscureText: true,
          enableToggleObscure: true,
          textInputState: state.submitted && !state.confirmValid
              ? TextInputState.error
              : null,
          errorText: state.confirmPassword.isEmpty
              ? 'Ulangi kata sandi baru'
              : 'Konfirmasi tidak sama dengan kata sandi baru',

          /// Ketidakcocokan diberitahukan sambil mengetik, tanpa menunggu
          /// tombol ditekan: mengetik ulang seluruh kolom hanya untuk diberi
          /// tahu di akhir adalah pekerjaan yang bisa dihindari.
          successTextInfo: state.confirmValid ? 'Kata sandi cocok' : null,
          onChanged: (value) => bloc.add(ConfirmPasswordChanged(value: value)),
        );
      },
    );
  }

  Widget _serverError() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      bloc: bloc,
      buildWhen: (p, c) => p.errorMessage != c.errorMessage,
      builder: (context, state) {
        if (state.errorMessage.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: Dimens.d16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                size: Dimens.d16,
                color: AppColors.current.crimson500,
              ),
              const SizedBox(width: Dimens.d8),
              Expanded(
                child: Text(
                  state.errorMessage,
                  style: TextStyles.label2().copyWith(
                    color: AppColors.current.crimson500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      bloc: bloc,
      buildWhen: (p, c) => p.canSubmit != c.canSubmit || p.loading != c.loading,
      builder: (context, state) {
        return Button(
          fulLWidth: true,

          /// Tombol tetap bisa ditekan meski formulir belum lengkap.
          ///
          /// Tombol mati tidak memberi tahu apa yang kurang; menekannya
          /// menandai kolom mana yang belum beres. Yang benar-benar dicegah
          /// hanyalah menekan dua kali saat permintaan sedang berjalan.
          type: state.loading ? ButtonType.disabled : ButtonType.primary,
          text: state.loading ? 'Menyimpan...' : 'Simpan',
          onPressed: state.loading
              ? null
              : () => bloc.add(const SubmitPressed()),
        );
      },
    );
  }
}

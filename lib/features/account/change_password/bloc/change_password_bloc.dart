import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/change_password_request.dart';
import 'package:farm/domain/usecases/change_password_use_case.dart';
import 'package:farm/features/account/change_password/bloc/change_password_event.dart';
import 'package:farm/features/account/change_password/bloc/change_password_state.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ChangePasswordBloc
    extends BaseBloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordBloc(this._changePasswordUseCase)
    : super(const ChangePasswordState()) {
    on<OldPasswordChanged>((event, emit) {
      emit(state.copyWith(oldPassword: event.value, errorMessage: ''));
    }, transformer: log());
    on<NewPasswordChanged>((event, emit) {
      emit(state.copyWith(newPassword: event.value, errorMessage: ''));
    }, transformer: log());
    on<ConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.value, errorMessage: ''));
    }, transformer: log());
    on<SubmitPressed>(_submit, transformer: log());
  }

  /// Mengirim kata sandi baru.
  ///
  /// Konfirmasi tidak ikut dikirim: ia dicocokkan di sini dan tidak pernah
  /// meninggalkan perangkat.
  ///
  /// Galat dari server ditampilkan di layar, bukan lewat dialog. Yang paling
  /// sering muncul adalah "kata sandi lama tidak sesuai", dan itu perlu terbaca
  /// tepat di dekat kolom yang harus dibetulkan.
  Future<void> _submit(
    SubmitPressed event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(submitted: true, errorMessage: ''));
    if (!state.canSubmit) {
      return;
    }

    return runBlocCatching(
      handleLoading: false,
      handleError: false,
      action: () async {
        emit(state.copyWith(loading: true));
        final response = await _changePasswordUseCase.execute(
          ChangePasswordRequest(
            oldPassword: state.oldPassword,
            newPassword: state.newPassword,
          ),
        );
        switch (response.result) {
          case DataSuccess():
            navigator.pop(result: true);
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }
}

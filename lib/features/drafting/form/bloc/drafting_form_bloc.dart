import 'dart:async';

import 'package:farm/base/base.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DraftingFormBloc extends BaseBloc<DraftingFormEvent, DraftingFormState> {
  // BluetoothConnection? _connection;
  // StreamSubscription? _readSubscription;

  DraftingFormBloc() : super(const DraftingFormState()) {
    on<Initiated>(_initialized, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<DraftingFormState> emit,
  ) async {
    // _connection = event.connection;
  }

  @override
  Future<void> close() async {
    // _connection?.dispose();
    // _readSubscription?.cancel();
    super.close();
  }
}

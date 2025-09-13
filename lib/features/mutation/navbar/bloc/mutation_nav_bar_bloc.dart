import 'dart:async';
import 'package:farm/base/base.dart';
import 'package:farm/features/mutation/navbar/bloc/mutation_nav_bar_event.dart';
import 'package:farm/features/mutation/navbar/bloc/mutation_nav_bar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MutationNavBarBloc
    extends BaseBloc<MutationNavBarEvent, MutationNavBarState> {
  MutationNavBarBloc() : super(const MutationNavBarState()) {
    on<Initiated>(_initialized, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<MutationNavBarState> emit,
  ) async {}
}

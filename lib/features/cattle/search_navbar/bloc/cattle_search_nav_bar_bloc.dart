import 'dart:async';
import 'package:farm/base/base.dart';
import 'package:farm/features/cattle/search_navbar/bloc/cattle_search_nav_bar_event.dart';
import 'package:farm/features/cattle/search_navbar/bloc/cattle_search_nav_bar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CattleSearchNavBarBloc
    extends BaseBloc<CattleSearchNavBarEvent, CattleSearchNavBarState> {
  CattleSearchNavBarBloc() : super(const CattleSearchNavBarState()) {
    on<Initiated>(_initialized, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<CattleSearchNavBarState> emit,
  ) async {}
}

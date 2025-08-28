import 'dart:async';
import 'package:farm/base/base.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_event.dart';
import 'package:farm/features/home/home_navbar/bloc/home_nav_bar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class HomeNavBarBloc extends BaseBloc<HomeNavBarEvent, HomeNavBarState> {
  HomeNavBarBloc() : super(const HomeNavBarState()) {
    on<Initiated>(_initialized, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<HomeNavBarState> emit,
  ) async {}
}

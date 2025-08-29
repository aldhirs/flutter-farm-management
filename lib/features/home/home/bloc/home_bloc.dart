import 'package:farm/base/base.dart';
import 'package:farm/features/home/home/bloc/home_event.dart';
import 'package:farm/features/home/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<Initiated>(_initialized, transformer: log());
  }

  Future<void> _initialized(Initiated event, Emitter<HomeState> emit) async {}
}

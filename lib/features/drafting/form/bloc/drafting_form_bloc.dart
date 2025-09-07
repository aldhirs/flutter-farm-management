import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:farm/base/base.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_form_request.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/entities/growth/growth_form_request.dart';
import 'package:farm/domain/entities/level/level_request.dart';
import 'package:farm/domain/entities/medical/medical_form_request.dart';
import 'package:farm/domain/entities/medical/medical_type_request.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:farm/domain/entities/treatment/treatment_type_request.dart';
import 'package:farm/domain/usecases/barns_use_case.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/domain/usecases/cattle_update_use_case.dart';
import 'package:farm/domain/usecases/get_user_data_use_case.dart';
import 'package:farm/domain/usecases/growth_create_use_case.dart';
import 'package:farm/domain/usecases/levels_use_case.dart';
import 'package:farm/domain/usecases/medical_create_use_case.dart';
import 'package:farm/domain/usecases/medical_types_use_case.dart';
import 'package:farm/domain/usecases/pens_use_case.dart';
import 'package:farm/domain/usecases/treatment_create_use_case.dart';
import 'package:farm/domain/usecases/treatment_types_use_case.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_state.dart';
import 'package:farm/features/drafting/form/model/list_item.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:farm/utils/date_time_utils.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@Injectable()
class DraftingFormBloc extends BaseBloc<DraftingFormEvent, DraftingFormState> {
  final CattleByRFIDUseCase _cattleUseCase;
  final GetUserDataUseCase _userDataUseCase;
  final BarnsUseCase _barnsUseCase;
  final PensUseCase _pensUseCase;
  final LevelsUseCase _levelsUseCase;
  final CattleUpdateUseCase _cattleUpdateUseCase;
  final GrowthCreateUseCase _growthCreateUseCase;
  final GrowthCreateUseCase _growthUpdateUseCase;
  final MedicalTypesUseCase _medicalTypesUseCase;
  final TreatmentTypesUseCase _treatmentTypesUseCase;
  final TreatmentCreateUseCase _treatmentCreateUseCase;
  final MedicalCreateUseCase _medicalCreateUseCase;

  DraftingFormBloc(
    this._cattleUseCase,
    this._userDataUseCase,
    this._barnsUseCase,
    this._pensUseCase,
    this._levelsUseCase,
    this._cattleUpdateUseCase,
    this._growthCreateUseCase,
    this._growthUpdateUseCase,
    this._medicalTypesUseCase,
    this._treatmentTypesUseCase,
    this._treatmentCreateUseCase,
    this._medicalCreateUseCase,
  ) : super(const DraftingFormState()) {
    on<Initiated>(_initialized, transformer: log());
    on<IdentityInit>(_identityInit, transformer: log());
    on<TreatmentInit>(_treatmentInit, transformer: log());
    on<MedicalInit>(_medicalInit, transformer: log());
    on<OnSubmitIdentity>(_onSubmitIdentity, transformer: log());
    on<OnSubmitGrowth>(_onSubmitGrowth, transformer: log());
    on<OnSubmitTreatment>(_onSubmitTreatment, transformer: log());
    on<OnSubmitMedical>(_onSubmitMedical, transformer: log());
    on<GetPens>(_getPensApi, transformer: log());
    on<IdentitySuccessChanged>((event, emit) {
      emit(state.copyWith(isIdentitySuccess: event.value));
    }, transformer: log());
    on<GrowthSuccessChanged>((event, emit) {
      emit(state.copyWith(isGrowthSuccess: event.value));
    }, transformer: log());
    on<TreatmentSuccessChanged>((event, emit) {
      emit(state.copyWith(isTreatmentSuccess: event.value));
    }, transformer: log());
    on<MedicSuccessChanged>((event, emit) {
      emit(state.copyWith(isIdentitySuccess: event.value));
    }, transformer: log());
    on<BarnChanged>((event, emit) {
      emit(state.copyWith(selectedBarn: event.barn, selectedPen: null));
      add(GetPens(barnId: event.barn.id));
    }, transformer: log());
    on<PenChanged>((event, emit) {
      emit(state.copyWith(selectedPen: event.pen));
    }, transformer: log());
    on<EarTagChanged>((event, emit) {
      emit(
        state.copyWith(
          earTag: event.value,
          isLevelError: event.value.isNotEmpty,
        ),
      );
    }, transformer: log());
    on<LevelChanged>((event, emit) {
      emit(state.copyWith(selectedLevel: event.value));
    }, transformer: log());
    on<WeightChanged>((event, emit) {
      emit(state.copyWith(weight: event.value));
    }, transformer: log());
    on<TreatmentTypeChanged>((event, emit) {
      emit(state.copyWith(selectedTreatmentType: event.value));
    }, transformer: log());
    on<MedicalTypeChanged>((event, emit) {
      emit(state.copyWith(selectedMedicalType: event.value));
    }, transformer: log());
    on<TreatmentDateChanged>((event, emit) {
      emit(state.copyWith(treatmentDate: event.value));
    }, transformer: log());
    on<TreatmentNoteChanged>((event, emit) {
      emit(state.copyWith(treatmentNote: event.value));
    }, transformer: log());
    on<InfectionChanged>((event, emit) {
      emit(state.copyWith(isInfection: event.value));
    }, transformer: log());
    on<MedicalNoteChanged>((event, emit) {
      emit(state.copyWith(medicalNote: event.value));
    }, transformer: log());
    on<MedicalStatusChanged>((event, emit) {
      emit(state.copyWith(medicalStatus: event.value));
    }, transformer: log());
  }

  Future<void> _initialized(
    Initiated event,
    Emitter<DraftingFormState> emit,
  ) async {
    await _cattleApi(event.rfid, emit);

    // user data
    final user = switch (runCatching(
      action: () => _userDataUseCase.execute(const GetUserDataInput()),
    )) {
      ResultSuccess(:final data) => data,
      _ => const UserData(),
    };
    emit(state.copyWith(userData: user));
  }

  Future<void> _identityInit(
    IdentityInit event,
    Emitter<DraftingFormState> emit,
  ) async {
    await _barnsApi(emit);
    await _getLevelsApi(emit);
  }

  Future<void> _medicalInit(
    MedicalInit event,
    Emitter<DraftingFormState> emit,
  ) async {
    await _getMedicalTypesApi(emit);
  }

  Future<void> _treatmentInit(
    TreatmentInit event,
    Emitter<DraftingFormState> emit,
  ) async {
    await _getTreatmentTypesApi(emit);
  }

  Future<void> _onSubmitIdentity(
    OnSubmitIdentity event,
    Emitter<DraftingFormState> emit,
  ) async {
    emit(state.copyWith(identityErrorMessage: ''));
    if (state.selectedBarn == null ||
        state.selectedLevel == null ||
        state.selectedPen == null ||
        state.earTag == null) {
      emit(
        state.copyWith(
          identityErrorMessage:
              'Harap mengisi kandang, pen, grade atau ear tag.',
        ),
      );
      return;
    }
    await _submitIdentityApi(emit);
  }

  @override
  Future<void> close() async {
    // _connection?.dispose();
    // _readSubscription?.cancel();
    super.close();
  }

  Future<void> _cattleApi(String rfid, Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        emit(state.copyWith(loading: true));
        final response = await _cattleUseCase.execute(
          CattleRequest(rfid: rfid),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            final items = _getCattleItems(data);
            Barn? barn;
            Pen? pen;
            if (data.pen != null) {
              barn = Barn(
                id: data.pen?.id_barn ?? '',
                name: data.pen?.name_barn ?? '',
              );
              pen = data.pen;
              add(GetPens(barnId: data.pen?.id_barn ?? ''));
            }
            emit(
              state.copyWith(
                cattle: data,
                selectedBarn: barn,
                selectedPen: pen,
                selectedLevel: data.level,
                earTag: data.ear_tag,
                weight: data.actual_weight.toString(),
                listItems: items,
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _barnsApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _barnsUseCase.execute(
          BarnRequest(projectId: appBloc.state.selectedProject!.id),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(barns: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {},
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _getPensApi(GetPens event, Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        final response = await _pensUseCase.execute(
          PenRequest(
            barnId: event.barnId,
            projectId: appBloc.state.selectedProject!.id,
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(pens: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _getMedicalTypesApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        final response = await _medicalTypesUseCase.execute(
          MedicalTypeRequest(
            clientSlug: appBloc.state.userData?.clientSlug ?? '',
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(medicalTypes: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _getTreatmentTypesApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        final response = await _treatmentTypesUseCase.execute(
          TreatmentTypeRequest(
            clientSlug: appBloc.state.userData?.clientSlug ?? '',
          ),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(treatmentTypes: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _getLevelsApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      action: () async {
        final response = await _levelsUseCase.execute(
          LevelRequest(clientSlug: appBloc.state.userData?.clientSlug ?? ''),
        );
        switch (response.result) {
          case DataSuccess(:final data):
            emit(state.copyWith(levels: data, errorMessage: ''));
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(errorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: false,
      doOnError: (e) async {
        emit(state.copyWith(errorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _submitIdentityApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, isIdentitySuccess: false));
        final cattle = state.cattle;
        final payload = CattleFormRequest(
          id: cattle.id,
          barn_id: state.selectedBarn?.id ?? '',
          pen_id: state.selectedPen?.id ?? '',
          ear_tag: state.earTag.orEmpty(),
          level_id: state.selectedLevel?.id ?? 0,
        );
        final response = await _cattleUpdateUseCase.execute(payload);
        switch (response.result) {
          case DataSuccess(:final data):
            final cattle = state.cattle.copyWith(
              ear_tag: state.earTag ?? '',
              level: state.selectedLevel ?? state.cattle.level,
              pen: state.cattle.pen?.copyWith(
                id: state.selectedPen?.id ?? (state.cattle.pen?.id ?? ''),
                id_barn:
                    state.selectedBarn?.id ?? (state.cattle.pen?.id_barn ?? ''),
                name: state.selectedPen?.name ?? (state.cattle.pen?.name ?? ''),
                name_barn:
                    state.selectedBarn?.name ??
                    (state.cattle.pen?.id_barn ?? ''),
              ),
            );
            emit(
              state.copyWith(
                cattle: cattle,
                listItems: _getCattleItems(cattle),
                isIdentitySuccess: true,
                errorMessage: '',
                identityErrorMessage: '',
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(identityErrorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: true,
      doOnError: (e) async {
        emit(
          state.copyWith(identityErrorMessage: exceptionMessageMapper.map(e)),
        );
      },
    );
  }

  bool _isProjectChosen(Emitter<DraftingFormState> emit) {
    if (appBloc.state.selectedProject == null) {
      emit(
        state.copyWith(
          errorMessage:
              'Anda harus memilih feedlot terlebih dahulu pada halaman beranda.',
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _onSubmitGrowth(
    OnSubmitGrowth event,
    Emitter<DraftingFormState> emit,
  ) async {
    emit(state.copyWith(growthErrorMessage: ''));
    if (state.weight == null) {
      emit(
        state.copyWith(growthErrorMessage: 'Harap mengisi berat badan sapi.'),
      );
      return;
    }
    await _submitGrowthApi(emit);
  }

  Future<void> _onSubmitTreatment(
    OnSubmitTreatment event,
    Emitter<DraftingFormState> emit,
  ) async {
    emit(state.copyWith(treatmentErrorMessage: ''));
    if (state.selectedTreatmentType == null || state.treatmentDate == null) {
      emit(
        state.copyWith(
          treatmentErrorMessage: 'Harap mengisi formulir dibawah ini.',
        ),
      );
      return;
    }
    await _submitTreatmentApi(emit);
  }

  Future<void> _onSubmitMedical(
    OnSubmitMedical event,
    Emitter<DraftingFormState> emit,
  ) async {
    emit(state.copyWith(medicalErrorMessage: ''));
    if (state.selectedMedicalType == null || state.medicalStatus == null) {
      emit(
        state.copyWith(
          medicalErrorMessage: 'Harap mengisi formulir dibawah ini.',
        ),
      );
      return;
    }
    await _submitMedicalApi(emit);
  }

  Future<void> _submitGrowthApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        emit(state.copyWith(loading: true, isGrowthSuccess: false));
        final isNewRecord = state.growth?.id == null;
        final payload = GrowthFormRequest(
          id: isNewRecord ? null : state.growth?.id,
          cattle_id: state.cattle.id,
          date_activity: DateTimeUtils.getCurrentTimestamp(),
          weight: state.weight?.toInt() ?? 0,
        );

        final response = isNewRecord
            ? await _growthCreateUseCase.execute(payload)
            : await _growthUpdateUseCase.execute(payload);

        switch (response.result) {
          case DataSuccess(:final data):
            final cattle = state.cattle.copyWith(
              actual_weight: (state.weight ?? '0').toInt(),
            );
            emit(
              state.copyWith(
                listItems: _getCattleItems(cattle),
                cattle: cattle,
                isGrowthSuccess: true,
                growth: isNewRecord ? data : state.growth,
                errorMessage: '',
                growthErrorMessage: '',
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(growthErrorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: true,
      doOnError: (e) async {
        emit(state.copyWith(growthErrorMessage: exceptionMessageMapper.map(e)));
      },
    );
  }

  Future<void> _submitTreatmentApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        if (!_isProjectChosen(emit)) {
          return;
        }
        emit(state.copyWith(loading: true, isTreatmentSuccess: false));
        final payload = TreatmentFormRequest(
          client_slug: appBloc.state.userData?.clientSlug ?? '',
          id_project: appBloc.state.selectedProject?.id ?? '0',
          id_cattle: state.cattle.id,
          id_treatment_type: state.selectedTreatmentType?.id ?? 0,
          treatment_date: DateFormat(
            DateConstant.DATE_YEAR_FIRST,
            'id_ID',
          ).format(state.treatmentDate ?? DateTime.now()),
          notes: state.treatmentNote.orEmpty(),
        );

        final response = await _treatmentCreateUseCase.execute(payload);

        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                isTreatmentSuccess: true,
                errorMessage: '',
                treatmentErrorMessage: '',
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(treatmentErrorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: true,
      doOnError: (e) async {
        emit(
          state.copyWith(treatmentErrorMessage: exceptionMessageMapper.map(e)),
        );
      },
    );
  }

  Future<void> _submitMedicalApi(Emitter<DraftingFormState> emit) {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        emit(state.copyWith(loading: true, isMedicalSuccess: false));
        final status = medicalStatusMap.entries
            .firstWhere((item) => item.value == state.medicalStatus)
            .key;
        final payload = MedicalFormRequest(
          id_project: appBloc.state.selectedProject?.id ?? '0',
          id_cattle: state.cattle.id,
          id_medical_type: state.selectedMedicalType?.id ?? 0,
          is_infection: state.isInfection,
          notes: state.medicalNote.orEmpty(),
          status: status,
        );

        final response = await _medicalCreateUseCase.execute(payload);

        switch (response.result) {
          case DataSuccess(:final data):
            emit(
              state.copyWith(
                isMedicalSuccess: true,
                errorMessage: '',
                medicalErrorMessage: '',
              ),
            );
            break;
          case DataError(:final errorMessage):
            emit(state.copyWith(medicalErrorMessage: errorMessage.orEmpty()));
          case null:
            return;
        }
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loading: false));
      },
      handleError: true,
      doOnError: (e) async {
        emit(
          state.copyWith(medicalErrorMessage: exceptionMessageMapper.map(e)),
        );
      },
    );
  }

  List<ListItem> _getCattleItems(Cattle data) {
    final items = [
      ListItem(name: 'ID', description: data.id),
      ListItem(name: 'RFID', description: data.rfid_tag),
      ListItem(name: 'Kandang', description: data.pen?.name_barn ?? '-'),
      ListItem(name: 'Pen', description: data.pen?.name ?? '-'),
      ListItem(name: 'Ear Tag', description: data.ear_tag),
      ListItem(
        name: 'Berat',
        description: '${data.actual_weight.toString()} KG',
      ),
      ListItem(name: 'Breed', description: data.id_breed),
      ListItem(name: 'Jenis Kelamin', description: data.gender),
      ListItem(name: 'Status', description: data.status),
    ];
    return items;
  }
}

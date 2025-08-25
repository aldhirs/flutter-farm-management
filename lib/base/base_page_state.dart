import 'package:farm/app/bloc/app_bloc.dart';
import 'package:farm/base/base.dart';
import 'package:farm/base/exception/base/app_exception.dart';
import 'package:farm/base/exception/base/app_exception_wrapper.dart';
import 'package:farm/base/log/mixin/log_mixin.dart';
import 'package:farm/exception_handler/exception_handler.dart';
import 'package:farm/exception_handler/exception_message_mapper.dart';
import 'package:farm/helper/stream/dispose_bag.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/navigation/app_navigator_impl.dart';
import 'package:farm/resources/dimens/app_dimen.dart';
import 'package:farm/resources/styles/app_colors.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/widgets/loading/animated_default_loading.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

abstract class BasePageState<T extends StatefulWidget, B extends BaseBloc>
    extends BasePageStateDelegate<T, B>
    with LogMixin {}

abstract class BasePageStateDelegate<
  T extends StatefulWidget,
  B extends BaseBloc
>
    extends State<T>
    implements ExceptionHandlerListener {
  late final AppNavigator navigator = GetIt.instance.get<AppNavigator>();
  late final AppBloc appBloc = GetIt.instance.get<AppBloc>();
  late final ExceptionMessageMapper exceptionMessageMapper =
      const ExceptionMessageMapper();
  late final ExceptionHandler exceptionHandler = ExceptionHandler(
    navigator: navigator,
    listener: this,
  );

  late final DisposeBag disposeBag = DisposeBag();

  late final CommonBloc commonBloc = GetIt.instance.get<CommonBloc>()
    ..navigator = navigator
    ..appBloc = appBloc
    ..exceptionHandler = exceptionHandler
    ..exceptionMessageMapper = exceptionMessageMapper;

  late final B bloc = GetIt.instance.get<B>()
    ..navigator = navigator
    ..appBloc = appBloc
    ..commonBloc = commonBloc
    ..exceptionHandler = exceptionHandler
    ..exceptionMessageMapper = exceptionMessageMapper;

  bool get isAppWidget => false;

  @override
  void initState() {
    super.initState();
    // fToast = FToast();
    // fToast?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return buildProvider(context);
  }

  Widget buildProvider(BuildContext context) {
    if (!isAppWidget) {
      AppDimen.of(context);
      AppColors.of(context);
    }

    var buildPageWidget = buildPage(context);
    if (kDebugMode || kProfileMode) {
      buildPageWidget = GestureDetector(
        child: buildPageWidget,
        onDoubleTapDown: (detail) {
          // on top right position
          if (detail.localPosition.dx > 380 && detail.localPosition.dy < 100) {
            ChuckerFlutter.showChuckerScreen();
          }
        },
      );
    }

    // fix tablet max width 1344px
    buildPageWidget = DeviceUtils.isTabletFixFullWidth()
        ? Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white),
            child: SizedBox(
              width: DeviceUtils.getTabletFixFullWidth(),
              child: buildPageWidget,
            ),
          )
        : buildPageWidget;

    return Provider(
      create: (context) => navigator,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => bloc),
          BlocProvider(create: (_) => commonBloc),
        ],
        child: buildPageListeners(
          child: MultiBlocListener(
            listeners: [
              BlocListener<CommonBloc, CommonState>(
                listenWhen: (previous, current) =>
                    previous.appExceptionWrapper !=
                        current.appExceptionWrapper &&
                    current.appExceptionWrapper != null,
                listener: (context, state) {
                  handleException(state.appExceptionWrapper!);
                },
              ),
            ],
            child: isAppWidget
                ? buildPageWidget
                : Stack(
                    children: [
                      buildPageWidget,
                      BlocBuilder<CommonBloc, CommonState>(
                        buildWhen: (previous, current) =>
                            previous.isLoading != current.isLoading,
                        builder: (context, state) => Visibility(
                          visible: state.isLoading,
                          child: buildPageLoading(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildPageListeners({required Widget child}) => child;

  Widget buildPageLoading() => Container(
    color: AppColors.current.black.withValues(alpha: 0.5),
    child: const AnimatedDefaultLoading(),
  );

  Widget buildPage(BuildContext context);

  @override
  void dispose() {
    super.dispose();
    disposeBag.dispose();
  }

  void handleException(AppExceptionWrapper appExceptionWrapper) {
    exceptionHandler
        .handleException(
          appExceptionWrapper,
          handleExceptionMessage(appExceptionWrapper.appException),
        )
        .then((value) {
          appExceptionWrapper.exceptionCompleter?.complete();
        });
  }

  String handleExceptionMessage(AppException appException) {
    return exceptionMessageMapper.map(appException);
  }

  @override
  void onRefreshTokenFailed() {
    commonBloc.add(const ForceLogoutButtonPressed());
  }
}

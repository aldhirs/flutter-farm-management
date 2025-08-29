import 'package:auto_route/auto_route.dart';
import 'package:farm/domain/usecases/is_logged_in_use_case.dart';
import 'package:farm/helper/run_catching/result.dart';
import 'package:farm/helper/run_catching/run_catching.dart';
import 'package:injectable/injectable.dart';

import '../routes/app_router.gr.dart';

@Injectable()
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._isLoggedInUseCase);

  final IsLoggedInUseCase _isLoggedInUseCase;

  bool get _isLoggedIn => switch (runCatching(
    action: () => _isLoggedInUseCase.execute(const IsLoggedInInput()),
  )) {
    ResultSuccess(:final data) => data.isLoggedIn,
    _ => false,
  };

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_isLoggedIn) {
      resolver.next(true);
    } else {
      router.replace(const WelcomeRoute());
    }
  }
}

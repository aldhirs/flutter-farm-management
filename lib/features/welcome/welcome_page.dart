import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/features/welcome/bloc/welcome_bloc.dart';
import 'package:farm/features/welcome/bloc/welcome_event.dart';
import 'package:farm/features/welcome/bloc/welcome_state.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends BasePageState<WelcomePage, WelcomeBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(
      builder: (context, state) {
        return CommonScaffold(
          body: Container(
            width: double.infinity,
            height: ViewUtils.screenHeight(),
            padding: const EdgeInsets.all(Dimens.d16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _getImageBackground(context),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox(height: 80)),
                  Assets.images.logo.image(
                    height: Dimens.d180,
                    width: AppDimen.current.screenWidth,
                  ),
                  const SizedBox(height: Dimens.d24),
                  Text(
                    'Selamat datang di Farm House',
                    style: TextStyles.heading6().copyWith(
                      color: AppColors.current.royalNavy900,
                    ),
                  ),
                  const SizedBox(height: Dimens.d52),
                  const Expanded(child: SizedBox()),
                  ResponsiveWidget(
                    mobile: SizedBox(width: double.infinity, child: _buttons()),
                    tabletPotrait: SizedBox(
                      width: ViewUtils.screenWidth() * 0.6,
                      child: _buttons(),
                    ),
                    tabletLandscape: SizedBox(
                      width: ViewUtils.screenWidth() * 0.3,
                      child: _buttons(),
                    ),
                  ),
                  const SizedBox(height: Dimens.d16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AssetImage _getImageBackground(BuildContext context) {
    var assetImage = const AssetImage('assets/images/welcome/bg_mobile.webp');
    if (DeviceUtils.getDeviceTypeOf(context) == DeviceType.tabletPortrait) {
      assetImage = const AssetImage(
        'assets/images/welcome/bg_tablet_portrait.webp',
      );
    } else if (DeviceUtils.getDeviceTypeOf(context) ==
        DeviceType.tabletLandscape) {
      assetImage = const AssetImage(
        'assets/images/welcome/bg_tablet_landscape.webp',
      );
    }
    return assetImage;
  }

  Widget _buttons() {
    return Column(
      children: [
        Button(
          size: ButtonSize.medium,
          type: ButtonType.primary,
          fulLWidth: true,
          onPressed: () {
            bloc.add(const LoginPressed());
          },
          text: 'Mulai',
        ),
        const SizedBox(height: Dimens.d16),
      ],
    );
  }
}

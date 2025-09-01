import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/constants/env_constants.dart';
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

class _WelcomePageState extends BasePageState<WelcomePage, WelcomeBloc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeLogo;
  late Animation<Offset> _slideLogo;
  late Animation<double> _flipLogo;

  late Animation<double> _fadeTitle;
  late Animation<Offset> _slideTitle;

  late Animation<double> _fadeButtons;
  late Animation<Offset> _slideButtons;

  @override
  void initState() {
    super.initState();
    bloc.add(const Initiated());

    _initAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _luxuryLogo() {
    return FadeTransition(
      opacity: _fadeLogo,
      child: SlideTransition(
        position: _slideLogo,
        child: AnimatedBuilder(
          animation: _flipLogo,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(_flipLogo.value),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Assets.images.logo.image(
            height: Dimens.d180,
            width: AppDimen.current.screenWidth,
          ),
        ),
      ),
    );
  }

  Widget _luxuryTitle() {
    return FadeTransition(
      opacity: _fadeTitle,
      child: SlideTransition(
        position: _slideTitle,
        child: Text(
          'Selamat datang di ${EnvConstants.appName}',
          style: TextStyles.heading4().copyWith(
            color: AppColors.current.royalNavy900,
          ),
        ),
      ),
    );
  }

  Widget _luxuryButtons() {
    return FadeTransition(
      opacity: _fadeButtons,
      child: SlideTransition(position: _slideButtons, child: _buttons()),
    );
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
                  _luxuryLogo(),
                  const SizedBox(height: Dimens.d24),
                  _luxuryTitle(),
                  const SizedBox(height: Dimens.d52),
                  const Expanded(child: SizedBox()),
                  ResponsiveWidget(
                    mobile: SizedBox(
                      width: double.infinity,
                      child: _luxuryButtons(),
                    ),
                    tabletPotrait: SizedBox(
                      width: ViewUtils.screenWidth() * 0.6,
                      child: _luxuryButtons(),
                    ),
                    tabletLandscape: SizedBox(
                      width: ViewUtils.screenWidth() * 0.3,
                      child: _luxuryButtons(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AssetImage _getImageBackground(BuildContext context) {
    var assetImage = const AssetImage('assets/images/welcome/bg_mobile.jpg');
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

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // --- Luxurious staggered animations ---
    _fadeLogo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _slideLogo = Tween(begin: const Offset(0, -0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );
    _flipLogo = Tween(begin: pi / 2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _fadeTitle = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
    );
    _slideTitle = Tween(begin: const Offset(0, -0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
      ),
    );

    _fadeButtons = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    _slideButtons = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }
}

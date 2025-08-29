import 'package:auto_route/auto_route.dart';
import 'package:farm/base/base_page_state.dart';
import 'package:farm/constants/enum_constants.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_bloc.dart';
import 'package:farm/features/drafting/form/bloc/drafting_form_event.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

@RoutePage()
class DraftingFormPage extends StatefulWidget {
  const DraftingFormPage({super.key, required this.rfid});

  final String rfid;

  @override
  State<DraftingFormPage> createState() => _DraftingFormPageState();
}

class _DraftingFormPageState
    extends BasePageState<DraftingFormPage, DraftingFormBloc> {
  @override
  void initState() {
    bloc.add(Initiated(rfid: widget.rfid));
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(
        titleText: 'Input Drafting Hewan',
        forceMaterialTransparency: false,
      ),
      body: ResponsiveWidget(
        mobile: _contentView(ViewUtils.screenWidth(), false),
        tabletPotrait: _contentView(ViewUtils.screenWidth() * 0.4, true),
        tabletLandscape: _contentView(ViewUtils.screenWidth() * 0.3, true),
      ),
    );
  }

  Widget _contentView(double width, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: !isTablet ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: isTablet ? Dimens.d64 : 0),
          SizedBox(
            width: DeviceUtils.getDeviceType() == DeviceType.mobile
                ? width * 0.7
                : width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // adjust radius
              child: Assets.images.ilCowScanning.image(
                height: Dimens.d240,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: width,
            padding: const EdgeInsets.only(top: Dimens.d16),
            child: Text(
              widget.rfid,
              textAlign: TextAlign.center,
              style: TextStyles.heading4().copyWith(
                color: AppColors.current.royalNavy900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

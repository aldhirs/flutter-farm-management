import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_route_info.freezed.dart';

/// page
@freezed
abstract class AppRouteInfo with _$AppRouteInfo {
  // auth
  const factory AppRouteInfo.welcome() = Welcome;

  const factory AppRouteInfo.login({String? messageChangePassword}) = Login;

  // const factory AppRouteInfo.loginOtp({String? email, String? otpPurpose}) = LoginOtp;

  // const factory AppRouteInfo.resetPassword() = ResetPassword;
  // const factory AppRouteInfo.accountSetting(String userType) = AccountSetting;
  // const factory AppRouteInfo.accountInstitution(String userType) = AccountInstitution;
  // const factory AppRouteInfo.accountInstitutionForm(String userType, bool isCreating) =
  //     AccountInstitutionForm;
  // const factory AppRouteInfo.learnContentWrapper(LearnContentWrapperParams params) =
  //     LearnContentWrapper;

  // const factory AppRouteInfo.quizWrapper(QuizWrapperParams params) = QuizWrapper;

  // const factory AppRouteInfo.quizPreview(QuizPreviewParams params) = QuizPreview;

  // const factory AppRouteInfo.quizReview(QuizReviewParams params) = QuizReview;

  // const factory AppRouteInfo.upload({String? pickedPath, bool? isMediaOnly}) = Upload;

  // // home
  const factory AppRouteInfo.home() = Home;
}

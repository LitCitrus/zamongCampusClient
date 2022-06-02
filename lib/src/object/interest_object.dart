import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/models/interest.dart';
import 'package:http/http.dart' as http;
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/utils/interest_data.dart';
import 'package:zamongcampus/src/business_logic/view_models/profile_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/interest/interest_service.dart';

class InterestObject {
  static List<Interest> myInterests = [];
  static loadMyInterests() async {
    InterestService interestService = serviceLocator<InterestService>();
    // 서버 통신 후 값 저장.
    myInterests = await interestService.fetchMyInterests();
  }

  static updateMyInterests(List<Interest> newInterests) {
    myInterests = newInterests;
  }

  static List<InterestPresentation> mapInterests(
      List<Interest>? otherInterests) {
    List<InterestPresentation> interestPresentations = [];
    for (var systemInterest in allInterestList) {
      if (otherInterests!.any(
              (otherInterest) => otherInterest.codeNum == systemInterest) &&
          myInterests.any(
              (otherInterest) => otherInterest.codeNum == systemInterest)) {
        interestPresentations.add(InterestPresentation(
            title: InterestData.iconOf(systemInterest.name) +
                " " +
                InterestData.korNameOf(systemInterest.name),
            status: InterestStatus.SAME));
      } else if (otherInterests
          .any((otherInterest) => otherInterest.codeNum == systemInterest)) {
        interestPresentations.add(InterestPresentation(
            title: InterestData.iconOf(systemInterest.name) +
                " " +
                InterestData.korNameOf(systemInterest.name),
            status: InterestStatus.DIFFERENT));
      } else {
        interestPresentations.add(InterestPresentation(
            title: InterestData.iconOf(systemInterest.name) +
                " " +
                InterestData.korNameOf(systemInterest.name),
            status: InterestStatus.NONE));
      }
    }
    return interestPresentations;
  }
}

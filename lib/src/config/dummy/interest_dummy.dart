import 'package:zamongcampus/src/business_logic/models/interest.dart';
import 'package:zamongcampus/src/business_logic/utils/interest_data.dart';

import '../../business_logic/view_models/profile_viewmodel.dart';

List<InterestPresentation> interestDummy = [
  InterestPresentation(
      title: InterestData.iconOf(
              Interest(codeNum: InterestCode.i0001).codeNum.name) + //이렇게하는게 맞음
          " " +
          InterestData.korNameOf('i0001'),
      status: InterestStatus.SAME),
  InterestPresentation(
      title:
          InterestData.iconOf('i0002') + " " + InterestData.korNameOf('i0002'),
      status: InterestStatus.DIFFERENT),
  InterestPresentation(
      title:
          InterestData.iconOf('i0003') + " " + InterestData.korNameOf('i0003'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0004') + " " + InterestData.korNameOf('i0004'),
      status: InterestStatus.SAME),
  InterestPresentation(
      title:
          InterestData.iconOf('i0005') + " " + InterestData.korNameOf('i0005'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0006') + " " + InterestData.korNameOf('i0006'),
      status: InterestStatus.SAME),
  InterestPresentation(
      title:
          InterestData.iconOf('i0007') + " " + InterestData.korNameOf('i0007'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0008') + " " + InterestData.korNameOf('i0008'),
      status: InterestStatus.DIFFERENT),
  InterestPresentation(
      title:
          InterestData.iconOf('i0009') + " " + InterestData.korNameOf('i0009'),
      status: InterestStatus.SAME),
  InterestPresentation(
      title:
          InterestData.iconOf('i0010') + " " + InterestData.korNameOf('i0010'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0011') + " " + InterestData.korNameOf('i0011'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0012') + " " + InterestData.korNameOf('i0012'),
      status: InterestStatus.SAME),
  InterestPresentation(
      title:
          InterestData.iconOf('i0013') + " " + InterestData.korNameOf('i0013'),
      status: InterestStatus.SAME),
  InterestPresentation(
      title:
          InterestData.iconOf('i0014') + " " + InterestData.korNameOf('i0014'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0015') + " " + InterestData.korNameOf('i0015'),
      status: InterestStatus.NONE),
  InterestPresentation(
      title:
          InterestData.iconOf('i0016') + " " + InterestData.korNameOf('i0016'),
      status: InterestStatus.DIFFERENT),
];

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/models/interest.dart';
import 'package:zamongcampus/src/business_logic/models/user.dart';
import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/interest_data.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';

class MypageViewModel extends BaseModel {
  MypagePresentation _myInfo = defaultInfo;
  final List<InterestPresentation> _myInterests = [];
  final List<InterestPresentation> _selectedInterests = [];

  static final MypagePresentation defaultInfo = MypagePresentation(
    nickname: '',
    imageUrl: 'assets/images/user/general_user.png',
    collegeName: '',
    interestCount: '',
    friendCount: '17',
    bookmarkCount: '2',
    feedCount: '21',
    commentCount: '5',
  );

  MypagePresentation get myInfo => _myInfo;
  List<InterestPresentation> get myInterests => _myInterests;
  List<InterestPresentation> get selectedInterests => _selectedInterests;

  void loadMyInfo(String loginId) async {
    setBusy(true);

    //User myInfoResult = await _userService.fetchMyInfo(loginId: loginId);  // myInfoResult에 가져온 데이터를 담는다. 지금은 그냥 뷰모델 자체에 fake 유저 데이터 추가

    User myInfoResult = fakeMyInfo;
    _myInfo = MypagePresentation(
        nickname: myInfoResult.nickname,
        imageUrl: myInfoResult.imageUrl ?? defaultInfo.imageUrl,
        collegeName: CollegeData.korNameOf(
            describeEnum(myInfoResult.collegeCode ?? College.college0000)),
        majorName: MajorData.korNameOf(
            describeEnum(myInfoResult.majorCode ?? Major.major0000)),
        introduction: myInfoResult.introduction,
        interestCount: myInfoResult.interests!.length.toString(),
        friendCount: defaultInfo.friendCount,
        bookmarkCount: defaultInfo.bookmarkCount,
        feedCount: defaultInfo.feedCount,
        commentCount: defaultInfo.commentCount);
    setBusy(false);
  }

  void loadMyInterest() async {
    //List<Interest> selectedInterests = await _userService.fetchMyInterest(loginId: loginId); 유저의 관심사 데이터만 패치

    _myInterests.clear();
    _selectedInterests.clear();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      List<Interest> selectedInterests = fakeMyInfo.interests!;

      for (Interest systemInterest in systemInterests) {
        //이중 포문 안쓰는 방법 찾아보기
        bool hasData = false;
        for (Interest selectedInterest in selectedInterests) {
          if (systemInterest.codeNum == selectedInterest.codeNum) {
            hasData = true;
            break;
          }
        }
        if (hasData == true) {
          _myInterests.add(InterestPresentation(
              codeNum: systemInterest.codeNum,
              title: InterestData.korNameOf(systemInterest.codeNum.name),
              icon: InterestData.iconOf(systemInterest.codeNum.name),
              isSelected: hasData));
        } else if (hasData == false) {
          _myInterests.add(InterestPresentation(
              codeNum: systemInterest.codeNum,
              title: InterestData.korNameOf(systemInterest.codeNum.name),
              icon: InterestData.iconOf(systemInterest.codeNum.name),
              isSelected: hasData));
        }
      }

      for (InterestPresentation interest in _myInterests) {
        if (interest.isSelected) {
          _selectedInterests.add(interest);
        }
      }

      notifyListeners();
    });
  }

  void changeInterestStatus(InterestPresentation interest, bool value) {
    interest.isSelected = value;
    if (interest.isSelected == false) {
      _selectedInterests.remove(interest);
    } else if (interest.isSelected == true) {
      _selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void updateMyInfo(
      {String? nickname,
      String? introduction,
      String? imageUrl,
      required BuildContext context}) async {
    (nickname == _myInfo.nickname)
        ? nickname = null
        : _myInfo.nickname = nickname!;
    (introduction == _myInfo.introduction || introduction == '')
        ? introduction = null
        : _myInfo.introduction = introduction!;
    (imageUrl == '')
        ? imageUrl = null
        : _myInfo.imageUrl; //사진은 일단 하나만 받아서 사진 리스트 젤 앞으로 넣어둠 ->추후 수정

    //서버에 값 넘길때는 인자들이 null이 아닌것만 넘기면 됨.

    notifyListeners();
    Navigator.pop(context);
    toastMessage('프로필 변경 완료!');
  }

  void updateInterests({required BuildContext context}) {
    List<InterestCode> _result = []; //서버에 넘길 값. 선택된 관심사의 코드값만 넘김

    for (InterestPresentation interest in _selectedInterests) {
      _result.add(interest.codeNum);
    }
    print(_result.length); //확인용
    print(_result); //확인용

    _myInfo.interestCount = _selectedInterests.length.toString();
    notifyListeners();
    Navigator.pop(context);
    toastMessage('관심사 변경 완료!');
  }
}

class MypagePresentation {
  String nickname;
  String imageUrl;
  final String collegeName;
  final String? majorName;
  String? introduction;

  String interestCount;
  final String friendCount;
  final String bookmarkCount;
  final String feedCount;
  final String commentCount;

  MypagePresentation(
      {required this.nickname,
      required this.imageUrl,
      required this.collegeName,
      this.majorName,
      this.introduction,
      required this.interestCount,
      required this.friendCount,
      required this.bookmarkCount,
      required this.feedCount,
      required this.commentCount});
}

class InterestPresentation {
  final InterestCode codeNum;
  final String title;
  final String icon;
  bool isSelected;

  InterestPresentation(
      {required this.codeNum,
      required this.title,
      required this.icon,
      required this.isSelected});
}

User fakeMyInfo = User(
    loginId: 'myLoginId',
    nickname: '다노박러브',
    collegeCode: College.college0001,
    imageUrl: "assets/images/user/user3.jpg",
    majorCode: Major.major0001,
    introduction: "자기개발, 꾸준함, 성실한 사람 좋아해요\n저랑 잘 맞는 친구 찾구싶어요!",
    isOnline: true,
    interests: [
      Interest(codeNum: InterestCode.i0002),
      Interest(codeNum: InterestCode.i0004),
      Interest(codeNum: InterestCode.i0006),
      Interest(codeNum: InterestCode.i0007),
      Interest(codeNum: InterestCode.i0010),
      Interest(codeNum: InterestCode.i0016),
    ]);

List<Interest> systemInterests = [
  Interest(codeNum: InterestCode.i0001),
  Interest(codeNum: InterestCode.i0002),
  Interest(codeNum: InterestCode.i0003),
  Interest(codeNum: InterestCode.i0004),
  Interest(codeNum: InterestCode.i0005),
  Interest(codeNum: InterestCode.i0006),
  Interest(codeNum: InterestCode.i0007),
  Interest(codeNum: InterestCode.i0008),
  Interest(codeNum: InterestCode.i0009),
  Interest(codeNum: InterestCode.i0010),
  Interest(codeNum: InterestCode.i0011),
  Interest(codeNum: InterestCode.i0012),
  Interest(codeNum: InterestCode.i0013),
  Interest(codeNum: InterestCode.i0014),
  Interest(codeNum: InterestCode.i0015),
  Interest(codeNum: InterestCode.i0016),
];

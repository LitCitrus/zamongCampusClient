class InterestData {
  static iconOf(String code) {
    return data[code]?['icon'] ?? '?';
  }

  static korNameOf(String code) {
    return data[code]?['name'] ?? 'unknown name';
  }

  static final Map<String, Map<String, String>> data = {
    'interest0001': {'name': 'mbti과몰입', 'icon': '\u{1F601}'},
    'interest0002': {'name': '갓생살기', 'icon': '\u{1F4DA}'},
    'interest0003': {'name': '카페투어', 'icon': '\u{2615}'},
    'interest0004': {'name': '술자리', 'icon': '\u{1F37B}'},
    'interest0005': {'name': '혼코노', 'icon': '\u{1F3A4}'},

    ///
    'interest0006': {'name': '헬스/운동', 'icon': '\u{1F3C3}'},
    'interest0007': {'name': '유튜브', 'icon': '\u{1F3AE}'},
    'interest0008': {'name': '한강나들이', 'icon': '\u{1F371}'},
    'interest0009': {'name': '넷플릭스', 'icon': '\u{1F52B}'},
    'interest0010': {'name': '패션/쇼핑', 'icon': '\u{1F453}'},

    ///
    'interest0011': {'name': '혼술', 'icon': '\u{1F37A}'},
    'interest0012': {'name': '인스타그램', 'icon': '\u{1F481}'},
    'interest0013': {'name': '여행', 'icon': '\u{2708}'},
    'interest0014': {'name': '사진찍기', 'icon': '\u{1F4F7}'},
    'interest0015': {'name': '틱톡', 'icon': '\u{1F4D6}'},

    ///
    'interest0016': {'name': '맛집투어', 'icon': '\u{1F372}'},
    'interest0017': {'name': '연애고수', 'icon': '\u{1F496}'},
    'interest0018': {'name': '핵인싸', 'icon': '\u{1F61C}'},
    'interest0019': {'name': '연애하수', 'icon': '\u{1F493}'},
    'interest0020': {'name': '카공', 'icon': '\u{1F392}'},

    ///
    'interest0021': {'name': '미팅/과팅', 'icon': '\u{1F490}'},
    'interest0022': {'name': '콘서트', 'icon': '\u{1F3AB}'},
    'interest0023': {'name': '웹드라마', 'icon': '\u{1F3AC}'},
    'interest0024': {'name': '동네친구', 'icon': '\u{1F46C}'},
    'interest0025': {'name': '동아리', 'icon': '\u{1F450}'},

    ///
    'interest0026': {'name': '자취', 'icon': '\u{1F373}'},
    'interest0027': {'name': '비트코인', 'icon': '\u{1F4B8}'},
    'interest0028': {'name': '주식', 'icon': '\u{1F4C8}'},
    'interest0029': {'name': '패알못', 'icon': '\u{1F456}'},
    'interest0030': {'name': '퍼스널컬러', 'icon': '\u{1F308}'},

    ///
    'interest0031': {'name': '취업/진로', 'icon': '\u{1F4BC}'},
    'interest0032': {'name': '랩/힙합', 'icon': '\u{1F3A7}'},
    'interest0033': {'name': '발라드', 'icon': '\u{1F4BD}'},
    'interest0034': {'name': '영화', 'icon': '\u{1F3A5}'},
    'interest0035': {'name': '드라마', 'icon': '\u{1F4FA}'},

    ///
    'interest0036': {'name': '스트릿댄스', 'icon': '\u{1F483}'},
    'interest0037': {'name': '1일1코노', 'icon': '\u{1F3A4}'},
    'interest0038': {'name': '다꾸', 'icon': '\u{1F4D2}'},
    'interest0039': {'name': '바디프로필', 'icon': '\u{1F386}'},
    'interest0040': {'name': '아이돌', 'icon': '\u{2B50}'},

    ///
    'interest0041': {'name': '학점관리', 'icon': '\u{26EA}'},
    'interest0042': {'name': '봉사활동', 'icon': '\u{1F30D}'},
    'interest0043': {'name': '코딩', 'icon': '\u{1F4BB}'},
    'interest0044': {'name': '브이로그', 'icon': '\u{1F35C}'},
    'interest0045': {'name': '냥집사', 'icon': '\u{1F431}'},

    ///
    'interest0046': {'name': '대외활동', 'icon': '\u{1F4CC}'},
    'interest0047': {'name': '다이어트', 'icon': '\u{1F360}'},
    'interest0048': {'name': '댕댕이', 'icon': '\u{1F436}'},
    'interest0049': {'name': '반려동물', 'icon': '\u{1F380}'},
    'interest0050': {'name': 'LoL(롤)', 'icon': '\u{1F3AE}'},

    ///
    'interest0051': {'name': '꾸안꾸', 'icon': '\u{1F455}'},
    'interest0052': {'name': 'EPL/축구', 'icon': '\u{26BD}'},
    'interest0053': {'name': '배그', 'icon': '\u{1F52B}'},
    'interest0054': {'name': '반려식물', 'icon': '\u{1F331}'},
    'interest0055': {'name': '메이플', 'icon': '\u{1F3AE}'},

    ///
    'interest0056': {'name': '서든어택', 'icon': '\u{1F52B}'},
    'interest0057': {'name': '로스트아크', 'icon': '\u{1F3AE}'},
    'interest0058': {'name': '피파온라인4', 'icon': '\u{1F3AE}'},
    'interest0059': {'name': '산책', 'icon': '\u{1F3C3}'},
    'interest0060': {'name': '요리왕', 'icon': '\u{1F372}'},

    ///
    'interest0061': {'name': '학생회', 'icon': '\u{1F64B}'},
    'interest0062': {'name': '자발적아싸', 'icon': '\u{1F6B6}'},
    'interest0063': {'name': '미술/예술', 'icon': '\u{1F3A8}'},
    'interest0064': {'name': '필라테스', 'icon': '\u{1F3BD}'},
  };
}

class RoutineProduct {
  const RoutineProduct(this.name, this.category, this.description);

  final String name;
  final String category;
  final String description;
}

const routineProducts = <RoutineProduct>[
  RoutineProduct('MISSHA 타임 레볼루션', '앰플', '영양·재생 집중 케어'),
  RoutineProduct("Paula's Choice BHA 2%", '세럼', '피지·각질 케어'),
  RoutineProduct('The Ordinary 나이아신아마이드 10%', '세럼', '모공·피지 개선'),
  RoutineProduct('COSRX AHA/BHA 클라리파잉', '토너', '각질·피지 케어'),
  RoutineProduct('Klairs 저자극 무향 토너', '토너', '수분 공급, pH 조절'),
  RoutineProduct('COSRX 오일-프리 클렌저', '클렌저', '약산성, 피지 조절'),
  RoutineProduct('Laneige 워터뱅크 블루 HA', '크림', '보습 마무리'),
];

const finalRoutineProducts = <RoutineProduct>[
  RoutineProduct('COSRX 오일-프리 클렌저', '클렌저', ''),
  RoutineProduct('Klairs 저자극 무향 토너', '토너', ''),
  RoutineProduct('The Ordinary 나이아신아마이드 10%', '세럼', ''),
  RoutineProduct('AAC 세이프 BHA 세럼', '세럼', 'AAC 추천'),
  RoutineProduct('Anessa 퍼펙트 UV', '선크림', ''),
];

const productCategories = <String>[
  '클렌징폼/젤',
  '클렌징오일/밤',
  '필링&스크럽',
  '클렌징워터/밀크',
  '스킨/토너',
  '에센스/세럼/앰플',
  '로션',
  '미스트/오일',
];

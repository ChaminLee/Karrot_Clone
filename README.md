# 당근마켓 iOS 클론앱


## 요약


|Index|Detail|
|------|---|
|구현 기간| **2021.07.15 ~ 2021.07.22**|
|구현 목표 | [홈]  <br> - 메인 화면 <br> - 1 depth 상품뷰 | 
|실제 구현 기능|**[홈]** <br> - 메인뷰 <br> - 지역 선택 <br> - 게시글 추가 <br> <br> **[상품 뷰]** <br> - 이미지 슬라이더 <br>- 공유 버튼 <br> - 더보기 버튼 <br> - 하단 메뉴바 <br> - 매너온도 팝업 <br> - 매너온도 프로그레스바|
|기술 스택|- UIKit <br> - SnapKit|
|Pain Point|1. 여러 애니메이션들과 다양한 뷰를 구현하는 부분 <br> 2. 생각보다 다양한 기능 및 화면 구현의 어려움|
|해결 방법|1. 라이브러리 없이 여러 애니메이션 방식에 대해 학습하고 적용해봤습니다. 플로팅 버튼을 띄우는 부분이나 커스텀한 팝 오버를 하는 경우 다양한 오픈 소스들을 활용하여 쉽게 구현할 수 있었으나, 그저 오픈 소스를 가져다 사용하는 것 보다는 직접 구현해보는게 좋을 것이라고 생각했습니다. 그렇게 공식문서나 스택오버플로우 등 검색과 기존 개발 경험을 뒷받침하여 유사하게 기능을 구현했습니다. 그 덕분에 다양한 애니메이션 방법, 커스텀뷰에 대해 공부하고 더 관심을 갖는 계기가 되었습니다. 또한 raw한 것을 경험해보니 라이브러리들이 대략 어떻게 구성되어있고, 동작원리는 어떠한지 파악이 조금이나마 가능해져서 원리를 기반으로 바라보는 시야를 가질 수 있었습니다. <br><br> 2. 복잡한 구조의 앱을 이해하고자 서비스를 세밀하게 살펴보고 다양한 기능들을 직접 활용해봄으로써 서비스를 이해했습니다. 사용자의 라이프사이클을 모두 구현해보고 싶었으나 그러기에는 리소스가 부족했으며, 이에 일부 화면만 선택하여 구현하였습니다. 더 복잡한 구조로 구성되어있다는 것을 알지만, 샘플 데이터를 구성해보며 대략적인 데이터 구조를 알아볼 수 있었습니다. |
|아쉬운점 <br>& 느낀점|1. 구현 시간이 모자랐던 것이 가장 아쉽습니다. 하지만 과제시간이 아닌 그 이후 시간은 더 있으니 DB연동이나 뒷단의 데이터 흐름 + 화면/애니메이션을 보충해야겠다는 생각을 하고 있습니다. <br> <br> 2. 1주일 가량 당근마켓 서비스 클론만을 위해 시간을 투자했는데, 정말 즐거웠던 시간이었습니다. 하루종일 개선안이나 구현 방법에 대해 의문을 갖고 계속 개발을 진행했던 기억이 나고, 너무나 좋은 경험이었다는 생각이 듭니다. 여기서 멈추지 않고 여러 기능들을 덧붙여볼 생각입니다. |
|*Suggestion|**[당근마켓 다크모드]** <br> iOS13 이후 다크모드를 지원하면서 수많은 유저들이 다크모드를 사용하고 있습니다. 이에 다른 수많은 서비스들도 다크모드에 대응하고 있습니다. 이러한 배경과 함께 다크모드를 애용하는 한 명의 사용자로서, 당근마켓을 다크모드로 구현해보면 어떨까? 하는 생각으로 시도해보았습니다.|

## 개선 및 기능 추가

|Index|Detail|
|------|---|
|구현 기간| **2021.07.23~**|
|구현 내용| - 지역 선택시 토스트 메시지 보이도록 <br> - 지역선택시 화살표 rotate 애니메이션 개선 <br> - 데이터 모델 구조 개선 <br> - 글쓰기 플로팅 버튼 개선 <br> - 상품 뷰 내 유저의 다른 상품/추천 상품 간 마진 개선 <br> - Firebase Realtime Database 연동 <br> - 카테고리 컬렉션/테이블뷰 추가 <br> - 버튼 개선(카테고리, 매너온도, 가격제안하기) <br> - 카테고리 뷰(홈/상품뷰) > 상품 뷰 연결 <br> - 홈으로 가기 버튼 추가 <br> - 상품 뷰 상단 dimmed 추가 <br> - 유저상품 & 추천상품 > 상품 뷰 연결|


-------------

# 구현 결과

(*시뮬레이터로 기록하여 조금의 딜레이가 있습니다.*)
## Light Mode
|런치스크린|홈|지역 버튼 클릭|
|:----:|:----:|:----:|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/launch.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/Home.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/Location.gif" width="300">|
|글쓰기 버튼|새로고침|상품 뷰|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/Add.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/update.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/prod.gif" width="300">|
|상품 뷰 이동|상품 이미지 슬라이더|네비게이션 컬러 변경|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/move.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/slide.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/colorChange.gif" width="300">|
|매너 온도 팝업| 하단 관심버튼 클릭|상품 뷰 > 카테고리 이동|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/manner.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/heart.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/category.gif" width="300">|
|홈 > 카테고리 이동|||
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/homeCategory.gif" width="300">|||

## Dark Mode
|런치스크린|홈|지역 버튼 클릭|
|:----:|:----:|:----:|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/launch.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/Home.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/Location.gif" width="300">|
|글쓰기 버튼|새로고침|상품 뷰|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/Add.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/reload.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/prod.gif" width="300">|
|상품 뷰 이동|상품 이미지 슬라이더|네비게이션 컬러 변경|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/move.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/slide.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/color.gif" width="300">|
|매너 온도 팝업| 하단 관심버튼 클릭|상품 뷰 > 카테고리 이동|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/manner.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/heart.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/category.gif" width="300">|
|홈 > 카테고리 이동|||
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/category2.gif" width="300">|||

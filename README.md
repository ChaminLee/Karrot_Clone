# 당근마켓 iOS 클론앱


## 요약


|Index|Detail|
|------|---|
|구현 기간| **2021.07.15 ~ 2021.07.22**|
|구현 목표 | [홈]  <br> - 메인 화면 <br> - 1 depth 상품뷰 | 
|실제 구현 기능|**[홈]** <br> - 메인뷰 <br> - 지역 선택 <br> - 게시글 추가 <br> <br> **[상품 뷰]** <br> - 이미지 슬라이더 <br>- 공유 버튼 <br> - 더보기 버튼 <br> - 하단 메뉴바 <br> - 매너온도 팝업 <br> - 매너온도 프로그레스바|
|기술 스택|- UIKit <br> - SnapKit|
|Pain Point|1. 여러 커스텀한 애니메이션과 뷰들을 구현하는 부분 <br> 2. 생각보다 다양한 기능 및 화면의 존재|
|: Overcome!|1. 라이브러리 없이 애니메이션 방식을 학습하고 적용해봤다. 다양한 애니메이션 방법에 대해 공부하고 더 관심을 갖는 계기가 되었다. <br> 2. 복잡한 구조의 앱을 이해하고자 서비스를 세밀하게 살펴보고 다양한 기능들을 직접 활용해봄으로써 서비스를 이해했다. 일부 샘플 데이터를 통해 대략적인 데이터 구조를 바라볼 수 있었다. |
|아쉬운점 <br>& 느낀점|1. 시간이 모자랐던 것. 하지만 시간은 더 있으니 DB연동이나 뒷단의 데이터 흐름 + 화면/애니메이션을 보충해야겠다. <br> <br> 2. 1주일 가량 당근마켓 서비스 클론만을 위해 시간을 투자했는데, 정말 즐거웠던 시간이었다. 하루종일 개선안이나 구현 방법에 대해 의문을 갖고 계속 개발을 진행했던 기억이 나고, 너무나 좋은 경험이었다는 생각이 든다. 여기서 멈추지 않고 여러 기능들을 덧붙여볼 생각이다. |
|*Suggestion|**[당근마켓 다크모드]** <br> iOS13 이후 다크모드가 가능해지면서 수많은 유저들이 다크모드를 사용하고 있다. 이에 수많은 서비스들도 다크모드에 대응하여 사용성을 높이고 있는 상황이다. 이러한 배경과 함께 다크모드를 애용하는 한 명의 사용자로서, 당근마켓을 다크모드로 구현해보면 어떨까? 하는 생각으로 시도해보았다.|


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
|매너 온도 팝업| 하단 관심버튼 클릭||
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/manner.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Light/heart.gif" width="300">||

## Dark Mode
|런치스크린|홈|지역 버튼 클릭|
|:----:|:----:|:----:|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/launch.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/Home.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/Location.gif" width="300">|
|글쓰기 버튼|새로고침|상품 뷰|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/Add.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/reload.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/prod.gif" width="300">|
|상품 뷰 이동|상품 이미지 슬라이더|네비게이션 컬러 변경|
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/move.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/slide.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/color.gif" width="300">|
|매너 온도 팝업| 하단 관심버튼 클릭||
|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/manner.gif" width="300">|<img src="https://github.com/ChaminLee/Karrot_Clone/blob/master/samples/Dark/heart.gif" width="300">||

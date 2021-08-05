# 당근마켓 iOS-App 클론

## 목차 
- [요약](#요약)
- [구현 결과](#구현-결과)
- [개선 및 기능 추가](#개선-및-기능-추가)
- [트러블 슈팅](#트러블-슈팅)
- [학습한 내용](#학습한-내용)


## 요약


|Index|Detail|
|------|---|
|구현 기간| **2021.07.15 ~ 2021.07.22**|
|구현 목표 | [홈]  <br> - 메인 화면 <br> - 1 depth 상품뷰 | 
|실제 구현 기능|**[홈]** <br> - 메인뷰 <br> - 지역 선택 <br> - 게시글 추가 <br> <br> **[상품 뷰]** <br> - 이미지 슬라이더 <br>- 공유 버튼 <br> - 더보기 버튼 <br> - 하단 메뉴바 <br> - 매너온도 팝업 <br> - 매너온도 프로그레스바|
|기술 스택|- UIKit <br> - SnapKit|
|Pain Point|1. 여러 애니메이션들과 다양한 뷰를 구현하는 부분 <br> 2. 다양한 기능 및 복잡한 구조|
|해결 방법|1. 라이브러리 없이 여러 애니메이션 방식에 대해 학습하고 적용해봤습니다. 플로팅 버튼을 띄우는 부분이나 커스텀한 팝 오버를 하는 경우 다양한 오픈 소스들을 활용하여 쉽게 구현할 수 있었으나, 그저 오픈 소스를 가져다 사용하는 것 보다는 직접 구현해보는게 좋을 것이라고 생각했습니다. 그렇게 공식문서나 스택오버플로우 등 검색과 기존 개발 경험을 뒷받침하여 유사하게 기능을 구현했습니다. 그 덕분에 다양한 애니메이션 방법, 커스텀뷰에 대해 공부하고 더 관심을 갖는 계기가 되었습니다. 또한 raw한 것을 경험해보니 라이브러리들이 대략 어떻게 구성되어있고, 동작원리는 어떠한지 파악이 조금이나마 가능해져서 원리를 기반으로 바라보는 시야를 가질 수 있었습니다. <br><br> 2. 복잡한 구조의 앱을 이해하고자 서비스를 세밀하게 살펴보고 다양한 기능들을 직접 활용해봄으로써 서비스를 이해했습니다. 사용자의 라이프사이클을 모두 구현해보고 싶었으나 그러기에는 리소스가 부족했으며, 이에 일부 화면만 선택하여 구현하였습니다. 더 복잡한 구조로 구성되어있다는 것을 알지만, 샘플 데이터를 구성해보며 대략적으로 데이터 구조에 대해 알아볼 수 있었습니다. |
|아쉬운점 <br>& 느낀점|1. 구현 시간이 모자랐던 것이 가장 아쉽습니다. 하지만 과제시간이 아닌 그 이후 시간은 더 있으니 DB연동이나 뒷단의 데이터 흐름 + 화면/애니메이션을 보충해야겠다는 생각을 하고 있습니다. <br> <br> 2. 1주일 가량 당근마켓 서비스 클론만을 위해 시간을 투자했는데, 정말 즐거웠던 시간이었습니다. 하루종일 개선안이나 구현 방법에 대해 의문을 갖고 계속 개발을 진행했던 기억이 나고, 너무나 좋은 경험이었다는 생각이 듭니다. 여기서 멈추지 않고 여러 기능들을 덧붙여볼 생각입니다. <br> <br> 3. 혼자 작업함에도 branch를 따고 실제 협업하는 것 처럼 진행하지 못했던 점이 아쉽습니다. add-commit-push만 하는게 아니라 기능별 feature 브랜치를 만들어 작업했다면 더 체계적으로 관리할 수 있었을 것 같습니다. 이 부분은 추후 스스로 개선해보고자 합니다. |
|*Suggestion|**[당근마켓 다크모드]** <br> iOS13 이후 다크모드를 지원하면서 수많은 유저들이 다크모드를 사용하고 있습니다. 이에 다른 수많은 서비스들도 다크모드에 대응하고 있습니다. 이러한 배경과 함께 다크모드를 애용하는 한 명의 사용자로서, 당근마켓을 다크모드로 구현해보면 어떨까? 하는 생각으로 시도해보았습니다.|


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

## 개선 및 기능 추가

|Index|Detail|
|------|---|
|구현 기간| **2021.07.23~**|
|구현 내용| - 지역 선택시 토스트 메시지 보이도록 <br> - 지역선택시 화살표 rotate 애니메이션 개선 <br> - 데이터 모델 구조 개선 <br> - 글쓰기 플로팅 버튼 개선 <br> - 상품 뷰 내 유저의 다른 상품/추천 상품 간 마진 개선 <br> - Firebase Realtime Database 연동 <br> - 카테고리 컬렉션/테이블뷰 추가 및 연결 <br> - 버튼 개선(카테고리, 매너온도, 가격제안하기)  <br> - 홈으로 가기 버튼 추가 <br> - 상품 뷰 상/하단 dimmed view추가 <br> - 유저상품 & 추천상품 > 상품 뷰 연결|


## 트러블 슈팅

### Home - 화살표 rotate 애니메이션
- 문제 상황
	- 한 번 클릭 후, 뷰가 내려갔을 때 다시 rotate 되지 않는다.
- 해결 방법
	- NotificatoinCenter를 통해 이벤트를 전달하여 해결

### Firebase Realtime Database setting & data fetch
- 문제 상황 
	- 응답받는 데이터의 개수에 따라 구조가 다르게 들어오고 있음 ( 1개인 경우, 초과의 경우 )
- 해결 방법
	- 케이스에 맞게 다르게 다운캐스팅 해주어 data fetch

### 글쓰기 플로팅 버튼 dimmed view
- 문제 상황 
	- view에 추가하니 NavigationController와 TabbarController를 가리지 못함
- 해결 방법
	- window 레벨에서 추가해주어 dimmed view 적용
		- dimmed view 터치시 플로팅바 내리는 것 미구현!

## 학습한 내용
 
#### 1. ViewController간 이벤트를 주고 받는 방법 - Delegate, NotificationCenter

> Delegate와 Notification을 활용한 객체 간 통신
- [VC간 데이터를 주고받는 방법(Delegate, Closure)](https://leechamin.tistory.com/500)
- [NotificationCenter를 활용한 액션 전달방법](https://leechamin.tistory.com/505)

#### 2. GCD
> 비동기/동기 수행을 원할 때, thread pool을 관리해주는 GCD를 사용한다. 
> - main queue : UI 관련한 코드는 main에서 실행되어야 한다. 
> - 네트워크 통신이 필요한 다소 무게가 있는 작업은 background queue에서 실행되는 것이 권장된다. 
> -> UI가 다른 일을 하는 동안, 무거운 작업을 뒤에서 할 수 있다. 




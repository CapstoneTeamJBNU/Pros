import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/time_table.dart';
/// 사용자 기초 데이터 : 학과, 학년에 대한 입력
/// 초기 강의 투입 고정 -> 학년, 학과를 기준으로 전공 필수 과목 추가
/// 이후 사용자 선호도에 따라 작업을 수행함
/// 사용자 선호도 기본 설정은 모두 균형있게 설정
/// 사용자 선호도 :
/// 1. 거리 : 도보기준 5분 이내 건물들만 선택.
///          건물별 좌표값 대입 - 강의실 기준 호관, 호관 없을시 스페이스바 기준으로 split, 이후 건물 벡터를 정확히 주소지 기입해서 TMAP API로 거리 계산
/// 2. 시간 : 오전 기피? 요일 기피?
///          오전 - 8~12시, 오후 - 1~6시, 저녁 - 7~10시
///          공강 요일 - > 시간. 필드에서 특정 요일 들어간 문자열은 가중치 계산때 극한으로 넣어버리자...
/// 3. 평점 : 평점순도 고려 + 평가코멘트 긍정률 고려
///          평점, 평가코멘트는 에타에서 부분 수동 추출 -> 긍정률 분석은 BERT를 삽입해야 할거 같은데...
/// 4. 이수구분 : 전공선택, 교양(필수 교양은 어쩜? = 필수 교양도 전공 필수처럼 학년에 지정되 있을 경우 강제화하는 방향으로), 일반선택
///          UI 구성 계획안 : 계층 테이블식으로 드래그앤 드랍 조작 수행 같은 계층일 경우 순위 동일하게 설정
/// 드래그앤 드랍 조작 UI
/// - 요소별 값 조절 방식 -
/// 1. 슬라이더 : 가중치 요소의 중요도 조절
/// 2. 계층형 테이블 : 이수구분별 우선순위 조절
/// 3. 콤보 박스 : 특정 요일 제외
class SelectionSheet extends StatefulWidget {
  const SelectionSheet({super.key});

  @override
  State<SelectionSheet> createState() =>
      _SelectionSheetState();
}

class _SelectionSheetState extends State<SelectionSheet> {
  final Map<dynamic,CustomSlider> _widgetList = {};
  final controller = ScrollController();
  double _sheetPosition = 0.5;
  final double minChildSize = 0.025;
  final double _dragSensitivity = 600;

  Widget _buildFab() {
    double top = 256.0 - 4.0; //default top margin, -4 for exact alignment
    if (controller.hasClients) {
      top -= controller.offset;
    }
    return Positioned(
      top: top,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    DraggableScrollableSheet scroll = DraggableScrollableSheet(
              initialChildSize: _sheetPosition,
              minChildSize: minChildSize,
              builder: (BuildContext context, controller) {
                return SizedBox(
                  child: Column(
                    children: <Widget>[
                      _buildFab(),
                      Grabber(
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            _sheetPosition -= details.delta.dy / _dragSensitivity;
                            if (_sheetPosition < minChildSize) {
                              _sheetPosition = minChildSize;
                            }
                            if (_sheetPosition > 1.0) {
                              _sheetPosition = 1.0;
                            }
                          });
                        },
                        isOnDesktopAndWeb: _isOnDesktopAndWeb,
                      ),
                      Flexible(
                        child: ColoredBox(
                          color: colorScheme.primary,
                          child: ListView.builder(
                            controller: _isOnDesktopAndWeb ? null : controller,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              dynamic item;
                              item = ListTile(
                                title: Text(
                                  'Item $index',
                                  style: TextStyle(color: colorScheme.surface),
                                ),
                                onTap: () => Null,
                              );
                              return item;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade100),
      ),
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const TimeTable()),
        //     );
        //   }
        // ),
        
        // body: Stack(
        //   children: [
        //     const Text('This is the main content area'),
        //     ..._widgetList.values,
        //     scroll,
        //   ],
        // ),

        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverAppBar(
                  expandedHeight: 256.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text("SliverFab Example"),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(200, (index) => Text('Item $index'))
                  ),
                ),
              ],
            ),
            Positioned(child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimeTable()),
                );
              },
            )),
          ],
        )
      ),
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

/// A draggable widget that accepts vertical drag gestures
/// and this is only visible on desktop and web platforms.
class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: colorScheme.onSurface,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});
  static void toggleVisibility(BuildContext context) {
      _CustomSliderState? state = context.findAncestorStateOfType<_CustomSliderState>();
      state!.toggleVisibility();
  }

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _value = 0.5;
  bool visibleSwitch = true;

  @override
  Widget build(BuildContext context) {
    Visibility item = Visibility(
      visible: visibleSwitch,
      child: Slider(
        value: _value,
        onChanged: (double value) {
          setState(() {
            _value = value;
          });
        },
      ),
    );
    toggleVisibility();
    return item;
  }

  void toggleVisibility() {
    setState(() {
      visibleSwitch = !visibleSwitch;
    });
  }
}

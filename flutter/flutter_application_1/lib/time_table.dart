import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/lecture_analysis.dart';
import 'package:logger/web.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_application_1/firestore_lecture_listview.dart';

import 'account.dart';
import 'lecture.dart';

class TimeTable extends StatelessWidget {
  final Account account;
  const TimeTable(this.account, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('수업 시간표'),
        ),
        body: Container(
          margin: const EdgeInsets.all(20), // 외부 여백 추가
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // 테두리 추가
          ),
          child: ScheduleTable(account),
        ),
      ),
    );
  }
}

class ScheduleTable extends StatefulWidget {
  const ScheduleTable(Account account,{super.key});
  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  /* 테이블 UI 변수 */
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 55; // kBoxSize 변수의 값을 줄임
  double kButtonWidth = 163; // 버튼의 가로 크기를 조절할 수 있는 변수

  /* 파이어베이스 데이터 참조용 변수들 */
  late List<Lecture> lectureList;

  Future<void> initLectureList() async {
    List<Lecture> result = [];

    /* 스터브들 */
    const String defaultDirectory = 'UNIV_LIST';
    const String accountCollection = 'ACCOUNT_INFO';
    const String accountId = '3naGNQCcm3SVumZY2HTe';
    const String docTag = '2024_0';
    const String lectureBasket = 'LECTURE_BASKET';
    const String identifier = 'JBNU';
    const String lectureCollection = 'OPEN_LECTURE_2024_0';

    var logger = Logger();
    try{
      DocumentSnapshot basketQuery = await FirebaseFirestore.instance.collection(accountCollection)
      .doc(accountId)
      .collection(lectureBasket)
      .doc(docTag)
      .get();
      List<String?>? documentData = (basketQuery.data() as Map<String, dynamic>?)?.values.toList().cast<String>();

      for (int i = 0; i < documentData!.length; i++) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection(defaultDirectory)
          .doc(identifier)
          .collection(lectureCollection)
          .doc(documentData[i])
          .get();
        result.add(Lecture.fromFirestore(doc));
        // logger.i('${result[i].lectureId} ${result[i].properties["과목명"]} ${result[i].properties["시간"]}');
      }
    }
    catch(e){
      logger.e(e);
    }
    lectureList = result;
  }

  @override
  void initState() {
    super.initState();
    // initLectureList();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  /* 새 코드 */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initLectureList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중일 때 표시할 위젯
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 오류가 발생했을 때 표시할 위젯
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: kColumnLength / 2 * kBoxSize + kColumnLength,
                  child: Row(
                    children: [
                      buildTimeColumn(),
                      for (var i = 0; i < week.length; i++) ...buildDayColumn(i)
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Expanded buildTimeColumn() {

    /* 테스트용 로컬 데이터 */
    // lectureList = [
    //     Lecture(
    //   '교양','50','50','50',
    //   '공개','','공업수학','2',
    //   '1','3','3','최영하',
    //   '한국어','','','상대평가Ⅰ',
    //   '','일반','전체(학부)','일반',
    //   '전주:공과대학 4호관 401-1','월 6-A,월 6-B,월 7-A,월 7-B,수 8-A,수 8-B','','50분',
    //   '강의계획서'
    // ),
    // Lecture(
    //   '교양','50','50','50',
    //   '공개','','(KNU10)한옥개론','2',
    //   '1','3','3','최영하',
    //   '한국어','','','상대평가Ⅰ',
    //   '','일반','전체(학부)','일반',
    //   '전주:공과대학 4호관 401-1','월 1-A,월 1-B,월 2-A,월 2-B,수 7-A,수 7-B','','50분',
    //   '강의계획서'
    // ),
    // Lecture(
    //   '교양','50','50','50',
    //   '공개','','캡스톤디자인','2',
    //   '1','3','3','최영하',
    //   '한국어','','','상대평가Ⅰ',
    //   '','일반','전체(학부)','일반',
    //   '전주:공과대학 4호관 401-1','화 6-A, 화 6-B, 화 7-A,화 7-B, 목 7-A,목 7-B','','50분',
    //   '강의계획서'
    // ),
    // ];

    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              // 각 행에 시간 표시
              int hour = 8 + (index ~/ 2); // 8부터 시작하여 1시간 간격으로 증가
              // if (hour > 18) return const SizedBox.shrink(); // 18:00 이후에는 빈 공간을 반환
              return SizedBox(
                height: kBoxSize,
                child: Center(
                  child: Text(hour.toString().padLeft(2, '0')), // 시간을 텍스트로 표시
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    late List lectureDate = [];
    late String date;
    RandomColor randomColor = RandomColor();
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    // 요일 인자
                    date = week.elementAt(index),
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    // 19:00 이후의 빈칸을 삭제
                    if (index ~/ 2 > 18) {
                      return const SizedBox.shrink();
                    } else{
                      // 과목 시간대 중복일 시, 충돌 이벤트 처리 필수 - 여기 수준에서 진행될 것인지, 강의 변경 화면에서 진행할 것인지에 대한 논의
                      // 리스트의 전역변수화? 아니면 별도의 스테이지가 있어야 하는가?
                      lectureDate = List.generate(lectureList.length, (i) => {
                        lectureList[i].properties["과목명"] : (
                          lectureList[i].properties["시간"]?.split(',') ?? []
                          ).map((time) => time.split('-').first).toList()
                        }
                        );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: lectureDate.any((element) => element.values.first.contains('$date ${index ~/ 2}'))
                            ? randomColor.randomColor(
                            colorHue: ColorHue.multiple(colorHues: [ColorHue.blue, ColorHue.green, ColorHue.purple]))// 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
                            : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: (){
                            lectureDate.any((element) => element.values.first.contains('$date ${index ~/ 2}'))
                            ? showDialogExist(context)
                            : showDialogNotExist(context);
                          },
                          child : Text(
                            lectureDate.any((element) => element.values.first.contains('$date ${index ~/ 2}'))
                            ? '${lectureDate.firstWhere((element) => element.values.first.contains('$date ${index ~/ 2}')
                            ).keys.first}' // 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
                            : '' // 값이 매칭되지 않을 때의 텍스트
                          ),
                        )
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }
}
extension FirstWhereOrNullExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
void showDialogExist(context){
  showDialog(
    context: context,
    barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
    builder: ((context) {
      return AlertDialog(
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            Align(
              child: TextButton(
                onPressed: () {
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                ),
                child: const Text("삭제")
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Align(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); //창 닫기
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                ),
                child: const Text("X")
              ),
            ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7, // 화면 너비의 70%
                height: MediaQuery.of(context).size.height * 0.7, // 화면 높이의 70%
                child: const PieChart(),
              ),
              const SizedBox(
                child:Text('강의 평가 내용 수록용\n임시 영역')
              )
            ],
          ),
          ],
        );
      }
    )
  );  
}

void showDialogNotExist(context){
  showDialog(
    context: context,
    barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
    builder: ((context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); //창 닫기
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                ),
                child: const Text("X")
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text("과목 없는 곳"),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("교양"),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      showNormalLectureList(context);
                    },
                    child: const Text("일선"),
                  ),
                ],
              ),
            ),
          ],
        ),
        );
      }
    )
  );  
}
void showNormalLectureList(context){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: ((context) {
      return const AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: LectureList(),
        ),
        );
    })
  );
}

void showLiberalArtLectureList(){

}
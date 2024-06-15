import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/lecture_analysis.dart';
import 'package:logger/web.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_application_1/firestore_lecture_listview.dart';
import 'lecture.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});
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
          child: const ScheduleTable(),
        ),
      ),
    );
  }
}

class ScheduleTable extends StatefulWidget {
  const ScheduleTable({super.key});
  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  /* 테이블 UI 변수 */
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  var kColumnLength = 22;
  var maxTime = 11;
  var maxDay = 5;
  var logger = Logger();

  double kFirstColumnHeight = 20;
  double kBoxSize = 55; // kBoxSize 변수의 값을 줄임
  double kButtonWidth = 163; // 버튼의 가로 크기를 조절할 수 있는 변수
  /* 스터브들 */
  late final DocumentReference basketRef;

  /* 파이어베이스 데이터 참조용 변수들 */
  late List<Lecture> lectureList;

  Future<void> initLectureList() async {
    try{
      const String defaultDirectory = 'UNIV_LIST';
      const String accountCollection = 'ACCOUNT_INFO';
      const String accountId = '3naGNQCcm3SVumZY2HTe';
      const String docTag = '2024_0';
      const String lectureBasket = 'LECTURE_BASKET';
      const String identifier = 'JBNU';
      const String lectureCollection = 'OPEN_LECTURE_2024_0';
      basketRef = FirebaseFirestore.instance.collection(accountCollection)
      .doc(accountId)
      .collection(lectureBasket)
      .doc(docTag);
      DocumentSnapshot basket = await basketRef.get();
      List<String?>? documentData = (basket.data() as Map<String, dynamic>?)?.keys.toList().cast<String>();
      lectureList = [];
      for (int i = 0; i < documentData!.length; i++) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection(defaultDirectory)
          .doc(identifier)
          .collection(lectureCollection)
          .doc(documentData[i])
          .get();
        Lecture lecture = Lecture.fromFirestore(doc);
        List<String> schedule = lecture.properties["시간"]!.split(',');
        // maxTime = int.parse(lecture.properties["시간"]!.split('-')[0].split(' ')[1]) > maxTime ? int.parse(lecture.properties["시간"]!) : maxTime;
        // maxDay = week.indexOf(lecture.properties["시간"].last!.split(" ")[0]) > maxDay ? week.indexOf(lecture.properties["시간"]!.split(" ")[0]) : maxDay;
        lectureList.add(lecture);
        logger.i('${lecture.lectureId} ${lecture.properties["과목명"]} ${lecture.properties["시간"]}');
      }
    }
    catch(e){
      logger.e(e);
    }
  }

  @override
  void initState() {
    super.initState();
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
          // for (var i = 0; i < lectureList.length; i++) {
          //   String day = week.sublist(3, week.length).where(
          //       (day) => lectureList[i].properties["시간"]!.contains(day)
          //     ).last.split(" ")[0];
          //   maxDay = week.indexOf(day);
          // }
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
                      // 목요일까지가 최소, 금요일부터는 강의 리스트에 있을 시 표시
                      for (var i = 0; i < maxDay; i++) ...buildDayColumn(i)
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
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            maxTime*2 + 1,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              // 각 행에 시간 표시
              int hour = 8 + (index ~/ 2); // 8부터 시작하여 1시간 간격으로 증가
              // if (만약 과목 리스트에 8과 17시 이상이 없으면) return const SizedBox.shrink(); // 18:00 이후에는 빈 공간을 반환
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
                    // if (index ~/ 2 > 18) {
                      // return const SizedBox.shrink();
                    // } else{
                      // 과목 시간대 중복일 시, 충돌 이벤트 처리 필수 - 여기 수준에서 진행될 것인지, 강의 변경 화면에서 진행할 것인지에 대한 논의
                      // lectureList.firstWhereOrNull((element) => element.properties["시간"]!.contains('$date ${index ~/ 2}'));
                    // }
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color:
                            lectureList.any((element)=>element.properties["시간"]!.contains('$date ${index ~/ 2}'))
                            ? randomColor.randomColor(
                            colorHue: ColorHue.multiple(colorHues: [ColorHue.blue, ColorHue.green, ColorHue.purple]))// 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
                            : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: (){
                            lectureList.any((element) => element.properties['시간']!.contains('$date ${index ~/ 2}'))
                            ? showDialogExist(
                              lectureList.firstWhere(
                                (element) => element.properties["시간"]!.contains('$date ${index ~/ 2}')))
                            : showDialogNotExist();
                          },
                          child : Text(
                            lectureList.any((element) => element.properties["시간"]!.contains('$date ${index ~/ 2}'))
                            ? '${
                              lectureList.firstWhere((element) => element.properties[
                                "시간"]!.contains("$date ${index ~/ 2}")).properties["과목명"]}'//\n ${
                                //   lectureList.firstWhere((element) => element.properties[
                                // "시간"]!.contains('$date ${index ~/ 2}')).properties["담당교수"]
                                // }' // 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
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
  void showDialogExist(Lecture lecture){
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
                  // Remove the 'capital' field from the document
                  final updates = <String, dynamic>{
                    lecture.id : FieldValue.delete(),
                  };
                  basketRef.update(updates);
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
  void showDialogNotExist(){
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
                    minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)
                    ),
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
                          showNormalLectureList();
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
void showNormalLectureList(){
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
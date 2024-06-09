import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/lecture.dart';
import 'package:logger/web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  doAction();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('test'),
        ),
      ),
    );
  }
}
void doAction() async{

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
    Lecture lecture = Lecture();
    DocumentSnapshot basketQuery = await FirebaseFirestore.instance.collection(accountCollection)
    .doc(accountId)
    .collection(lectureBasket)
    .doc(docTag)
    .get();
    List<String?>? documentData = (basketQuery.data() as Map<String, dynamic>?)?.values.toList().cast<String>();

    List<Lecture> lectureList = [];
    for (int i = 0; i < documentData!.length; i++) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(defaultDirectory)
        .doc(identifier)
        .collection(lectureCollection)
        .doc(documentData[i])
        .get();
      // Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      // if (data != null) {
        // data.forEach((key, value) {
        //   logger.i('Field name: $key, Value: $value');
        // });
      // }
      lectureList.add(Lecture.fromFirestore(doc));
      logger.i('${lectureList[i].lectureId} ${lectureList[i].properties["과목명"]} ${lectureList[i].properties["시간"]}');
    }
  }
  catch(e){
    logger.e(e);
  }
  
}
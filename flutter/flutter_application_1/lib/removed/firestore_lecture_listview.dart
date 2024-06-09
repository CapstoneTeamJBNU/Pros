import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LectureList extends StatefulWidget {
  const LectureList({super.key});

  @override
  WidgetState createState() => WidgetState();
}

class WidgetState extends State<LectureList> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument;
  final List<DocumentSnapshot> _items = [];
  final univList = 'UNIV_LIST';
  final univId = 'JBNU';
  // string + year _ semester number
  final openLectureDirectory = 'OPEN_LECTURE_';
  final semester = 0;
  final lectureName = '과목명';

  @override
  void initState() {
    super.initState();
    _loadItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    Query query = _firestore.collection(univList).doc(univId)
    .collection('$openLectureDirectory${DateTime.now().year}_$semester').limit(20 );
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    final querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      setState(() {
        _items.addAll(querySnapshot.docs);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    Map<String, dynamic> getData(index){
      return _items[index].data() as Map<String, dynamic>;
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        var data = getData(index);
        return ExpansionTile(
          title: Text(data['과목명']),
          children: [...data.entries.where((entry) => entry
          .value.toString().trim().isNotEmpty).map((entry) {
            return ListTile(
              title: Text('${entry.key}: ${entry.value}')
            );
          }),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // 즐겨찾기 추가 - realtimefirebase 노테이션 서버단에서 수행이 필요한 부분.
            },
          ),
          ],
        );
      },
    );
  }
}
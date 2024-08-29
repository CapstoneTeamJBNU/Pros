

import 'package:RTT/lecture.dart';

class Account {

  // account name
  String name;
  // acount hash data
  String uid;
  // account info set
  bool infoSet;
  // account major
  String major;
  List<List<Lecture>> lectureSet = [];

  // Empty body
  Account(this.name, this.uid, {this.infoSet = false, this.major = '', this.lectureSet = const []});
}

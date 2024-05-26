class Lecture {
  final String title;
  final String timeSlot; // '수 7-A'와 같은 형태의 문자열을 저장합니다.
  final String teacher;
  final String room;

  Lecture(this.title, this.timeSlot, this.teacher, this.room);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Lecture &&
        other.title == title &&
        other.timeSlot == timeSlot &&
        other.teacher == teacher &&
        other.room == room;
  }

  @override
  int get hashCode => title.hashCode ^ timeSlot.hashCode;
}
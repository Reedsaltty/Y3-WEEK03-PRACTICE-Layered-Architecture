enum STATUS { DRAFT, PUBLISHED, CLOSED }

class Assignment {
  final String Id;
  final STATUS status;
  final String dueDate;
  final String openDate;
  final String courseId;
  // final String studentId;

  Assignment(
      {required this.Id,
      required this.status,
      required this.openDate,
      required this.dueDate,
      required this.courseId,
}) {}



@override
  String toString() {
    // TODO: implement toString
    return '''
      Assignment : ${status.name}
      Open : $openDate
      Close : $dueDate
      Course: $courseId

''';
  }
}

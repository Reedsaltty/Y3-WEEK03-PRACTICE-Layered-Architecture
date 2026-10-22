
class CourseResult {
  final String id;
  int score;
  final String studentId;
  final String courseId;
  final String assignmentId;

  CourseResult(
      {required this.id,
      required this.score,
      required this.studentId,
      required this.courseId,
      required this.assignmentId}) {}
}

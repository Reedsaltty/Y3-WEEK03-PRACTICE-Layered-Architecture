import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/student.dart';

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

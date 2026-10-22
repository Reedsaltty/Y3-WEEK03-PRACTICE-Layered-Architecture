import '../model/course.dart';
import '../model/student.dart';
import 'package:lms_layered_architecture_example/model/course_result.dart';
import 'package:lms_layered_architecture_example/model/assignment.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];
  final List<Assignment> assignments = [];

  LmsSystem();

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
    for (var course in courses) {
      if (course.studentIdList == studentId) {
        course.studentIdList.removeWhere((stu) => stu == studentId);
      }
    }
    results.removeWhere((res) => res.studentId == studentId);
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  }

  void enrollStudentToCourse(String studentId, String courseId) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    int i = courses.indexWhere((c) => c.id == courseId);
    if (courses[i].studentIdList.contains(studentId)) {
      throw Exception("Student with ID $studentId already enroll");
    }

    if (student == null) {
      throw Exception('Student $studentId is not exist');
    }
    if (course == null) {
      throw Exception('Course $courseId is not exist');
    }
    course.studentIdList.add(studentId);
  }

  void discardStudentFromCourse(String studentId, String courseId) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);

    if (student == null) {
      throw Exception('Student $studentId is not exist');
    }
    if (course == null) {
      throw Exception('Course $courseId is not exist');
    }
    if (!course.studentIdList.contains(studentId)) {
      throw Exception("Student with Id $studentId haven;t enroll yet");
    }
    course.studentIdList.removeWhere((s) => s == studentId);
  }

  void addScore(
      {required String studentId,
      required String courseId,
      required String assignmentId}) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    if (student == null) {
      throw Exception('Student $studentId is not exist');
    } else if (course == null) {
      throw Exception('Course $courseId is not exist');
    }
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  void addCourse(
      {required String courseId,
      required String courseName,
      List<Student> studentEnrolls = const []}) {
    Course? course = _findCourseOrNull(courseId);
    if (course != null) {
      throw Exception("Course with this $courseId already exist");
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  void deleteCourse({required String courseId}) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception("The course with the id:$courseId does not exist");
    }
    courses.removeWhere((course) => course.id == courseId);
  }

  CourseResult? _findResultOrNull(String resultId) {
    for (var result in results) {
      if (result.id == resultId) {
        return result;
      }
    }
    return null;
  }

  void addResult(
      {required String studentId,
      required String courseId,
      required String resultId,
      required String assignmentId,
      required int score}) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    int i = courses.indexWhere((c) => c.id == courseId);
    if (student == null) {
      throw Exception('Student $studentId is not exist');
    }
    if (course == null) {
      throw Exception('Course $courseId is not exist');
    }

    if (!courses[i].studentIdList.contains(studentId)) {
      throw Exception("Student is not enroll in course: ${course.name} ");
    }
    if (score < 0) {
      throw Exception("Score can not be negative");
    }
    CourseResult result = CourseResult(
        id: resultId,
        score: score,
        studentId: studentId,
        courseId: courseId,
        assignmentId: assignmentId);
    results.add(result);
  }

  void removeResult({required String resultId}) {
    CourseResult? result = _findResultOrNull(resultId);
    if (result == null) {
      throw Exception("Result with $resultId is not exist");
    }
    results.removeWhere((r) => r.id == resultId);
    print("Result$resultId : has been deleted");
  }

  Assignment? _findAssignmentOrNull(String assignmentId) {
    for (Assignment asm in assignments) {
      if (asm.Id == assignmentId) {
        return asm;
      }
    }
    return null;
  }

  bool isEnroll(String studentId, String courseId) {
    bool res = courses
        .any((c) => c.id == courseId && c.studentIdList.contains(studentId));
    return res;
  }

  void addAssignmentToCourse(
      {required String assignmentId,
      required String courseId,
      String? openDate,
      required String dueDate,
      STATUS status = STATUS.DRAFT,
      required}) {
    Course? course = _findCourseOrNull(courseId);
    Assignment? assignment = _findAssignmentOrNull(assignmentId);
    final now = DateTime.now().toString();
    if (assignment != null) {
      throw Exception("The assignment with the $assignmentId is already exist");
    }
    if (course == null) {
      throw Exception("The course with the id:$courseId does not exist");
    }
    Assignment newAssignment = Assignment(
        Id: assignmentId,
        status: status,
        openDate: openDate ?? now,
        dueDate: dueDate,
        courseId: courseId);

    assignments.add(newAssignment);
    course.assignments.add(newAssignment);
    for (var c in course.studentIdList) {
      int i = students.indexWhere((s) => s.id == c);
      students[i].assignments.add(newAssignment);
    }
  }

  List<Assignment> studentAssignment(String studentId) {
    Student? student = _findStudentOrNull(studentId);

    if (student == null) {
      throw Exception('Student $studentId is not exist');
    }

    int i = students.indexWhere((s) => s.id == studentId);

    return students[i].assignments;
  }
}

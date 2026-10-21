import '../model/course.dart';
import '../model/student.dart';
import 'package:lms_layered_architecture_example/model/course_result.dart';
import 'package:lms_layered_architecture_example/model/assignment.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];
  final List<Assignment> assignments =  [];

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
    if (student == null) {
      throw Exception('Student $studentId is not exist');
    } else if (course == null) {
      throw Exception('Course $courseId is not exist');
    }
    course.studentIdList.add(studentId);
  }

  void discardStudentFromCourse(String studentId, String courseId) {
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourseOrNull(courseId);
    if (student == null) {
      throw Exception('Student $studentId is not exist');
    } else if (course == null) {
      throw Exception('Course $courseId is not exist');
    }
    for (var stu in course.studentIdList) {
      if (stu == studentId) {
        course.studentIdList.removeWhere((s) => s == studentId);
      }
    }
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
    if (student == null) {
      throw Exception('Student $studentId is not exist');
    } else if (course == null) {
      throw Exception('Course $courseId is not exist');
    }
    CourseResult result = CourseResult(
        id: resultId, score: score, studentId: studentId, courseId: courseId, assignmentId:assignmentId );
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

  void addAssignmentToCourse({required String assignmentId,required String courseId,String? openDate,required String dueDate , STATUS status = STATUS.DRAFT, required }) {
    Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception("The course with the id:$courseId does not exist");
    }
    Assignment newAssignment = Assignment(assignmentId: assignmentId, status: , openDate: openDate, dueDate: dueDate, , courseId: courseId)
  }
}

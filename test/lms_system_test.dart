import 'dart:math';

import 'package:lms_layered_architecture_example/model/assignment.dart';
import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/student.dart';
import 'package:lms_layered_architecture_example/service/lms_system.dart';
import 'package:test/test.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  test('Add and remove a course', () {
    LmsSystem lms = LmsSystem();
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.deleteCourse(courseId: 'C1');

    expect(lms.courses.length, 0);
  });

  test('Reject a duplicate course ID', () {
    LmsSystem lms = LmsSystem();
    lms.addCourse(courseId: "C1", courseName: "CS");
    expect(
        () => lms.addCourse(courseId: "C1", courseName: "CS"), throwsException);
  });

  test('Reject removal of a nonexistent course.', () {
    LmsSystem lms = LmsSystem();
    expect(() => lms.deleteCourse(courseId: "C1"), throwsException);
  });
  test('Create an assignment for student within the given course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.enrollStudentToCourse("S1", "C1");
    lms.addAssignmentToCourse(
        assignmentId: "EEE",
        courseId: 'C1',
        dueDate: DateTime(2026, 10, 10).toString(),
        status: STATUS.PUBLISHED);
    expect(lms.studentAssignment("S1").length, 1);
  });
  test('Enroll an existing student in an existing course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.enrollStudentToCourse("S1", "C1");

    expect(lms.courses.first.studentIdList.length, 1);
  });

  test('Verify that the enrollment is recorded', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.enrollStudentToCourse("S1", "C1");

    expect(lms.courses.first.studentIdList.contains("S1"), true);
  });

  test('Reject enrollment if the student does not exist', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: "C1", courseName: "CS");
    expect(() => lms.enrollStudentToCourse("S1", "C1"), throwsException);
  });

  test('Reject enrollment if the course does not exist', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");

    expect(() => lms.enrollStudentToCourse("S1", "C1"), throwsException);
  });

  test('Reject duplicate enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.enrollStudentToCourse("S1", "C1");

    expect(() => lms.enrollStudentToCourse("S1", "C1"), throwsException);
  });

  test('Remove an existing enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.enrollStudentToCourse("S1", "C1");
    lms.discardStudentFromCourse("S1", "C1");
    expect(lms.courses.first.studentIdList.length, 0);
  });

  test('Reject removal of a nonexistent enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    expect(() => lms.discardStudentFromCourse("S1", "C1"), throwsException);
  });

  test(
      'Verify that the student and course still exist after the enrollment is removed',
      () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.enrollStudentToCourse("S1", 'C1');
    lms.discardStudentFromCourse("S1", "C1");
    expect(lms.courses.length, 1);
    expect(lms.students.length, 1);
  });

  test('Verify the chosen policy for associated results', () {});

  test('Test removing a student who has enrollments in multiple courses', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.addCourse(courseId: "C3", courseName: "CS");
    lms.addCourse(courseId: "C5", courseName: "CS");
    lms.addCourse(courseId: "C7", courseName: "CS");
    lms.enrollStudentToCourse("S1", 'C1');
    lms.enrollStudentToCourse("S1", 'C3');
    lms.enrollStudentToCourse("S1", 'C5');
    lms.enrollStudentToCourse("S1", 'C7');
    expect(lms.students.length, 1);
    lms.removeStudent(studentId: "S1");
    expect(lms.students.length, 0);
    int ic1 = lms.courses.indexWhere((c) => c.id == "C1");
    int ic3 = lms.courses.indexWhere((c) => c.id == "C1");

    expect(lms.courses[ic1].studentIdList.length, 1);
    expect(lms.courses[ic3].studentIdList.length, 1);
  });

  test('Add a valid result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: "S1", studentName: "Darwin");
    lms.addCourse(courseId: "C1", courseName: "CS");
    lms.addAssignmentToCourse(
        assignmentId: "A1", courseId: "C1", dueDate: "2026-10-10");
    lms.addResult(
        studentId: "S1",
        courseId: "C1",
        resultId: "R1",
        assignmentId: "A1",
        score: 100);

    expect(lms.results.length, 1);
  });


    test("Reject a result for a nonexistent student", () {
      final lms = LmsSystem();
      lms.addCourse(courseId: "C1", courseName: "CS");
      lms.addAssignmentToCourse(
          assignmentId: "A1", courseId: "C1", dueDate: "2026-10-10");

      expect(
          () => lms.addResult(
              studentId: "S1",
              courseId: "C1",
              resultId: "R1",
              assignmentId: "A1",
              score: 100),
          throwsException);
    });
    test('Reject a result for a nonexistent  course', () {
      final lms = LmsSystem();
      lms.addStudent(studentId: "S1", studentName: "Darwin");
      ;

      expect(
          () =>lms.addAssignmentToCourse(
          assignmentId: "A1", courseId: "C1", dueDate: "2026-10-10"),throwsException) ;


      expect(
          () => lms.addResult(
              studentId: "S1",
              courseId: "C1",
              resultId: "R1",
              assignmentId: "A1",
              score: 100),
          throwsException);
        
    });
  

  test(
      'Reject a result for a student who is not enrolled, if enrollment is required',
      () {});

  test('Reject an invalid score', () {});

  test('Remove an existing result', () {});

  test('Reject removal of a nonexistent result', () {});

  test('Verify that the result is no longer available', () {});

  test(
      'Verify that the student, course, and unrelated results remain unchanged',
      () {});
}

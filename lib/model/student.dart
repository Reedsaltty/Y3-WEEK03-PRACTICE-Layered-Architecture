import 'package:lms_layered_architecture_example/model/assignment.dart';

class Student {
  final String id;
  final String name;
  final List<Assignment> assignments = [];
  Student({required this.id, required this.name});

  List<Assignment> get assignmentList => assignments;
}

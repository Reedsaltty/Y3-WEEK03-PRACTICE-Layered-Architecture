import 'assignment.dart';

class Course {
  final String id;
  final String name;
  final List<String> studentIds = [];
  final List<Assignment> assignments = [];

  Course({required this.id, required this.name});

  List<String> get studentIdList => studentIds;
  
}

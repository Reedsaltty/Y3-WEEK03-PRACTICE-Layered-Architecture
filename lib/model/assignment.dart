enum STATUS { DRAFT, PUBLISHED, CLOSED }

class Assignment {
  final String assignmentId;
  final STATUS status;
  final String dueDate;
  final String openDate; 

  Assignment({ required this.assignmentId,required this.status,required this.openDate ,required this.dueDate
     }) {}
}

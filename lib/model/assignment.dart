enum STATUS { DRAFT, PUBLISHED, CLOSED }

class Assignment {
  final String assignmentId;
  final STATUS status;
  final String dueDate;


Assignment(this.assignmentId,this.status,this.dueDate){}


}

class TaskModel {
  String id;
  String title;
  String description;
  String status;
  String email;
  String createdDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
    required this.createdDate,
  });

  // Factory method to create a TaskModel from a JSON response
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? '',  // Map _id to id
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      email: json['email'] ?? '',
      createdDate: json['createdDate'] ?? '',
    );
  }

  // Optional: To convert TaskModel back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'status': status,
      'email': email,
      'createdDate': createdDate,
    };
  }
}

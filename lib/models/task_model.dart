class TaskModel {
  String title;
  String? description;
  String? object;
  bool isDone;
  String datetime;
  String time;
  TaskModel({
    
    required this.title,
    this.description,
    this.object,
    required this.isDone,
    required this.datetime,
    required this.time,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'object': object,
      'isDone': isDone,
      'datetime': datetime,
      'time':time,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        title: json['title'] as String,
        isDone: json['isDone'] as bool,
        description:
            json['description'] != null ? json['description'] as String : null,
        datetime: json['datetime'] as String,
        time: json['time'] as String,
        object: json['object'] != null ? json['object'] as String : null,
      );
}

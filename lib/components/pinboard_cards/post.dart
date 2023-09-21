import 'package:pocketbase/pocketbase.dart';

class Post {
  String id;
  String author;
  String type;
  Map<String, dynamic> data;

  Post(
      {required this.id,
      required this.type,
      required this.author,
      required this.data});

  factory Post.fromRecordModel(RecordModel model) {
    return Post(
      id: model.id,
      type: model.getStringValue("type"),
      author: model.getStringValue("author"),
      data: model.getDataValue("data"),
    );
  }
}

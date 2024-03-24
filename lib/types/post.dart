import 'package:pocketbase/pocketbase.dart';

class Reaction {
  String authorId;
  String reaction;

  Reaction({
    required this.authorId,
    required this.reaction,
  });

  factory Reaction.fromRecordModel(RecordModel model) {
    return Reaction(
      authorId: model.getStringValue("author"),
      reaction: model.getStringValue("reaction"),
    );
  }
}

class Post {
  String id;
  String authorId;
  String type;
  String share;
  Map<String, dynamic> data;
  List<Reaction>? reactions;
  DateTime createdAt;
  DateTime updatedAt;

  Post({
    required this.id,
    required this.type,
    required this.authorId,
    required this.data,
    required this.share,
    required this.createdAt,
    required this.updatedAt,
    this.reactions,
  });

  factory Post.fromRecordModel(RecordModel model) {
    return Post(
      id: model.id,
      type: model.getStringValue("type"),
      authorId: model.getStringValue("author"),
      data: model.getDataValue("data"),
      share: model.getStringValue("share"),
      reactions: model
          .getDataValue("reactions")
          ?.map((e) => Reaction.fromRecordModel(e))
          .toList(),
      createdAt: DateTime.parse(model.created),
      updatedAt: DateTime.parse(model.updated),
    );
  }
}

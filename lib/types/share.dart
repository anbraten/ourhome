import 'package:pocketbase/pocketbase.dart';

class Share {
  String id;
  String name;
  List<String> members;

  Share({required this.id, required this.name, required this.members});

  factory Share.fromRecordModel(RecordModel model) {
    return Share(
      id: model.id,
      name: model.getStringValue("name"),
      members: model.getListValue<String>("members"),
    );
  }
}

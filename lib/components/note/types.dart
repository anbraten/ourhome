class NoteData {
  final String message;

  NoteData({
    required this.message,
  });

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      message: json['message'],
    );
  }

  toJson() {
    return {
      'message': message,
    };
  }
}

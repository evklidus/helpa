class SummaryModel {
  const SummaryModel({
    required this.id,
    required this.topic,
    required this.text,
  });

  final int id;
  final String topic;
  final String text;

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      id: json['id'],
      topic: json['topic'],
      text: json['text'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'text': text,
    };
  }
  // static Map<String, dynamic> toJson(SummaryModel summary) {
  //   return {
  //     'topic': summary.topic,
  //     'text': summary.text,
  //   };
  // }

  // static String encode(List<SummaryModel> summaries) => jsonEncode(
  //       summaries
  //           .map<Map<String, dynamic>>((summary) => SummaryModel.toJson())
  //           .toList(),
  //     );

  // static List<SummaryModel> decode(String summaries) =>
  //     (jsonDecode(summaries) as List<dynamic>)
  //         .map<SummaryModel>((item) => SummaryModel.fromJson(item))
  //         .toList();
  SummaryModel copyWith({
    int? id,
    String? topic,
    String? text,
  }) =>
      SummaryModel(
        id: id ?? this.id,
        topic: topic ?? this.topic,
        text: text ?? this.text,
      );
}

class MCQModel {
  String? id;
  String jobId;
  String question;
  List<String> options;
  int correctOption;
  int passMark;

  MCQModel({
    this.id,
    required this.jobId,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.passMark,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "jobId": jobId,
      "question": question,
      "options": options,
      "correctOption": correctOption,
      "passMark": passMark,
    };
  }

  // Convert Firestore document to MCQ model
  factory MCQModel.fromMap(Map<String, dynamic> map, String docId) {
    return MCQModel(
      id: docId,
      jobId: map["jobId"] ?? "",
      question: map["question"] ?? "",
      options: List<String>.from(map["options"] ?? []),
      correctOption: map["correctOption"] ?? 0,
      passMark: map["passMark"] ?? 0,
    );
  }

  // **New copyWith method**
  MCQModel copyWith({
    String? id,
    String? jobId,
    String? question,
    List<String>? options,
    int? correctOption,
  }) {
    return MCQModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctOption: correctOption ?? this.correctOption,
      passMark: passMark, // Keep the original passMark value
    );
  }
}

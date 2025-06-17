enum ApplicationStatus { inProgress, submitted, failed }

class ApplicationProgressModel {
  final String? id;
  final String? jobId;
  final String? applicantId;
  final bool? testPassed;
  final int chancesLeft;
  final int maxChances;
  final String? assignedCourseId;
  final ApplicationStatus status;
  final DateTime? createdAt;
  final int? testScore;
  final String? recruiterFeedback;
  final int? passMarkForTest;
  final bool? usedFirstChance;
  final bool? usedSecondChance;
  final int? courseProgress;

  ApplicationProgressModel({
    this.id,
    this.jobId,
    this.applicantId,
    this.testPassed,
    this.chancesLeft = 2,
    this.maxChances = 2,
    this.assignedCourseId,
    this.status = ApplicationStatus.inProgress,
    this.createdAt,
    this.testScore,
    this.recruiterFeedback,
    this.passMarkForTest,
    this.usedFirstChance = false,
    this.usedSecondChance = false,
    this.courseProgress,
  });

  factory ApplicationProgressModel.fromJson(
      Map<String, dynamic> json, String id) {
    return ApplicationProgressModel(
        id: id,
        jobId: json['jobId'] as String?,
        applicantId: json['applicantId'] as String?,
        testPassed: json['testPassed'] as bool?,
        chancesLeft: json['chancesLeft'] as int? ?? 2,
        maxChances: json['maxChances'] as int? ?? 2,
        assignedCourseId: json['assignedCourseId'] as String?,
        status: ApplicationStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => ApplicationStatus.inProgress,
        ),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        testScore: json['testScore'] as int?,
        recruiterFeedback: json['recruiterFeedback'] as String?,
        passMarkForTest: json['passMarkForTest'] as int?,
        usedFirstChance: json['usedFirstChance'] as bool? ?? false,
        usedSecondChance: json['usedSecondChance'] as bool? ?? false,
        courseProgress: json['courseProgress'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'applicantId': applicantId,
      'testPassed': testPassed,
      'chancesLeft': chancesLeft,
      'maxChances': maxChances,
      'assignedCourseId': assignedCourseId,
      'status': status.toString().split('.').last,
      'createdAt': createdAt?.toIso8601String(),
      'testScore': testScore,
      'recruiterFeedback': recruiterFeedback,
      'passMarkForTest': passMarkForTest,
      'usedFirstChance': usedFirstChance,
      'usedSecondChance': usedSecondChance,
      'courseProgress': courseProgress,
    };
  }
  ApplicationProgressModel copyWith({
    String? id,
    String? jobId,
    String? applicantId,
    bool? testPassed,
    int? chancesLeft,
    int? maxChances,
    String? assignedCourseId,
    ApplicationStatus? status,
    DateTime? createdAt,
    int? testScore,
    String? recruiterFeedback,
    int? passMarkForTest,
    bool? usedFirstChance,
    bool? usedSecondChance,
    int? courseProgress,
  }) {
    return ApplicationProgressModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      applicantId: applicantId ?? this.applicantId,
      testPassed: testPassed ?? this.testPassed,
      chancesLeft: chancesLeft ?? this.chancesLeft,
      maxChances: maxChances ?? this.maxChances,
      assignedCourseId: assignedCourseId ?? this.assignedCourseId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      testScore: testScore ?? this.testScore,
      recruiterFeedback: recruiterFeedback ?? this.recruiterFeedback,
      passMarkForTest: passMarkForTest ?? this.passMarkForTest,
      usedFirstChance: usedFirstChance ?? this.usedFirstChance,
      usedSecondChance: usedSecondChance ?? this.usedSecondChance,
      courseProgress: courseProgress ?? this.courseProgress,
    );
  }

  
}

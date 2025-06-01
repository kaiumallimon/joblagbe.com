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
  final DateTime? updatedAt;
  final int? testScore;
  final String? recruiterFeedback;
  final int? passMarkForTest;
  final bool? usedFirstChance;
  final bool? usedSecondChance;

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
    this.updatedAt,
    this.testScore,
    this.recruiterFeedback,
    this.passMarkForTest,
    this.usedFirstChance = false,
    this.usedSecondChance = false,
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
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        testScore: json['testScore'] as int?,
        recruiterFeedback: json['recruiterFeedback'] as String?,
        passMarkForTest: json['passMarkForTest'] as int?,
        usedFirstChance: json['usedFirstChance'] as bool? ?? false,
        usedSecondChance: json['usedSecondChance'] as bool? ?? false);
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
      'updatedAt': updatedAt?.toIso8601String(),
      'testScore': testScore,
      'recruiterFeedback': recruiterFeedback,
      'passMarkForTest': passMarkForTest,
      'usedFirstChance': usedFirstChance,
      'usedSecondChance': usedSecondChance,
    };
  }
}

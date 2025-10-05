class Course {
  final String code;
  final String title;
  final String deptCode;
  final int credits;
  final String level; // freshman, sophomore, junior, senior
  final List<String> prerequisites;

  const Course({
    required this.code,
    required this.title,
    required this.deptCode,
    required this.credits,
    required this.level,
    this.prerequisites = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      deptCode: json['deptCode'] as String,
      credits: json['credits'] as int,
      level: json['level'] as String? ?? 'freshman',
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'deptCode': deptCode,
      'credits': credits,
      'level': level,
      'prerequisites': prerequisites,
    };
  }

  bool get isFreshmanLevel => level == 'freshman';
  bool get isSophomoreLevel => level == 'sophomore';
  bool get isJuniorLevel => level == 'junior';
  bool get isSeniorLevel => level == 'senior';

  bool get hasPrerequisites => prerequisites.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() =>
      'Course(code: $code, title: $title, level: $level, deptCode: $deptCode)';
}

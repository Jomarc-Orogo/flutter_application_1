// models/test_model.dart
import 'dart:convert';

enum QuestionType {
  multipleChoice,
  trueFalse,
  shortAnswer,
  essay,
  matching,
  fillInBlank,
}

class Test {
  final String id;
  final String title;
  final String subjectId;
  final String subjectName;
  final String teacherId;
  final String teacherName;
  final String classCode;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final int timeLimit; // in minutes, 0 for no limit
  final int totalPoints;
  final List<Question> questions;
  final bool isPublished;
  final bool isCompleted;
  final List<String> assignedStudentIds;
  final double? studentScore; // Null if not taken yet
  final DateTime? submittedAt;

  Test({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.subjectName,
    required this.teacherId,
    required this.teacherName,
    required this.classCode,
    required this.description,
    required this.createdAt,
    this.dueDate,
    required this.timeLimit,
    required this.totalPoints,
    required this.questions,
    required this.isPublished,
    this.isCompleted = false,
    this.assignedStudentIds = const [],
    this.studentScore,
    this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'classCode': classCode,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'timeLimit': timeLimit,
      'totalPoints': totalPoints,
      'questions': questions.map((q) => q.toMap()).toList(),
      'isPublished': isPublished,
      'isCompleted': isCompleted,
      'assignedStudentIds': assignedStudentIds,
      'studentScore': studentScore,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      id: map['id'],
      title: map['title'],
      subjectId: map['subjectId'],
      subjectName: map['subjectName'],
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      classCode: map['classCode'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      timeLimit: map['timeLimit'],
      totalPoints: map['totalPoints'],
      questions: List<Question>.from(map['questions'].map((x) => Question.fromMap(x))),
      isPublished: map['isPublished'],
      isCompleted: map['isCompleted'] ?? false,
      assignedStudentIds: List<String>.from(map['assignedStudentIds'] ?? []),
      studentScore: map['studentScore']?.toDouble(),
      submittedAt: map['submittedAt'] != null ? DateTime.parse(map['submittedAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory Test.fromJson(String source) => Test.fromMap(json.decode(source));

  Test copyWith({
    String? id,
    String? title,
    String? subjectId,
    String? subjectName,
    String? teacherId,
    String? teacherName,
    String? classCode,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    int? timeLimit,
    int? totalPoints,
    List<Question>? questions,
    bool? isPublished,
    bool? isCompleted,
    List<String>? assignedStudentIds,
    double? studentScore,
    DateTime? submittedAt,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      classCode: classCode ?? this.classCode,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      timeLimit: timeLimit ?? this.timeLimit,
      totalPoints: totalPoints ?? this.totalPoints,
      questions: questions ?? this.questions,
      isPublished: isPublished ?? this.isPublished,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedStudentIds: assignedStudentIds ?? this.assignedStudentIds,
      studentScore: studentScore ?? this.studentScore,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<Option> options;
  final int points;
  final String? correctAnswer;
  final List<String>? correctAnswers; // for multiple correct answers
  final String? studentAnswer;
  final int? studentScore;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.points,
    this.correctAnswer,
    this.correctAnswers,
    this.studentAnswer,
    this.studentScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type.toString(),
      'options': options.map((o) => o.toMap()).toList(),
      'points': points,
      'correctAnswer': correctAnswer,
      'correctAnswers': correctAnswers,
      'studentAnswer': studentAnswer,
      'studentScore': studentScore,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['text'],
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<Option>.from(map['options'].map((x) => Option.fromMap(x))),
      points: map['points'],
      correctAnswer: map['correctAnswer'],
      correctAnswers: map['correctAnswers'] != null 
          ? List<String>.from(map['correctAnswers']) 
          : null,
      studentAnswer: map['studentAnswer'],
      studentScore: map['studentScore'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Question.fromJson(String source) => Question.fromMap(json.decode(source));
}

class Option {
  final String id;
  final String text;
  final bool isCorrect;

  Option({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      id: map['id'],
      text: map['text'],
      isCorrect: map['isCorrect'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Option.fromJson(String source) => Option.fromMap(json.decode(source));
}
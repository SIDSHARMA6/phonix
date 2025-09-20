import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class QuestionData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  List<AnswerOption> options;

  @HiveField(3)
  String? parentQuestionId;

  @HiveField(4)
  int? parentAnswerIndex;

  QuestionData({
    required this.id,
    required this.text,
    required this.options,
    this.parentQuestionId,
    this.parentAnswerIndex,
  });
}

@HiveType(typeId: 1)
class AnswerOption extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  String? nextQuestionId;

  AnswerOption({
    required this.text,
    this.nextQuestionId,
  });
}

@HiveType(typeId: 2)
class UserAnswer extends HiveObject {
  @HiveField(0)
  String questionId;

  @HiveField(1)
  int selectedOptionIndex;

  @HiveField(2)
  DateTime timestamp;

  UserAnswer({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.timestamp,
  });
}

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  DateTime dateOfBirth;

  @HiveField(3)
  String mobileNumber;

  @HiveField(4)
  DateTime registrationDate;

  UserProfile({
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.mobileNumber,
    required this.registrationDate,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  bool get isAdult => age >= 18;
}

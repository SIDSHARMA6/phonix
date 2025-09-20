// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionDataAdapter extends TypeAdapter<QuestionData> {
  @override
  final int typeId = 0;

  @override
  QuestionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionData(
      id: fields[0] as String,
      text: fields[1] as String,
      options: (fields[2] as List).cast<AnswerOption>(),
      parentQuestionId: fields[3] as String?,
      parentAnswerIndex: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.parentQuestionId)
      ..writeByte(4)
      ..write(obj.parentAnswerIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnswerOptionAdapter extends TypeAdapter<AnswerOption> {
  @override
  final int typeId = 1;

  @override
  AnswerOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerOption(
      text: fields[0] as String,
      nextQuestionId: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AnswerOption obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.nextQuestionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAnswerAdapter extends TypeAdapter<UserAnswer> {
  @override
  final int typeId = 2;

  @override
  UserAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAnswer(
      questionId: fields[0] as String,
      selectedOptionIndex: fields[1] as int,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserAnswer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.selectedOptionIndex)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      email: fields[1] as String,
      dateOfBirth: fields[2] as DateTime,
      mobileNumber: fields[3] as String,
      registrationDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.dateOfBirth)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.registrationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

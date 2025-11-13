// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthEntryAdapter extends TypeAdapter<HealthEntry> {
  @override
  final int typeId = 0;

  @override
  HealthEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthEntry(
      id: fields[0] as int?,
      date: fields[1] as DateTime,
      bmi: fields[2] as double,
      caloriesBurned: fields[3] as double,
      caloriesConsumed: fields[4] as double,
      bmr: fields[5] as double,
      dailyCalories: fields[6] as double,
      gender: fields[7] as String,
      age: fields[8] as int,
      activityLevel: fields[9] as String,
      height: fields[10] as double,
      weight: fields[11] as double,
      caloriesBurnedDuration: fields[12] as int,
      exerciseType: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthEntry obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.bmi)
      ..writeByte(3)
      ..write(obj.caloriesBurned)
      ..writeByte(4)
      ..write(obj.caloriesConsumed)
      ..writeByte(5)
      ..write(obj.bmr)
      ..writeByte(6)
      ..write(obj.dailyCalories)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.age)
      ..writeByte(9)
      ..write(obj.activityLevel)
      ..writeByte(10)
      ..write(obj.height)
      ..writeByte(11)
      ..write(obj.weight)
      ..writeByte(12)
      ..write(obj.caloriesBurnedDuration)
      ..writeByte(13)
      ..write(obj.exerciseType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

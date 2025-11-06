// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_history_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodHistoryEntryAdapter extends TypeAdapter<MoodHistoryEntry> {
  @override
  final int typeId = 1;

  @override
  MoodHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodHistoryEntry(
      date: fields[0] as DateTime,
      imagePath: fields[1] as String,
      smileProbability: fields[2] as double,
      journalText: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MoodHistoryEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.smileProbability)
      ..writeByte(3)
      ..write(obj.journalText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

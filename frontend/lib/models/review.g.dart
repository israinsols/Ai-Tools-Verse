// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewAdapter extends TypeAdapter<Review> {
  @override
  final int typeId = 4;

  @override
  Review read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Review(
      id: fields[0] as String,
      toolId: fields[1] as String,
      userId: fields[2] as String,
      userName: fields[3] as String,
      rating: fields[4] as int,
      title: fields[5] as String,
      comment: fields[6] as String,
      helpful: fields[7] as int,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Review obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.toolId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.comment)
      ..writeByte(7)
      ..write(obj.helpful)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

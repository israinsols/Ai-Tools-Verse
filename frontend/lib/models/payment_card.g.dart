// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentCardAdapter extends TypeAdapter<PaymentCard> {
  @override
  final int typeId = 8;

  @override
  PaymentCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentCard(
      id: fields[0] as String,
      cardNumber: fields[1] as String,
      cardHolderName: fields[2] as String,
      expiryMonth: fields[3] as String,
      expiryYear: fields[4] as String,
      cardType: fields[6] as String,
      isDefault: fields[7] as bool,
      addedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.cardHolderName)
      ..writeByte(3)
      ..write(obj.expiryMonth)
      ..writeByte(4)
      ..write(obj.expiryYear)
      ..writeByte(6)
      ..write(obj.cardType)
      ..writeByte(7)
      ..write(obj.isDefault)
      ..writeByte(8)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

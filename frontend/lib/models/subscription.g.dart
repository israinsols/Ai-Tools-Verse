// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 7;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      tier: fields[0] as SubscriptionTier,
      trialActive: fields[1] as bool,
      trialEndsAt: fields[2] as DateTime?,
      subscribedAt: fields[3] as DateTime?,
      claimedDiscounts: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.tier)
      ..writeByte(1)
      ..write(obj.trialActive)
      ..writeByte(2)
      ..write(obj.trialEndsAt)
      ..writeByte(3)
      ..write(obj.subscribedAt)
      ..writeByte(4)
      ..write(obj.claimedDiscounts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionTierAdapter extends TypeAdapter<SubscriptionTier> {
  @override
  final int typeId = 6;

  @override
  SubscriptionTier read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionTier.free;
      case 1:
        return SubscriptionTier.plus;
      case 2:
        return SubscriptionTier.pro;
      default:
        return SubscriptionTier.free;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionTier obj) {
    switch (obj) {
      case SubscriptionTier.free:
        writer.writeByte(0);
        break;
      case SubscriptionTier.plus:
        writer.writeByte(1);
        break;
      case SubscriptionTier.pro:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

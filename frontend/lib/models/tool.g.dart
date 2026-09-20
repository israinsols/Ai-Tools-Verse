// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToolAdapter extends TypeAdapter<Tool> {
  @override
  final int typeId = 0;

  @override
  Tool read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tool(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      websiteUrl: fields[3] as String,
      logoUrl: fields[4] as String?,
      categoryId: fields[5] as String,
      tags: (fields[6] as List).cast<String>(),
      pricingType: fields[7] as PricingType,
      rating: fields[8] as double,
      viewCount: fields[9] as int,
      isVerified: fields[10] as bool,
      isFeatured: fields[11] as bool,
      isTrending: fields[12] as bool,
      isNew: fields[13] as bool,
      status: fields[16] as String,
      submittedBy: fields[17] as String?,
      keyFeatures: (fields[18] as List).cast<String>(),
      pros: (fields[19] as List).cast<String>(),
      cons: (fields[20] as List).cast<String>(),
      freeTierInfo: fields[21] as String?,
      pricingPlans: (fields[22] as List).cast<PricingPlan>(),
      trialInfo: fields[23] as String?,
      membershipBenefits: (fields[24] as List).cast<String>(),
      plusDiscountPercent: fields[25] as int?,
      proDiscountPercent: fields[26] as int?,
      discountCodePlus: fields[27] as String?,
      discountCodePro: fields[28] as String?,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Tool obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.websiteUrl)
      ..writeByte(4)
      ..write(obj.logoUrl)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.pricingType)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.viewCount)
      ..writeByte(10)
      ..write(obj.isVerified)
      ..writeByte(11)
      ..write(obj.isFeatured)
      ..writeByte(12)
      ..write(obj.isTrending)
      ..writeByte(13)
      ..write(obj.isNew)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.submittedBy)
      ..writeByte(18)
      ..write(obj.keyFeatures)
      ..writeByte(19)
      ..write(obj.pros)
      ..writeByte(20)
      ..write(obj.cons)
      ..writeByte(21)
      ..write(obj.freeTierInfo)
      ..writeByte(22)
      ..write(obj.pricingPlans)
      ..writeByte(23)
      ..write(obj.trialInfo)
      ..writeByte(24)
      ..write(obj.membershipBenefits)
      ..writeByte(25)
      ..write(obj.plusDiscountPercent)
      ..writeByte(26)
      ..write(obj.proDiscountPercent)
      ..writeByte(27)
      ..write(obj.discountCodePlus)
      ..writeByte(28)
      ..write(obj.discountCodePro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PricingPlanAdapter extends TypeAdapter<PricingPlan> {
  @override
  final int typeId = 5;

  @override
  PricingPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PricingPlan(
      name: fields[0] as String,
      price: fields[1] as String,
      period: fields[2] as String,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PricingPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.period)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PricingPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PricingTypeAdapter extends TypeAdapter<PricingType> {
  @override
  final int typeId = 1;

  @override
  PricingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PricingType.free;
      case 1:
        return PricingType.freemium;
      case 2:
        return PricingType.paid;
      default:
        return PricingType.free;
    }
  }

  @override
  void write(BinaryWriter writer, PricingType obj) {
    switch (obj) {
      case PricingType.free:
        writer.writeByte(0);
        break;
      case PricingType.freemium:
        writer.writeByte(1);
        break;
      case PricingType.paid:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PricingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

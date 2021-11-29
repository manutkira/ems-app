// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      name: fields[1] as String?,
      phone: fields[2] as String?,
      email: fields[3] as String?,
      emailVerifiedAt: fields[4] as DateTime?,
      address: fields[5] as String?,
      password: fields[6] as String?,
      position: fields[7] as String?,
      skill: fields[8] as String?,
      salary: fields[9] as String?,
      role: fields[10] as String?,
      background: fields[11] as String?,
      status: fields[12] as String?,
      rate: fields[13] as String?,
      image: fields[16] as String?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.emailVerifiedAt)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.password)
      ..writeByte(7)
      ..write(obj.position)
      ..writeByte(8)
      ..write(obj.skill)
      ..writeByte(9)
      ..write(obj.salary)
      ..writeByte(10)
      ..write(obj.role)
      ..writeByte(11)
      ..write(obj.background)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.rate)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      khmer: fields[2] as String?,
      phone: fields[3] as String?,
      email: fields[5] as String?,
      password: fields[4] as String?,
      salary: fields[10] as double?,
      status: fields[8] as String?,
      address: fields[6] as String?,
      background: fields[9] as String?,
      role: fields[7] as String?,
      image: fields[11] as String?,
      imageId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.khmer)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.background)
      ..writeByte(10)
      ..write(obj.salary)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.imageId);
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

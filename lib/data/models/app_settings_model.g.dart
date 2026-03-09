// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

class AppSettingsModelAdapter extends TypeAdapter<AppSettingsModel> {
  @override
  final int typeId = 3;

  @override
  AppSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingsModel(
      isDarkMode: fields[0] as bool,
      currency: fields[1] as String,
      currencySymbol: fields[2] as String,
      languageCode: fields[3] as String? ?? 'en',
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.currencySymbol)
      ..writeByte(3)
      ..write(obj.languageCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buffer_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoBufferItem _$InfoBufferItemFromJson(Map<String, dynamic> json) {
  return InfoBufferItem(
    info: json['info'] as String,
  );
}

Map<String, dynamic> _$InfoBufferItemToJson(InfoBufferItem instance) =>
    <String, dynamic>{
      'info': instance.info,
    };

ReceivedBufferItem _$ReceivedBufferItemFromJson(Map<String, dynamic> json) {
  return ReceivedBufferItem(
    dataReceived: json['dataReceived'] as String,
  );
}

Map<String, dynamic> _$ReceivedBufferItemToJson(ReceivedBufferItem instance) =>
    <String, dynamic>{
      'dataReceived': instance.dataReceived,
    };

SentBufferItem _$SentBufferItemFromJson(Map<String, dynamic> json) {
  return SentBufferItem(
    dataSent: json['dataSent'] as String,
  );
}

Map<String, dynamic> _$SentBufferItemToJson(SentBufferItem instance) =>
    <String, dynamic>{
      'dataSent': instance.dataSent,
    };

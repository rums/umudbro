import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'buffer_item.g.dart';

class BufferItemType {
  BufferItemType(this._value);
  final _value;

  const BufferItemType._internal(this._value);

  toString() => 'BufferItemType.$_value';
  toJson() => toString();
  factory BufferItemType.fromString(String str) {
    switch (str) {
      case "BufferItemType.InfoBufferItem":
        return InfoBufferItem;
      case "BufferItemType.ReceivedBufferItem":
        return ReceivedBufferItem;
      case "BufferItemType.SentBufferItem":
        return SentBufferItem;
      default:
        return InfoBufferItem;
    }
  }

  static const InfoBufferItem =
      const BufferItemType._internal("InfoBufferItem");
  static const ReceivedBufferItem =
      const BufferItemType._internal("ReceivedBufferItem");
  static const SentBufferItem =
      const BufferItemType._internal("SentBufferItem");
}

abstract class BufferItem extends Equatable {
  String get displayText;

  BufferItemType get itemType;

  factory BufferItem.fromJson(BufferItemType type, Map<String, dynamic> json) {
    switch (type) {
      case BufferItemType.InfoBufferItem:
        return InfoBufferItem.fromJson(json);
      case BufferItemType.ReceivedBufferItem:
        return ReceivedBufferItem.fromJson(json);
      default:
        return InfoBufferItem.fromJson(json);
    }
  }
}

@JsonSerializable()
class InfoBufferItem implements BufferItem {
  final String info;

  InfoBufferItem({this.info});

  @override
  String get displayText => info ?? "";

  @override
  List<Object> get props => [info];

  @override
  factory InfoBufferItem.fromJson(Map<String, dynamic> json) =>
      _$InfoBufferItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InfoBufferItemToJson(this)..putIfAbsent("itemType", () => itemType);

  @override
  BufferItemType get itemType => BufferItemType.InfoBufferItem;

  @override
  bool get stringify => true;
}

@JsonSerializable()
class ReceivedBufferItem implements BufferItem {
  final String dataReceived;

  ReceivedBufferItem({this.dataReceived});

  @override
  String get displayText => dataReceived ?? "";

  @override
  List<Object> get props => [dataReceived];

  factory ReceivedBufferItem.fromJson(Map<String, dynamic> json) =>
      _$ReceivedBufferItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReceivedBufferItemToJson(this)..putIfAbsent("itemType", () => itemType);

  @override
  BufferItemType get itemType => BufferItemType.ReceivedBufferItem;

  @override
  bool get stringify => true;
}

@JsonSerializable()
class SentBufferItem implements BufferItem {
  final String dataSent;

  SentBufferItem({this.dataSent});

  @override
  String get displayText => dataSent ?? "";

  @override
  List<Object> get props => [dataSent];

  factory SentBufferItem.fromJson(Map<String, dynamic> json) =>
      _$SentBufferItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SentBufferItemToJson(this)..putIfAbsent("itemType", () => itemType);

  @override
  BufferItemType get itemType => BufferItemType.SentBufferItem;

  @override
  bool get stringify => true;
}
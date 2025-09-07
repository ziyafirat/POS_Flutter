// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScannedItem _$ScannedItemFromJson(Map<String, dynamic> json) => ScannedItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$ScannedItemToJson(ScannedItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'imageUrl': instance.imageUrl,
      'barcode': instance.barcode,
    };

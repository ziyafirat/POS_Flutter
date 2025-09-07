import 'package:json_annotation/json_annotation.dart';

part 'scanned_item.g.dart';

@JsonSerializable()
class ScannedItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? barcode;

  const ScannedItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.barcode,
  });

  factory ScannedItem.fromJson(Map<String, dynamic> json) =>
      _$ScannedItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScannedItemToJson(this);

  double get totalPrice => price * quantity;

  ScannedItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? barcode,
  }) {
    return ScannedItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      barcode: barcode ?? this.barcode,
    );
  }
}

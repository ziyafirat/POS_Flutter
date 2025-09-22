/// Parsed item model for efficient ListView display
class ParsedItem {
  final String barcode;
  final String displayName;
  final String uom;
  final String price;
  final String qty;
  final String vr;

  const ParsedItem({
    required this.barcode,
    required this.displayName,
    required this.uom,
    required this.price,
    required this.qty,
    required this.vr,
  });

  /// Parse from item string format: barcode:displayName:uom:price:qty:vr
  factory ParsedItem.fromString(String itemString) {
    final parts = itemString.split(':');
    return ParsedItem(
      barcode: parts.isNotEmpty ? parts[0] : '',
      displayName: parts.length > 1 ? parts[1] : 'Unknown Item',
      uom: parts.length > 2 ? parts[2] : '',
      price: parts.length > 3 ? parts[3] : '0.00',
      qty: parts.length > 4 ? parts[4] : '1',
      vr: parts.length > 5 ? parts[5] : '',
    );
  }

  /// Convert to item string format for storage
  String toItemString() {
    return '$barcode:$displayName:$uom:$price:$qty:$vr';
  }

  /// Get formatted quantity display
  String get formattedQuantity {
    return uom.isNotEmpty ? 'Qty: $qty $uom' : 'Qty: $qty';
  }

  /// Get price as double for calculations
  double get priceAsDouble {
    return double.tryParse(price) ?? 0.0;
  }
}

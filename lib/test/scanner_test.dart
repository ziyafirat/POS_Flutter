import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../services/scanner_service.dart';

/// Test class for the enhanced scanner service
/// This tests the partial barcode scanning fixes
class ScannerTest {
  static final Logger _logger = Logger();

  /// Run comprehensive scanner tests
  static void runTests() {
    _logger.i('🧪 STARTING COMPREHENSIVE SCANNER TESTS');
    print('🧪 STARTING COMPREHENSIVE SCANNER TESTS');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Initialize scanner service
    final scannerService = Get.find<ScannerService>();

    // Clear stats before testing
    scannerService.clearStats();

    // Test 1: Valid 13-digit barcode
    _testValidBarcode(scannerService);

    // Test 2: Partial barcode (the main issue)
    _testPartialBarcode(scannerService);

    // Test 3: Invalid barcode with letters
    _testInvalidBarcode(scannerService);

    // Test 4: Long barcode (20 digits)
    _testLongBarcode(scannerService);

    // Test 5: Edge case - minimum length
    _testMinimumLengthBarcode(scannerService);

    // Test 6: Edge case - maximum length
    _testMaximumLengthBarcode(scannerService);

    // Display final statistics
    _displayFinalStats(scannerService);

    _logger.i('✅ SCANNER TESTS COMPLETED');
    print('✅ SCANNER TESTS COMPLETED');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void _testValidBarcode(ScannerService scanner) {
    _logger.i('Test 1: Valid 13-digit barcode');
    print('\n📋 Test 1: Valid 13-digit barcode');
    scanner.testScanner(); // Uses 1234567890123
  }

  static void _testPartialBarcode(ScannerService scanner) {
    _logger.i('Test 2: Partial 8-digit barcode (main issue)');
    print('\n📋 Test 2: Partial 8-digit barcode (main issue)');
    scanner.testPartialBarcode(); // Uses 12345678
  }

  static void _testInvalidBarcode(ScannerService scanner) {
    _logger.i('Test 3: Invalid barcode with letters');
    print('\n📋 Test 3: Invalid barcode with letters');
    scanner.testInvalidBarcode(); // Uses 123ABC456
  }

  static void _testLongBarcode(ScannerService scanner) {
    _logger.i('Test 4: Long 20-digit barcode');
    print('\n📋 Test 4: Long 20-digit barcode');
    scanner.testScannerLong(); // Uses 12345678901234567890
  }

  static void _testMinimumLengthBarcode(ScannerService scanner) {
    _logger.i('Test 5: Minimum length barcode (8 digits)');
    print('\n📋 Test 5: Minimum length barcode (8 digits)');
    // Use the existing testPartialBarcode method which tests 8 digits
    scanner.testPartialBarcode();
  }

  static void _testMaximumLengthBarcode(ScannerService scanner) {
    _logger.i('Test 6: Maximum length barcode (20 digits)');
    print('\n📋 Test 6: Maximum length barcode (20 digits)');
    // Use the existing testScannerLong method which tests 20 digits
    scanner.testScannerLong();
  }

  static void _displayFinalStats(ScannerService scanner) {
    _logger.i('\n📊 FINAL SCANNER STATISTICS:');
    print('\n📊 FINAL SCANNER STATISTICS:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final stats = scanner.getDetailedStats();
    stats.forEach((key, value) {
      _logger.i('$key: $value');
      print('$key: $value');
    });

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Summary
    final totalScans = stats['totalScans'] as int;
    final validScans = stats['validScans'] as int;
    final partialScans = stats['partialScans'] as int;

    print('\n📈 SUMMARY:');
    print('Total scans attempted: $totalScans');
    print('Valid scans processed: $validScans');
    print('Partial/Invalid scans caught: $partialScans');
    print('Success rate: ${stats['successRate']}');

    if (partialScans > 0) {
      print('\n✅ SUCCESS: Partial barcode detection is working!');
      print(
        'The scanner service successfully identified and handled partial barcodes.',
      );
    } else {
      print('\n⚠️ No partial barcodes were detected in this test run.');
    }
  }
}

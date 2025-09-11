import 'package:get/get.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();
  
  // Current language (true = English, false = Turkish)
  final _isEnglish = false.obs;
  
  bool get isEnglish => _isEnglish.value;
  
  void toggleLanguage() {
    _isEnglish.value = !_isEnglish.value;
    update(); // Notify GetBuilder widgets to rebuild
  }
  
  void setLanguage(bool english) {
    _isEnglish.value = english;
    update(); // Notify GetBuilder widgets to rebuild
  }
  
  // Text getters for common UI elements
  String get languageButtonText => isEnglish ? 'Türkçe' : 'English';
  
  String get productSearch => isEnglish ? 'Search Product' : 'Ürün Ara';
  String get carrefourCard => isEnglish ? 'CarrefourSA Card' : 'CarrefourSA Kart';
  String get enterBarcode => isEnglish ? 'Enter Barcode' : 'Barkod\'u Tuşlayın';
  String get callHelp => isEnglish ? 'Call for Help' : 'Yardım Çağır';
  String get finishAndPay => isEnglish ? 'Finish & Pay' : 'Bitir ve Öde';
  String get addTestItem => isEnglish ? 'Add Test Item' : 'Test Item Ekle';
  
  // Payment page texts
  String get makeSelection => isEnglish ? 'Make Your Selection Now' : 'Şimdi Seçiminizi Yapın';
  String get cash => isEnglish ? 'Cash' : 'Nakit';
  String get credit => isEnglish ? 'Credit' : 'Kredi';
  String get paymentWithChange => isEnglish ? 'Payment with Change' : 'Bozuk Para Üstü İle Ödeme';
  String get paymentWithStaffCard => isEnglish ? 'Payment with Staff Card' : 'Personel Kart İle Ödeme';
  String get returnScanMore => isEnglish ? 'RETURN\nScan More Items' : 'GERİ\nDaha Fazla Ürün Tara';
  String get requestHelp => isEnglish ? 'Request Help' : 'Yardım İste';
  
  // Item list texts
  String get noItemsScanned => isEnglish ? 'No items scanned yet' : 'Henüz ürün taranmadı';
  String get shoppingTotal => isEnglish ? 'Shopping Total:' : 'Alışveriş Tutarı:';
  String get discountDisclaimer => isEnglish 
      ? 'Campaigns and discounts will be applied after "Finish and Pay".'
      : 'Kampanya ve indirimler "Bitir ve Öde" den sonra uygulanacaktır.';
  
  // Transaction summary texts
  String get subtotal => isEnglish ? 'Subtotal:' : 'Ara Toplam:';
  String get campaignDiscount => isEnglish ? 'Campaign Discount:' : 'Kampanya İnd. Top:';
  String get total => isEnglish ? 'TOTAL:' : 'TOPLAM:';
  
  // Scale texts
  String get version => isEnglish ? 'Version' : 'Versiyon';
  
  // Instructions
  String get scanInstruction => isEnglish 
      ? 'Scan the product and place it in the bag'
      : 'Ürünü okutunuz ve poşete yerleştiriniz';
  
  // Start page texts
  String get welcomeTitle => isEnglish 
      ? 'Welcome to Self-Checkout'
      : 'Self-Checkout\'a Hoş Geldiniz';
  
  String get welcomeSubtitle => isEnglish 
      ? 'Please scan your items to begin'
      : 'Başlamak için ürünlerinizi tarayın';
  
  String get startShopping => isEnglish 
      ? 'Start Shopping'
      : 'Alışverişe Başla';
  
  String get assistant => isEnglish 
      ? 'Assistant'
      : 'Asistan';
  
  // Printing page texts
  String get thankYouForShopping => isEnglish 
      ? 'Thank you for shopping!'
      : 'Alışveriş için teşekkürler!';
  
  String get returningToStart => isEnglish 
      ? 'Returning to start page in'
      : 'Başlangıç sayfasına dönülüyor';
  
  // Bag popup texts
  String get addPlasticBag => isEnglish 
      ? 'Add Plastic Bag'
      : 'Plastik Poşet Ekle';
  
  String get bagCount => isEnglish 
      ? 'Bag Count:'
      : 'Poşet Sayısı:';
  
  String get bagPrice => isEnglish 
      ? '0.25 TL per bag'
      : 'Poşet başına 0.25 TL';
  
  String get finishShopping => isEnglish 
      ? 'Finish Shopping'
      : 'Alışverişi Bitir';
}

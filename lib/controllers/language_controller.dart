import 'package:get/get.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();
  
  // Current language (true = English, false = Arabic)
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
  String get languageButtonText => isEnglish ? 'العربية' : 'English';
  
  String get productSearch => isEnglish ? 'Search Product' : 'البحث عن المنتج';
  String get carrefourCard => isEnglish ? 'CarrefourSA Card' : 'بطاقة كارفور';
  String get enterBarcode => isEnglish ? 'Enter Barcode' : 'أدخل الباركود';
  String get callHelp => isEnglish ? 'Call for Help' : 'طلب المساعدة';
  String get finishAndPay => isEnglish ? 'Finish & Pay' : 'إنهاء ودفع';
  String get addTestItem => isEnglish ? 'Add Test Item' : 'إضافة عنصر تجريبي';
  
  // Payment page texts
  String get makeSelection => isEnglish ? 'Make Your Selection Now' : 'اختر الآن';
  String get cash => isEnglish ? 'Cash' : 'نقداً';
  String get credit => isEnglish ? 'Credit' : 'ائتمان';
  String get paymentWithChange => isEnglish ? 'Payment with Change' : 'دفع مع الباقي';
  String get paymentWithStaffCard => isEnglish ? 'Payment with Staff Card' : 'دفع ببطاقة الموظف';
  String get returnScanMore => isEnglish ? 'RETURN\nScan More Items' : 'إرجاع\nمسح المزيد من العناصر';
  String get requestHelp => isEnglish ? 'Request Help' : 'طلب المساعدة';
  
  // Item list texts
  String get noItemsScanned => isEnglish ? 'No items scanned yet' : 'لم يتم مسح أي عناصر بعد';
  String get shoppingTotal => isEnglish ? 'Shopping Total:' : 'إجمالي التسوق:';
  String get discountDisclaimer => isEnglish 
      ? 'Campaigns and discounts will be applied after "Finish and Pay".'
      : 'سيتم تطبيق الحملات والخصومات بعد "إنهاء ودفع".';
  
  // Transaction summary texts
  String get subtotal => isEnglish ? 'Subtotal:' : 'المجموع الفرعي:';
  String get campaignDiscount => isEnglish ? 'Campaign Discount:' : 'خصم الحملة:';
  String get total => isEnglish ? 'TOTAL:' : 'المجموع:';
  
  // Scale texts
  String get version => isEnglish ? 'Version' : 'الإصدار';
  
  // Instructions
  String get scanInstruction => isEnglish 
      ? 'Scan the product and place it in the bag'
      : 'امسح المنتج وضعه في الحقيبة';
  
  // Start page texts
  String get welcomeTitle => isEnglish 
      ? 'Welcome to Self-Checkout'
      : 'مرحباً بك في الدفع الذاتي';
  
  String get welcomeSubtitle => isEnglish 
      ? 'Please scan your items to begin'
      : 'يرجى مسح عناصرك للبدء';
  
  String get startShopping => isEnglish 
      ? 'Start Shopping'
      : 'ابدأ التسوق';
  
  String get assistant => isEnglish 
      ? 'Assistant'
      : 'المساعد';
  
  // Printing page texts
  String get thankYouForShopping => isEnglish 
      ? 'Thank you for shopping!'
      : 'شكراً لك على التسوق!';
  
  String get returningToStart => isEnglish 
      ? 'Returning to start page in'
      : 'العودة إلى الصفحة الرئيسية خلال';
  
  // Currency support
  String get currencySymbol => 'AED';
  String get currencyName => isEnglish ? 'Dirham' : 'درهم';
  
  // Format currency with AED symbol
  String formatCurrency(double amount) {
    return '$amount $currencySymbol';
  }
}

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionController extends ChangeNotifier {
  int? _selectedIndex = 0;
  int? get selectedIndex => _selectedIndex;

  void selectCard(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  bool isCardSelected(int index) => _selectedIndex == index;

  Offerings? offerings;
  bool isPurchasing = false;

  // ✅ Load offerings
  Future<void> loadOfferings() async {
    try {
      Offerings fetchedOfferings = await Purchases.getOfferings();
      offerings = fetchedOfferings;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching offerings: $e");
    }
  }


  Future<void> purchasePackage(Package package) async {
    try {
      isPurchasing = true;
      notifyListeners();

      // ignore: deprecated_member_use
      final purchaseResult = await Purchases.purchasePackage(package);
      final customerInfo = purchaseResult.customerInfo; 
      debugPrint("Purchase successful: ${customerInfo.entitlements.active}");
    } catch (e) {
      debugPrint("Purchase failed: $e");
    } finally {
      isPurchasing = false;
      notifyListeners();
    }
  }

  // ✅ Getter for packages
  List<Package> get availablePackages {
    return offerings?.current?.availablePackages ?? [];
  }
}

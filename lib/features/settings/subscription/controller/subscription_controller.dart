import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // ✅ Purchase status
  String? purchaseStatus; // success | cancelled | failed

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
      purchaseStatus = null;
      notifyListeners();

      final purchaseResult =
          await Purchases.purchasePackage(package);

      final customerInfo = purchaseResult.customerInfo;

      // ✅ SUCCESS
      if (customerInfo.entitlements.active.isNotEmpty) {
        purchaseStatus = "success";
        debugPrint("Purchase Success");
      } else {
        purchaseStatus = "failed";
        debugPrint("Purchase Failed: No active entitlements");
      }

    } on PlatformException catch (e) {

      // ✅ CANCELLED
      if (e.code == '1' ||
          e.message?.contains('cancelled') == true ||
          e.toString().contains('PurchaseCancelledError')) {

        purchaseStatus = "cancelled";
        debugPrint("Purchase Cancelled");

      } else {
        // ❌ FAILED
        purchaseStatus = "failed";
        debugPrint("Purchase Failed: $e");
      }

    } catch (e) {
      purchaseStatus = "failed";
      debugPrint("Purchase Failed: $e");
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
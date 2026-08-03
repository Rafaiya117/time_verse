// ignore_for_file: deprecated_member_use
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


  String? purchaseStatus; 
  Future<void> loadOfferings() async {
    try {
      debugPrint("Loading offerings...");
      Offerings fetchedOfferings = await Purchases.getOfferings();
      debugPrint("Offerings loaded");
      debugPrint(fetchedOfferings.toString());
      offerings = fetchedOfferings;
      debugPrint(
        "Current Offering: ${offerings?.current?.identifier}",
      );

      debugPrint(
        "Packages Count: ${offerings?.current?.availablePackages.length}",
      );

      notifyListeners();
    } catch (e, s) {
      debugPrint("ERROR");
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> purchasePackage(Package package) async {
    try {
      isPurchasing = true;
      purchaseStatus = null;
      notifyListeners();

      final purchaseResult = await Purchases.purchasePackage(package);
      final customerInfo = purchaseResult.customerInfo;
      if (customerInfo.entitlements.active.isNotEmpty) {
        purchaseStatus = "success";
        debugPrint("Purchase Success");
      } else {
        purchaseStatus = "failed";
        debugPrint("Purchase Failed: No active entitlements");
      }

    } on PlatformException catch (e) {

      if (e.code == '1' || e.message?.contains('cancelled') == true || e.toString().contains('PurchaseCancelledError')) {

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

  List<Package> get availablePackages {
    return offerings?.current?.availablePackages ?? [];
  }

  List<String> get offeringFeatures {
    final metadata = offerings?.current?.metadata;
    if (metadata != null && metadata.containsKey('features')) {
      final dynamic list = metadata['features'];
      if (list is List) {
        return List<String>.from(list);
      }
    }

    // Fallback defaults if offline or metadata is missing
    return [
      'Unlimited Daily Inspiration',
      'Smart Event Reminders',
      'Save Your Favorite Quotes',
      'Premium Calming Backgrounds',
      'Personal Notification Messages',
    ];
  }
}
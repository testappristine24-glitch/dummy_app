import 'package:delivoo/Api_Provider.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Models/OfferModel.dart';
import 'package:flutter/material.dart';

class Offerprovider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  List<OfferModel> offers = [];
  OfferModel? selectedoffer;

  getoffers() async {
    try {
      showLoading();
      /*  final response = await apiProvider.post(GET_CATEGORIES, json.encode({}));
      
        print(response.toString()); */

      processresponseoffer();
      // notifyListeners();

      hideLoading();
      //return null;
    } on Exception catch (e) {
      hideLoading();
      print(e);
    }
  }

  processresponseoffer() async {
    OfferModel o1 = OfferModel(
      offerId: 'o1',
      offerImage: '',
    );
    OfferModel o2 = OfferModel(
      offerId: 'o2',
      offerImage: '',
    );

    offers.clear();
    offers.add(o1);
    offers.add(o2);
  }
}

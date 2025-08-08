import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Components/list_tile.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:delivoo/Routes/routes.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.selectPayment!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                AppLocalizations.of(context)!.amount! + '\$ 11.50',
                style: Theme.of(context).textTheme.headlineSmall!
                    .copyWith(color: kDisabledColor),
              ),
            ],
          ),
        ),
      ),
      body: FadedSlideAnimation(
        child: ListView(
          children: <Widget>[
            Divider(
              color: Theme.of(context).cardColor,
              thickness: 6.7,
            ),
            ListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
              leading: FadedScaleAnimation(
                child: Image.asset(
                  'images/payment/payment_cod.png',
                  height: 25.3,
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.wallet!,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.07),
              ),
              trailing: Text(
                '\$ 258.50',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: kDisabledColor),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Theme.of(context).cardColor,
              child: Text(AppLocalizations.of(context)!.card!.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kDisabledColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.67)),
            ),
            BuildListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
              image: 'images/payment/payment_card.png',
              text: AppLocalizations.of(context)!.credit,
            ),
            BuildListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
              image: 'images/payment/payment_card.png',
              text: AppLocalizations.of(context)!.debit,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Theme.of(context).cardColor,
              child: Text(
                AppLocalizations.of(context)!.cash!.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kDisabledColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.67),
              ),
            ),
            BuildListTile(
              image: 'images/payment/payment_cod.png',
              text: AppLocalizations.of(context)!.cod,
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Theme.of(context).cardColor,
              child: Text(
                AppLocalizations.of(context)!.other!.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kDisabledColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.67),
              ),
            ),
            BuildListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
              image: 'images/payment/payment_paypal.png',
              text: AppLocalizations.of(context)!.paypal,
            ),
            BuildListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
              image: 'images/payment/payment_payu.png',
              text: AppLocalizations.of(context)!.payU,
            ),
            BuildListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.orderPlaced),
              image: 'images/payment/payment_stripe.png',
              text: AppLocalizations.of(context)!.stripe,
            ),
            Container(
              color: Theme.of(context).cardColor,
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

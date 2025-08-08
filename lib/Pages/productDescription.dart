import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/items.dart';

import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppConstants.dart';
import '../CommonWidget.dart';
import '../Components/common_app_nav_bar.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({Key? key}) : super(key: key);

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().selectedProducts;
    final index = context.watch<ProductProvider>().productIndex;
    final checkout = context.watch<ProductProvider>().cartTotal?.d;
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(products!.productName!, style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              InteractiveViewer(
                  panEnabled: false, // Set it to false to prevent panning.
                  boundaryMargin: EdgeInsets.all(80),
                  minScale: 0.8,
                  maxScale: 1.3,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    // child: Image.asset(products.productImage!,
                    //     fit: BoxFit.cover),
                    decoration: BoxDecoration(
                        image: products
                            .productDetails![
                        products.productDetailsIndex]
                            .productimage ==
                            null
                            ? DecorationImage(
                          image: AssetImage(
                            'images/logos/not-available.png',
                          ),
                        )
                            : DecorationImage(
                          image: CachedNetworkImageProvider(
                              BaseUrl +
                                  'skuimages/' +
                                  products
                                      .productDetails![
                                  products.productDetailsIndex]
                                      .productimage!,
                              cacheKey: products
                                  .productDetails![
                              products.productDetailsIndex]
                                  .productimage
                            // fit: BoxFit.cover,
                          ),
                          onError: (exception, stackTrace) {
                            products
                                .productDetails![
                            products.productDetailsIndex]
                                .productimage = null;
                          },
                        )),
                  )),
              SizedBox(height: 10),
              Center(
                child: Text(
                    '\₹ ${products.productDetails![products.productDetailsIndex].productRate}'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30.0,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          products.productDetails![products.productDetailsIndex]
                              .productWeight
                              .toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  products.productDetails![products.productDetailsIndex]
                      .outofstock ==
                      0
                      ? products.totproductQty == 0
                      ? products.productDetails!.length == 1
                      ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: products.isloading == true
                        ? SizedBox(
                        child: CircularProgressIndicator(
                          color: kMainColor,
                        ),
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.1)
                        : InkWell(
                        child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        20.0)),
                                border: Border.all(
                                  color: Color(
                                      0xffec9458), //|| kMainColor, |
                                )),
                            height: MediaQuery.of(context)
                                .size
                                .height *
                                0.05,
                            child: Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .shopping_cart_outlined,
                                    color:
                                    buttonColor, // kMainColor,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    AppLocalizations.of(
                                        context)!
                                        .add!,
                                    textAlign:
                                    TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color:
                                        buttonColor,
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ],
                              ),
                            )),
                        onTap: () async {
                          if (products
                              .productDetails!.length ==
                              1) {
                            if (products
                                .productDetails![products
                                .productDetailsIndex]
                                .productQty! <
                                products
                                    .productDetails![products
                                    .productDetailsIndex]
                                    .stock!) {
                              await context
                                  .read<ProductProvider>()
                                  .increaseCount(
                                  index: index,
                                  productNewIndex: products
                                      .productDetailsIndex);
                              // await context.read<ProductProvider>().getProductsByCategory(subcategories[context.read<ProductProvider>().tabValue].sectionid!, '', isLoading: false);
                            } else {
                              showMessage(
                                  'Only ${products.productDetails![products.productDetailsIndex].stock} left in Stock'
                                      'showModalBottomSheet');
                            }
                          } else {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.only(
                                  topLeft:
                                  Radius.circular(20.0),
                                  topRight:
                                  Radius.circular(20.0),
                                ),
                              ),
                              clipBehavior:
                              Clip.antiAliasWithSaveLayer,
                              context: context,
                              builder: (context) {
                                return ListView(
                                  shrinkWrap: true,
                                  prototypeItem: Container(
                                    height:
                                    MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.9,
                                    child: BottomSheetsWidget(
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: products.isloading == true
                        ? SizedBox(
                        child: CircularProgressIndicator(
                          color: kMainColor,
                        ),
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.1)
                        : InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft:
                              Radius.circular(20.0),
                              topRight:
                              Radius.circular(20.0),
                            ),
                          ),
                          clipBehavior:
                          Clip.antiAliasWithSaveLayer,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 350,
                              child: BottomSheetsWidget(
                                index: index,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)),
                            border: Border.all(
                              color: Color(
                                  0xffec9458), //|| kMainColor, |
                            )),
                        height: MediaQuery.of(context)
                            .size
                            .height *
                            0.05,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              ('${products.productDetails!.length.toString()} Options'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: buttonColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: products.isloading == true
                        ? SizedBox(
                        child: CircularProgressIndicator(
                          color: kMainColor,
                        ),
                        width: MediaQuery.of(context).size.width *
                            0.1)
                        : Container(
                      alignment: Alignment.center,
                      height:
                      MediaQuery.of(context).size.height *
                          0.05,
                      decoration: BoxDecoration(
                        border: Border.all(color: buttonColor),
                        borderRadius:
                        BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(3),
                            icon: Icon(Icons.remove),
                            color: buttonColor,
                            onPressed: () async {
                              if (products
                                  .productDetails!.length ==
                                  1) {
                                await context
                                    .read<ProductProvider>()
                                    .decreaseCount(
                                    index: index,
                                    productNewIndex: products
                                        .productDetailsIndex);
                                // await context.read<ProductProvider>().getProductsByCategory(subcategories[context.read<ProductProvider>().tabValue].sectionid!, '', isLoading: false);
                              } else {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.only(
                                      topLeft:
                                      Radius.circular(20.0),
                                      topRight:
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  clipBehavior: Clip
                                      .antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 350,
                                      child: BottomSheetsWidget(
                                        index: index,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          Text(
                              products.totproductQty!
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium),
                          //Text(products[index].productDetails![products[index].productDetailsIndex].productQty.toString(), style: Theme.of(context).textTheme.bodyMedium),
                          IconButton(
                              padding: EdgeInsets.all(3.0),
                              icon: Icon(
                                Icons.add,
                              ),
                              color: buttonColor,
                              onPressed: () async {
                                if (products.productDetails!
                                    .length ==
                                    1) {
                                  print("printingggggg");
                                  if (products
                                      .productDetails![products
                                      .productDetailsIndex]
                                      .productQty! <
                                      products
                                          .productDetails![products
                                          .productDetailsIndex]
                                          .stock!) {
                                    await context
                                        .read<ProductProvider>()
                                        .increaseCount(
                                        index: index,
                                        productNewIndex:
                                        products
                                            .productDetailsIndex);
                                    // await context.read<ProductProvider>().getProductsByCategory(subcategories[context.read<ProductProvider>().tabValue].sectionid!, '', isLoading: false);
                                  } else {
                                    showMessage(
                                        'Only ${products.productDetails![products.productDetailsIndex].stock} left in Stock');
                                  }
                                } else {
                                  showModalBottomSheet(
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.only(
                                        topLeft:
                                        Radius.circular(
                                            20.0),
                                        topRight:
                                        Radius.circular(
                                            20.0),
                                      ),
                                    ),
                                    clipBehavior: Clip
                                        .antiAliasWithSaveLayer,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 350,
                                        child:
                                        BottomSheetsWidget(
                                          index: index,
                                        ),
                                      );
                                    },
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  )
                      : Container(
                      child: Text(
                        'Out of Stock',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.red),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Theme.of(context).cardColor,
                thickness: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    products.productDescription != null ? 'Description' : ''),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8, right: 8, bottom: 60),
                child: Text(products.productDescription ?? ''),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
          context.watch<ProductProvider>().cartitems?.d?.length != 0 &&
                  context.watch<ProductProvider>().cartitems?.d != null
              ? Positioned(
                  width: MediaQuery.of(context).size.width,
                  bottom: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF158644), // Dark Green
                          Color(0xFF65B84C),
                        ],
                      ),
                      boxShadow: [],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/icons/ic_cart wt.png',
                          height: 19.0,
                          width: 18.3,
                        ),
                        SizedBox(width: 20.7),
                        Text(
                          'Items: ${context.watch<ProductProvider>().cartitems?.d?.length} | \u{20B9} ${checkout?[0].posttaxamount}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                        Spacer(),
                        FadedScaleAnimation(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.read<ProductProvider>().getcartitems();
                              Navigator.pushNamed(context, PageRoutes.viewCart);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.viewCart!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: kMainColor,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                        // : Container(),
                      ],
                    ),
                    height: 60.0,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  final index;
  BottomSheetWidget({this.index});
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final products = context.watch<ProductProvider>().selectedProducts;
    return FadedSlideAnimation(
      child: Column(
        children: <Widget>[
          Container(
            height: 100.7,
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(15.0),
            child: ListTile(
              title: Text(products!.productName!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
              subtitle: Text(AppLocalizations.of(context)!.vegetable!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: products.productDetails!.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                  title: Text(products.productDetails![index].productWeight!),
                  value:
                      products.productDetails![index].productWeight.toString(),
                  groupValue: products
                      .productDetails![products.productDetailsIndex]
                      .productWeight,
                  onChanged: (value) {
                    context
                        .read<ProductProvider>()
                        .selectedDescItemWeight(products, index);
                    Navigator.pop(context);
                  });
            },
          ),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}

//   Widget build(
//     BuildContext context,
//   ) {
//     final products = context.watch<ProductProvider>().products?.d;
//     return FadedSlideAnimation(
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: MediaQuery.of(context).size.height * 0.088,
//               color: Theme.of(context).cardColor,
//               padding: EdgeInsets.all(15.0),
//               child: ListTile(
//                 title: Text(products![widget.index].productName!,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
//                 subtitle: Text(AppLocalizations.of(context)!.vegetable!,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(fontSize: 15)),
//               ),
//             ),
//             SizedBox(height: 5),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.190,
//               child: Scrollbar(
//                 thickness: 8,
//                 thumbVisibility: true,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: products[widget.index].productDetails!.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Card(
//                         margin: EdgeInsets.all(2),
//                         // elevation: 4,
//                         color: Colors.white70,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: ListTile(
//                             title: Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       products[widget.index]
//                                           .productDetails![index]
//                                           .productWeight!,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium!
//                                           .copyWith(fontSize: 15),
//                                     ),
//                                   ],
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                     '\₹ ${products[widget.index].productDetails![index].productRate.toString()}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium!
//                                         .copyWith(fontSize: 15)),
//                                 Spacer(),
//                                 products[widget.index]
//                                             .productDetails![
//                                                 products[widget.index]
//                                                     .productDetailsIndex]
//                                             .outofstock ==
//                                         0
//                                     ? products[widget.index]
//                                                     .productDetails![products[
//                                                             widget.index]
//                                                         .productDetailsIndex]
//                                                     .productQty ==
//                                                 0 ||
//                                             products[widget.index]
//                                                     .productDetails![products[
//                                                             widget.index]
//                                                         .productDetailsIndex]
//                                                     .productQty ==
//                                                 null
//                                         ? Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 8.0),
//                                             child: products[widget.index]
//                                                         .isloading ==
//                                                     true
//                                                 ? SizedBox(
//                                                     child:
//                                                         CircularProgressIndicator(
//                                                       color: kMainColor,
//                                                     ),
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width *
//                                                             0.1)
//                                                 : InkWell(
//                                                     child: Container(
//                                                         width: 70,
//                                                         decoration:
//                                                             BoxDecoration(
//                                                                 borderRadius: BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             20.0)),
//                                                                 border:
//                                                                     Border.all(
//                                                                   color: Color(
//                                                                       0xffec9458), //|| kMainColor, |
//                                                                 )),
//                                                         height: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .height *
//                                                             0.05,
//                                                         child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(8.0),
//                                                           child:
//                                                               /*  products[index].isloading == true
//                                                                                     ? SizedBox(child: CircularProgressIndicator(), width: 30)
//                                                                                     :  */
//                                                               Row(
//                                                             children: [
//                                                               Icon(
//                                                                 Icons
//                                                                     .shopping_cart_outlined,
//                                                                 color:
//                                                                     buttonColor, // kMainColor,
//                                                                 size: 15,
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 5),
//                                                               Text(
//                                                                 AppLocalizations.of(
//                                                                         context)!
//                                                                     .add!,
//                                                                 // products[widget
//                                                                 //         .index]
//                                                                 //     .productDetails![
//                                                                 //         index]
//                                                                 //     .productRate
//                                                                 //     .toString(),
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                                 style: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyMedium!
//                                                                     .copyWith(
//                                                                         color:
//                                                                             buttonColor,
//                                                                         fontWeight:
//                                                                             FontWeight.bold),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         )),
//                                                     onTap: () {
//                                                       if (products[widget.index]
//                                                               .productDetails![
//                                                                   products[widget
//                                                                           .index]
//                                                                       .productDetailsIndex]
//                                                               .productQty! <
//                                                           products[widget.index]
//                                                               .productDetails![
//                                                                   products[widget
//                                                                           .index]
//                                                                       .productDetailsIndex]
//                                                               .stock!) {
//                                                         context
//                                                             .read<
//                                                                 ProductProvider>()
//                                                             .increaseCount(
//                                                                 index: widget
//                                                                     .index,
//                                                                 productNewIndex:
//                                                                     index);
//                                                       } else {
//                                                         showMessage(
//                                                             'Only ${products[widget.index].productDetails![products[widget.index].productDetailsIndex].stock} left in Stock');
//                                                       }
//                                                     }),
//                                           )
//                                         : Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 8.0),
//                                             child: products[widget.index]
//                                                         .isloading ==
//                                                     true
//                                                 ? SizedBox(
//                                                     child:
//                                                         CircularProgressIndicator(
//                                                       color: kMainColor,
//                                                     ),
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width *
//                                                             0.1)
//                                                 : Container(
//                                                     alignment: Alignment.center,
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .height *
//                                                             0.05,
//                                                     decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: buttonColor),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               30.0),
//                                                     ),
//                                                     child: /*  products[index].isloading == true
//                                                                               ? SizedBox(child: CircularProgressIndicator(), width: 30)
//                                                                               : */
//                                                         Row(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: <Widget>[
//                                                         IconButton(
//                                                           padding:
//                                                               EdgeInsets.all(3),
//                                                           icon: Icon(
//                                                               Icons.remove),
//                                                           color: buttonColor,
//                                                           onPressed: () {
//                                                             context
//                                                                 .read<
//                                                                     ProductProvider>()
//                                                                 .decreaseCount(
//                                                                     index: widget
//                                                                         .index,
//                                                                     productNewIndex:
//                                                                         index);
//                                                           },
//                                                         ),
//                                                         Text(
//                                                             products[widget
//                                                                     .index]
//                                                                 .productDetails![
//                                                                     products[widget
//                                                                             .index]
//                                                                         .productDetailsIndex]
//                                                                 .productQty
//                                                                 .toString(),
//                                                             style: Theme.of(
//                                                                     context)
//                                                                 .textTheme
//                                                                 .bodyMedium),
//                                                         IconButton(
//                                                             padding:
//                                                                 EdgeInsets.all(
//                                                                     3.0),
//                                                             icon: Icon(
//                                                               Icons.add,
//                                                             ),
//                                                             color: buttonColor,
//                                                             onPressed: () {
//                                                               if (products[widget
//                                                                           .index]
//                                                                       .productDetails![
//                                                                           products[widget.index]
//                                                                               .productDetailsIndex]
//                                                                       .productQty! <
//                                                                   products[widget
//                                                                           .index]
//                                                                       .productDetails![
//                                                                           products[widget.index]
//                                                                               .productDetailsIndex]
//                                                                       .stock!) {
//                                                                 context
//                                                                     .read<
//                                                                         ProductProvider>()
//                                                                     .increaseCount(
//                                                                         index: widget
//                                                                             .index,
//                                                                         productNewIndex:
//                                                                             index);
//                                                               } else {
//                                                                 showMessage(
//                                                                     'Only ${products[widget.index].productDetails![products[widget.index].productDetailsIndex].stock} left in Stock');
//                                                               }
//                                                             }),
//                                                       ],
//                                                     ),
//                                                   ),
//                                           )
//                                     : Container(
//                                         child: Text(
//                                         'Out of Stock',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium!
//                                             .copyWith(color: Colors.red),
//                                       )),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             context.watch<ProductProvider>().cartitems?.d?.length != 0 &&
//                     context.watch<ProductProvider>().cartitems?.d != null
//                 ? Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Row(
//                         children: <Widget>[
//                           Image.asset(
//                             'images/icons/ic_cart wt.png',
//                             height: 19.0,
//                             width: 18.3,
//                           ),
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                           ),
//                           Text(
//                             'Items: ${context.watch<ProductProvider>().cartitems?.d?.length}',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(color: Colors.white),
//                           ),
//                           Spacer(),
//                           FadedScaleAnimation(
//                             child: TextButton(
//                               style: TextButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                               ),
//                               onPressed: () {
//                                 context.read<ProductProvider>().getcartitems();
//                                 context.read<ProductProvider>().getcarttotal();
//                                 Navigator.pushNamed(
//                                     context, PageRoutes.viewCart);
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Text(
//                                   AppLocalizations.of(context)!.viewCart!,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(
//                                           color: buttonColor,
//                                           fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       color: kMainColor,
//                       height: 60.0,
//                     ),
//                   )
//                 : Container()
//           ],
//         ),
//       ),
//       beginOffset: Offset(0, 0.3),
//       endOffset: Offset(0, 0),
//       slideCurve: Curves.linearToEaseOut,
//     );
//   }
// }
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/custom_appbar.dart';
import 'package:delivoo/Components/search_deleagate.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Pages/productDescription.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/category_provider.dart';
import 'package:delivoo/Providers.dart/store_provider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabcontroller;

  @override
  void initState() {
    final subcategories = context.read<CategoryProvider>().subcategories?.d;
    _tabcontroller = TabController(
      initialIndex: context.read<ProductProvider>().tabIndex,
      length: subcategories!.length,
      vsync: this,
    );
    if (context.read<ProductProvider>().cartitems != null ||
        context.read<ProductProvider>().cartitems?.d?.length != 0) {}

    context.read<ProductProvider>().getcarttotal();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final products = context.watch<ProductProvider>().products?.d;
    final subcategories = context.watch<CategoryProvider>().subcategories?.d;
    final checkout = context.watch<ProductProvider>().cartTotal?.d;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: DefaultTabController(
              length: subcategories!.length,
              child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(250.0),
                    child: CustomAppBar(
                      titleWidget: Text(
                          context.watch<StoreProvider>()
                              .selectedstore!.shopName !=
                              '' &&
                              context
                                  .watch<StoreProvider>()
                                  .selectedstore!
                                  .shopName !=
                                  null
                              ? '${context.watch<StoreProvider>().selectedstore!.shopName!.toString()}'
                              : '',
                          style:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          )),
                      actions: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: InkWell(
                              onTap: () async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await context.read<ProductProvider>().getProductsByCategory(
                                  catId: prefs.getString('catId'),
                                  sectiontId: "0",
                                  searchtxt: '',
                                );
                                showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate());
                              },
                              child: Icon(Icons.search, color: Colors.white)),
                        )
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(0.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns items properly
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 12, // Increased for better visibility
                                      ),
                                      SizedBox(width: 5.0),
                                      Expanded( // Prevents overflow
                                        child: Text(
                                          context.watch<StoreProvider>().selectedstore?.saddress ?? '',
                                          maxLines: 2, // Allows wrapping
                                          overflow: TextOverflow.ellipsis, // Prevents text from overflowing
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  context
                                      .watch<StoreProvider>()
                                      .selectedstore!
                                      .delTime !=
                                      ''
                                      ? Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 10,
                                  )
                                      : Container(),
                                  SizedBox(width: 10.0),
                                  Text(
                                      maxLines: 2,
                                      context
                                          .watch<StoreProvider>()
                                          .selectedstore!
                                          .delTime !=
                                          ''
                                          ? context
                                          .watch<StoreProvider>()
                                          .selectedstore!
                                          .delTime!
                                          .toString()
                                          : '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              NotificationListener<ScrollUpdateNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    return true;
                                  },
                                  child: SingleChildScrollView(
                                    child: Container(
                                        padding: EdgeInsets.zero, // Ensure the outer container has zero padding
                                        child: TabBar(
                                          isScrollable: true,
                                          tabAlignment: TabAlignment.start,
                                          padding: EdgeInsets.zero, // Ensure the TabBar padding is zero
                                          labelPadding: EdgeInsets.zero, // Ensure the labelPadding is zero
                                          controller: _tabcontroller,
                                          onTap: (value) {
                                            Future.delayed(Duration(milliseconds: 300), () async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setString("sectionId", subcategories[value].sectionid!);
                                              context.read<ProductProvider>().getTabIndex(value);
                                              context.read<ProductProvider>().getProductsByCategory(
                                                catId: prefs.getString('catId'),
                                                sectiontId: subcategories[value].sectionid!,
                                                searchtxt: '',
                                              );
                                            });
                                          },
                                          tabs: List.generate(
                                            subcategories.length,
                                                (index) => Container(
                                              padding: EdgeInsets.zero, // Ensure the container padding is zero
                                              margin: EdgeInsets.zero, // Ensure the container margin is zero
                                              child: Container(
                                                height: 110,
                                                width: 120,
                                                padding: EdgeInsets.zero, // Ensure the inner container padding is zero
                                                margin: EdgeInsets.zero, // Ensure the inner container margin is zero
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 5),
                                                    subcategories[index].sectionimg != ''
                                                        ? CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: CachedNetworkImageProvider(
                                                        BaseUrl + SUBCAT_IMAGES + subcategories[index].sectionimg!,
                                                        cacheKey: subcategories[index].sectionimg,
                                                      ),
                                                    )
                                                        : CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage('images/logos/not-available.png'),
                                                    ),
                                                    SizedBox(height: 5),
                                                    SizedBox(
                                                      child: Padding(padding: EdgeInsets.only(left: 5, right: 5),
                                                        child: Text(
                                                          subcategories[index].sectionName!,
                                                          textAlign: TextAlign.center,
                                                          overflow: TextOverflow.clip,
                                                          maxLines: 2,
                                                          style: TextStyle(fontSize: 11),
                                                        ),),
                                                    ),
                                                    SizedBox(height: 5),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          labelColor: Colors.white,
                                          indicatorWeight: 5,
                                          indicator: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          unselectedLabelColor: Colors.white,
                                        )
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  body: products == null || products.length == 0
                      ? Center(
                    child: Image.asset(
                      'images/logos/soldout.png',
                      scale: 5,
                    ),
                  )
                      : TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabcontroller,
                    children:
                    List.generate(subcategories.length, (int index) {
                      return FadedScaleAnimation(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () async {
                                            await context
                                                .read<ProductProvider>()
                                                .getProductIndex(
                                                products[index],
                                                index);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDescription()));
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 90,
                                            child: Stack(
                                              children: [
                                                Align(
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child: products[index].productDetails![products[index].productDetailsIndex].discountPercentage !=
                                                        null &&
                                                        products[index]
                                                            .productDetails![products[index]
                                                            .productDetailsIndex]
                                                            .discountPercentage !=
                                                            '0' &&
                                                        products[index]
                                                            .productDetails![products[index]
                                                            .productDetailsIndex]
                                                            .discountPercentage !=
                                                            '0.00' &&
                                                        double.parse(products[index]
                                                            .productDetails![products[index].productDetailsIndex]
                                                            .discountPercentage
                                                            .toString()) >
                                                            0
                                                        ? Container(
                                                        width: 60,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: buttonColor,
                                                            // kMainColor,
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(7), bottomRight: Radius.circular(7))),
                                                        child: Padding(
                                                            padding: EdgeInsets.only(left: 2),
                                                            child: Center(
                                                              child: Text(
                                                                  '${double.parse(products[index].productDetails![products[index].productDetailsIndex].discountPercentage!).toStringAsFixed(0)}' +
                                                                      '% off',
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.bold)),
                                                            )))
                                                        : Container())
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                              image: products[index]
                                                  .productDetails![
                                              products[index]
                                                  .productDetailsIndex]
                                                  .productimage !=
                                                  null &&
                                                  products[index]
                                                      .productDetails![
                                                  products[index]
                                                      .productDetailsIndex]
                                                      .productimage !=
                                                      '0'
                                                  ? DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    BaseUrl +
                                                        'skuimages/' +
                                                        (products[index].productDetails![products[index].productDetailsIndex].productimage !=
                                                            '0'
                                                            ? products[index]
                                                            .productDetails![products[index]
                                                            .productDetailsIndex]
                                                            .productimage
                                                            : (products[index]
                                                            .productImage))!,
                                                    cacheKey: products[
                                                    index]
                                                        .productDetails![
                                                    products[index]
                                                        .productDetailsIndex]
                                                        .productimage!),
                                                onError: (exception,
                                                    stackTrace) {
                                                  products[index]
                                                      .productDetails![
                                                  products[
                                                  index]
                                                      .productDetailsIndex]
                                                      .productimage = null;
                                                },
                                              )
                                                  : products[index]
                                                  .productImage !=
                                                  null &&
                                                  products[index]
                                                      .productImage !=
                                                      '0'
                                                  ? DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    BaseUrl +
                                                        'skuimages/' +
                                                        products[index]
                                                            .productImage!,
                                                    cacheKey: products[
                                                    index]
                                                        .productImage!),
                                                onError: (exception,
                                                    stackTrace) {
                                                  products[index]
                                                      .productImage =
                                                  null;
                                                },
                                              )
                                                  : DecorationImage(
                                                image:
                                                AssetImage(
                                                  'images/logos/not-available.png',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                    products[index]
                                                        .productName ??
                                                        '',
                                                    maxLines: 3,
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis)),
                                              ),
                                              SizedBox(height: 8.0),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 22.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        '\₹ ${products[index].productDetails![products[index].productDetailsIndex].productRate!}',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyMedium),
                                                    SizedBox(width: 5),
                                                    products[index].productDetails![products[index].productDetailsIndex].productMrp !=
                                                        '0' &&
                                                        double.parse(products[index]
                                                            .productDetails![products[index]
                                                            .productDetailsIndex]
                                                            .productMrp!) >
                                                            products[index]
                                                                .productDetails![products[index]
                                                                .productDetailsIndex]
                                                                .productRate!
                                                        ? Text(
                                                        '\₹ ${products[index].productDetails![products[index].productDetailsIndex].productMrp!}',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                            color:
                                                            Colors.grey,
                                                            decoration: TextDecoration.lineThrough))
                                                        : Container(),
                                                    Spacer(),
                                                    products[index]
                                                        .productDetails![
                                                    products[index]
                                                        .productDetailsIndex]
                                                        .productQty! >
                                                        0
                                                        ? Text(
                                                        '\₹ ${(products[index].productDetails![products[index].productDetailsIndex].productRate! * products[index].productDetails![products[index].productDetailsIndex].productQty!.toDouble()).toDouble().toStringAsFixed(2)}',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyMedium)
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Container(
                                                    height: 30.0,
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        12.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                      MainAxisSize
                                                          .max,
                                                      children: <Widget>[
                                                        Text(
                                                          products[index]
                                                              .productDetails![
                                                          products[index].productDetailsIndex]
                                                              .productWeight ??
                                                              '',
                                                          style: Theme.of(
                                                              context)
                                                              .textTheme
                                                              .bodyMedium,
                                                        ),
                                                        SizedBox(
                                                          width: 2.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  products[index]
                                                      .productDetails![
                                                  products[index]
                                                      .productDetailsIndex]
                                                      .outofstock ==
                                                      0
                                                      ? products[index]
                                                      .totproductQty ==
                                                      0
                                                      ? products[index]
                                                      .productDetails!
                                                      .length ==
                                                      1
                                                      ? Padding(
                                                    padding:
                                                    const EdgeInsets.only(right: 8.0),
                                                    child: products[index].isloading ==
                                                        true
                                                        ? SizedBox(
                                                        child: CircularProgressIndicator(
                                                          color: kMainColor,
                                                        ),
                                                        width: MediaQuery.of(context).size.width * 0.1)
                                                        : InkWell(
                                                        child: Container(
                                                            width: 70,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                border: Border.all(
                                                                  color: Color(0xffec9458), //|| kMainColor, |
                                                                )),
                                                            height: MediaQuery.of(context).size.height * 0.05,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.shopping_cart_outlined,
                                                                    color: buttonColor, // kMainColor,
                                                                    size: 15,
                                                                  ),
                                                                  SizedBox(width: 5),
                                                                  Text(
                                                                    AppLocalizations.of(context)!.add!,
                                                                    textAlign: TextAlign.center,
                                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: buttonColor, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        onTap: () async {
                                                          if (products[index].productDetails!.length == 1) {
                                                            if (products[index].productDetails![products[index].productDetailsIndex].productQty! < products[index].productDetails![products[index].productDetailsIndex].stock!) {
                                                              await context.read<ProductProvider>().increaseCount(index: index, productNewIndex: products[index].productDetailsIndex);
                                                              // await context.read<ProductProvider>().getProductsByCategory(subcategories[context.read<ProductProvider>().tabValue].sectionid!, '', isLoading: false);
                                                            } else {
                                                              showMessage('Only ${products[index].productDetails![products[index].productDetailsIndex].stock} left in Stock' 'showModalBottomSheet');
                                                            }
                                                          } else {
                                                            showModalBottomSheet(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(20.0),
                                                                  topRight: Radius.circular(20.0),
                                                                ),
                                                              ),
                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                              context: context,
                                                              builder: (context) {
                                                                return ListView(
                                                                  shrinkWrap: true,
                                                                  prototypeItem: Container(
                                                                    height: MediaQuery.of(context).size.height * 0.9,
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
                                                    padding:
                                                    const EdgeInsets.only(right: 8.0),
                                                    child: products[index].isloading ==
                                                        true
                                                        ? SizedBox(
                                                        child: CircularProgressIndicator(
                                                          color: kMainColor,
                                                        ),
                                                        width: MediaQuery.of(context).size.width * 0.1)
                                                        : InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(20.0),
                                                              topRight: Radius.circular(20.0),
                                                            ),
                                                          ),
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                            border: Border.all(
                                                              color: Color(0xffec9458), //|| kMainColor, |
                                                            )),
                                                        height: MediaQuery.of(context).size.height * 0.05,
                                                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text(
                                                              ('${products[index].productDetails!.length.toString()} Options'),
                                                              style: Theme.of(context).textTheme.bodyMedium,
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
                                                    padding: const EdgeInsets
                                                        .only(
                                                        right:
                                                        8.0),
                                                    child: products[index].isloading ==
                                                        true
                                                        ? SizedBox(
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: kMainColor,
                                                        ),
                                                        width:
                                                        MediaQuery.of(context).size.width * 0.1)
                                                        : Container(
                                                      alignment:
                                                      Alignment.center,
                                                      height:
                                                      MediaQuery.of(context).size.height * 0.05,
                                                      decoration:
                                                      BoxDecoration(
                                                        border: Border.all(color: buttonColor),
                                                        borderRadius: BorderRadius.circular(30.0),
                                                      ),
                                                      child:
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            padding: EdgeInsets.all(3),
                                                            icon: Icon(Icons.remove),
                                                            color: buttonColor,
                                                            onPressed: () async {
                                                              if (products[index].productDetails!.length == 1) {
                                                                await context.read<ProductProvider>().decreaseCount(index: index, productNewIndex: products[index].productDetailsIndex);
                                                                // await context.read<ProductProvider>().getProductsByCategory(subcategories[context.read<ProductProvider>().tabValue].sectionid!, '', isLoading: false);
                                                              } else {
                                                                showModalBottomSheet(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(20.0),
                                                                      topRight: Radius.circular(20.0),
                                                                    ),
                                                                  ),
                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                                          Text(products[index].totproductQty!.toString(), style: Theme.of(context).textTheme.bodyMedium),
                                                          //Text(products[index].productDetails![products[index].productDetailsIndex].productQty.toString(), style: Theme.of(context).textTheme.bodyMedium),
                                                          IconButton(
                                                              padding: EdgeInsets.all(3.0),
                                                              icon: Icon(
                                                                Icons.add,
                                                              ),
                                                              color: buttonColor,
                                                              onPressed: () async {
                                                                if (products[index].productDetails!.length == 1) {
                                                                  print("printingggggg");
                                                                  if (products[index].productDetails![products[index].productDetailsIndex].productQty! < products[index].productDetails![products[index].productDetailsIndex].stock!) {
                                                                    await context.read<ProductProvider>().increaseCount(index: index, productNewIndex: products[index].productDetailsIndex);
                                                                    // await context.read<ProductProvider>().getProductsByCategory(subcategories[context.read<ProductProvider>().tabValue].sectionid!, '', isLoading: false);
                                                                  } else {
                                                                    showMessage('Only ${products[index].productDetails![products[index].productDetailsIndex].stock} left in Stock');
                                                                  }
                                                                } else {
                                                                  showModalBottomSheet(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(20.0),
                                                                        topRight: Radius.circular(20.0),
                                                                      ),
                                                                    ),
                                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      : Container(
                                                      child: Text(
                                                        'Out of Stock',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                            color: Colors
                                                                .red),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Theme.of(context).cardColor,
                                    thickness: 8.0,
                                  ),
                                ],
                              );
                            }),
                      );
                    }).toList(),
                  )),
            ),
          ),
          context.watch<ProductProvider>().cartitems?.d?.length != 0 &&
                  context.watch<ProductProvider>().cartitems?.d != null
              ? Align(
            alignment: Alignment.bottomCenter,
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
                    'Items: ${context.watch<ProductProvider>().cartitems?.d?.length} | \u{20B9} ${checkout?[0].posttaxamount ?? "0"}',
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
                        context.read<ProductProvider>().getcarttotal();
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
                              color: buttonColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
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
    final products = context.watch<ProductProvider>().products?.d;
    return FadedSlideAnimation(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.088,
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.all(15.0),
              child: ListTile(
                title: Text(products![widget.index].productName!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                subtitle: Text(AppLocalizations.of(context)!.vegetable!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15)),
                // trailing:
                //  TextButton(
                //   style: TextButton.styleFrom(
                //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: Text(
                //     AppLocalizations.of(context)!.add!,
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyMedium!
                //         .copyWith(color: kMainColor, fontWeight: FontWeight.bold),
                //   ),
                // ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Scrollbar(
                thickness: 10,
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products[widget.index].productDetails!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: RadioListTile(
                          title: Text(
                              products[widget.index]
                                  .productDetails![index]
                                  .productWeight!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15)),
                          secondary: Text(
                              '\₹ ${products[widget.index].productDetails![index].productRate.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15)),
                          // subtitle: Text(
                          //   AppLocalizations.of(context)!.add!,
                          //   textAlign: TextAlign.center,
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyMedium!
                          //       .copyWith(
                          //           color: buttonColor,
                          //           fontWeight: FontWeight.bold),
                          // ),
                          value: products[widget.index]
                              .productDetails![index]
                              .productWeight
                              .toString(),
                          groupValue: products[widget.index]
                              .productDetails![
                                  products[widget.index].productDetailsIndex]
                              .productWeight,
                          onChanged: (value) {
                            context
                                .read<ProductProvider>()
                                .selectedItemWeight(widget.index, index);
                            Navigator.pop(context);
                          }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}

class BottomSheetsWidget extends StatefulWidget {
  final index, productNewIndex;
  BottomSheetsWidget({this.index, this.productNewIndex});
  @override
  _BottomSheetsWidgetState createState() => _BottomSheetsWidgetState();
}

class _BottomSheetsWidgetState extends State<BottomSheetsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final products = context.watch<ProductProvider>().products?.d;
    // final subcategories = context.watch<CategoryProvider>().subcategories?.d;
    return FadedSlideAnimation(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 70,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: products![widget.index]
                                                  .productDetails![
                                                      products[widget.index]
                                                          .productDetailsIndex]
                                                  .discountPercentage !=
                                              '0' &&
                                          products[widget.index]
                                                  .productDetails![
                                                      products[widget.index]
                                                          .productDetailsIndex]
                                                  .discountPercentage !=
                                              '0.00' &&
                                          double.parse(products[widget.index]
                                                  .productDetails![
                                                      products[widget.index]
                                                          .productDetailsIndex]
                                                  .discountPercentage
                                                  .toString()) >
                                              0
                                      ? Container(
                                          width: 60,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              color: buttonColor,
                                              // kMainColor,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7), bottomRight: Radius.circular(7))),
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 2),
                                              child: Center(
                                                child: Text(
                                                    '${double.parse(products[widget.index].productDetails![products[widget.index].productDetailsIndex].discountPercentage!).toStringAsFixed(0)}' +
                                                        '% off',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )))
                                      : Container())
                            ],
                          ),
                          decoration: BoxDecoration(
                            image: products[widget.index]
                                            .productDetails![
                                                products[widget.index]
                                                    .productDetailsIndex]
                                            .productimage !=
                                        null &&
                                    products[widget.index]
                                            .productDetails![
                                                products[widget.index]
                                                    .productDetailsIndex]
                                            .productimage !=
                                        '0'
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        BaseUrl +
                                            'skuimages/' +
                                            (products[widget.index]
                                                        .productDetails![products[
                                                                widget.index]
                                                            .productDetailsIndex]
                                                        .productimage !=
                                                    '0'
                                                ? products[widget.index]
                                                    .productDetails![products[
                                                            widget.index]
                                                        .productDetailsIndex]
                                                    .productimage
                                                : (products[widget.index]
                                                    .productImage))!,
                                        cacheKey: products[widget.index]
                                            .productDetails![
                                                products[widget.index]
                                                    .productDetailsIndex]
                                            .productimage!),
                                    onError: (exception, stackTrace) {
                                      products[widget.index]
                                          .productDetails![
                                              products[widget.index]
                                                  .productDetailsIndex]
                                          .productimage = null;
                                    },
                                  )
                                : products[widget.index].productImage != null &&
                                        products[widget.index].productImage !=
                                            '0'
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            BaseUrl +
                                                'skuimages/' +
                                                products[widget.index]
                                                    .productImage!,
                                            cacheKey: products[widget.index]
                                                .productImage!),
                                        onError: (exception, stackTrace) {
                                          products[widget.index].productImage =
                                              null;
                                        },
                                      )
                                    : DecorationImage(
                                        image: AssetImage(
                                          'images/logos/not-available.png',
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(products[widget.index].productName!,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(width: 20)
                ],
              ),
            ),
            // Divider(
            //   color: Colors.black12,
            //   thickness: 5,
            // ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.200,
              height: 230,
              width: 490,
              child: Scrollbar(
                // thickness: 8,
                thumbVisibility: true,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products[widget.index].productDetails!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Divider(
                            color: Theme.of(context).cardColor,
                            thickness: 5,
                          ),
                          Container(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 70,
                                        child: Text(
                                          products[widget.index]
                                              .productDetails![index]
                                              .productWeight!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 70,
                                        child: Text(
                                            '\₹ ${products[widget.index].productDetails![index].productRate.toString()}',
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(fontSize: 15)),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      products[widget.index]
                                                  .productDetails![index]
                                                  .isloading ==
                                              true
                                          ? CircularProgressIndicator(
                                              color: kMainColor,
                                            )
                                          : Container(
                                              height: 40,
                                              width: 110,
                                              child: products[widget.index]
                                                          .productDetails![
                                                              index]
                                                          .outofstock ==
                                                      0
                                                  ? products[widget.index]
                                                                  .productDetails![
                                                                      index]
                                                                  .productQty ==
                                                              0 ||
                                                          products[widget.index]
                                                                  .productDetails![
                                                                      index]
                                                                  .productQty ==
                                                              null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 40.0),
                                                          child: InkWell(
                                                              child: Container(
                                                                  width: 70,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              20.0)),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0xffec9458), //|| kMainColor, |
                                                                          )),
                                                                  // height: MediaQuery.of(context).size.height * 0.03,
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        /*  products[index].isloading == true
                                                                                          ? SizedBox(child: CircularProgressIndicator(), width: 30)
                                                                                          :  */
                                                                        Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .shopping_cart_outlined,
                                                                          color:
                                                                              buttonColor, // kMainColor,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)!
                                                                              .add!,
                                                                          // products[widget
                                                                          //         .index]
                                                                          //     .productDetails![
                                                                          //         index]
                                                                          //     .productRate
                                                                          //     .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .copyWith(color: buttonColor, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                              onTap: () async {
                                                                if (products[widget
                                                                            .index]
                                                                        .productDetails![
                                                                            index]
                                                                        .productQty! <
                                                                    products[widget
                                                                            .index]
                                                                        .productDetails![
                                                                            index]
                                                                        .stock!) {
                                                                  //  await context
                                                                  //     .read<
                                                                  //         ProductProvider>()
                                                                  //     .selectedItemWeight(
                                                                  //         widget.index,
                                                                  //         index);

                                                                  await context
                                                                      .read<
                                                                          ProductProvider>()
                                                                      .increaseCount(
                                                                          index: widget
                                                                              .index,
                                                                          productNewIndex:
                                                                              index);
                                                                  // await context
                                                                  //     .read<
                                                                  //         ProductProvider>()
                                                                  //     .getProductsByCategory(
                                                                  //         subcategories?[context.read<ProductProvider>().tabValue]
                                                                  //             .sectionid!,
                                                                  //         '',
                                                                  //         isLoading:
                                                                  //             true);
                                                                } else {
                                                                  showMessage(
                                                                      'Only ${products[widget.index].productDetails![index].stock} left in Stock');
                                                                }
                                                              }),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 1.0),
                                                          child:

                                                              //  products[widget
                                                              //                 .index]
                                                              //             .productDetails![
                                                              //                 index]
                                                              //             .isloading ==
                                                              //         true
                                                              //     ? SizedBox(
                                                              //         child:
                                                              //             CircularProgressIndicator(
                                                              //           color: kMainColor,
                                                              //         ),
                                                              //         height:
                                                              //         width: 5)
                                                              //     :

                                                              Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.05,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      buttonColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40.0),
                                                            ),
                                                            child: /*  products[index].isloading == true
                                                                                    ? SizedBox(child: CircularProgressIndicator(), width: 30)
                                                                                    : */
                                                                Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                IconButton(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              3),
                                                                  icon: Icon(Icons
                                                                      .remove),
                                                                  color:
                                                                      buttonColor,
                                                                  onPressed:
                                                                      () async {
                                                                    await context
                                                                        .read<
                                                                            ProductProvider>()
                                                                        .decreaseCount(
                                                                            index:
                                                                                widget.index,
                                                                            productNewIndex: index);
                                                                    // await context
                                                                    //     .read<
                                                                    //         ProductProvider>()
                                                                    //     .getProductsByCategory(
                                                                    //         subcategories![context.read<ProductProvider>().tabValue]
                                                                    //             .sectionid!,
                                                                    //         '',
                                                                    //         isLoading:
                                                                    //             true);
                                                                  },
                                                                ),
                                                                Text(
                                                                    products[widget
                                                                            .index]
                                                                        .productDetails![
                                                                            index]
                                                                        .productQty
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium),
                                                                IconButton(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            3.0),
                                                                    icon: Icon(
                                                                      Icons.add,
                                                                    ),
                                                                    color:
                                                                        buttonColor,
                                                                    onPressed:
                                                                        () async {
                                                                      if (products[widget.index]
                                                                              .productDetails![
                                                                                  index]
                                                                              .productQty! <
                                                                          products[widget.index]
                                                                              .productDetails![index]
                                                                              .stock!) {
                                                                        await context.read<ProductProvider>().increaseCount(
                                                                            index:
                                                                                widget.index,
                                                                            productNewIndex: index);
                                                                        // await context.read<ProductProvider>().getProductsByCategory(
                                                                        //     subcategories![context.read<ProductProvider>().tabValue]
                                                                        //         .sectionid!,
                                                                        //     '',
                                                                        //     isLoading:
                                                                        //         true);
                                                                      } else {
                                                                        showMessage(
                                                                            'Only ${products[widget.index].productDetails![index].stock} left in Stock');
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
                                                            .copyWith(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                    ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Spacer(),
            context.watch<ProductProvider>().cartitems?.d?.length != 0 &&
                    context.watch<ProductProvider>().cartitems?.d != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'images/icons/ic_cart wt.png',
                            height: 19.0,
                            width: 18.3,
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            'Items: ${context.watch<ProductProvider>().cartitems?.d?.length}',
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
                                context.read<ProductProvider>().getcarttotal();
                                Navigator.pushNamed(
                                    context, PageRoutes.viewCart);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  AppLocalizations.of(context)!.viewCart!,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                          color: buttonColor,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      color: kMainColor,
                      height: 45,
                    ),
                  )
                : Container()
          ],
        ),
      ),
      beginOffset: Offset(0, 0.5),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}

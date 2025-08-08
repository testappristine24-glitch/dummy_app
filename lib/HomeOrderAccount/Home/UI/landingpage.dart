// ignore_for_file: unused_local_variable

import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Components/card_content.dart';
import 'package:delivoo/Components/reusable_card.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Providers.dart/banner_provider.dart';
import 'package:delivoo/Providers.dart/category_provider.dart';
import 'package:delivoo/Providers.dart/offer_provider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () {});

    super.initState();
  }

  var _bcurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories?.d;
    var height = MediaQuery.of(context).size.height;
    final banners = context.watch<Bannerprovider>().banners?.d;
    context.watch<Offerprovider>().offers;
    context.watch<CategoryProvider>().subcategories?.d;

    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              //Banner Section
              CarouselSlider(
                  options: CarouselOptions(
                    height: height * 0.2,
                    viewportFraction: 1,
                    aspectRatio: 2,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    pauseAutoPlayOnManualNavigate: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _bcurrentIndex = index;
                        //print('currentindex $_bcurrentIndex');
                      });
                    },
                  ),
                  items: banners?.map((item) {
                    return InkWell(
                      onTap: () {
                        context.read<CategoryProvider>().setSelectedIndex(0);
                        Navigator.pushNamed(context, PageRoutes.items);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        child: _buildItem(
                          BaseUrl + 'banners/' + item.bannerimg!,
                          item.bannreid!,
                        ),
                      ),
                    );
                  }).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners!.map((dots) {
                  int index = banners.indexOf(dots);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                        color: _bcurrentIndex == index
                            ? kMainColor
                            : Colors.white),
                  );
                }).toList(),
              ),

              ///offers section
              /* CarouselSlider(
                  options: CarouselOptions(
                    height: height * 0.2,
                    viewportFraction: 0.7,
                    aspectRatio: 16 / 9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    pauseAutoPlayOnManualNavigate: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _ocurrentIndex = index;
                      });
                    },
                  ),
                  items: offers.map((item) {
                    return InkWell(
                      onTap: () {
                        context.read<CategoryProvider>().setSelectedIndex(0);
                        context.read<ProductProvider>().getProductsByOffer("");
                        Navigator.pushNamed(context, PageRoutes.items);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: _buildItem(
                          item.offerImage!,
                          item.offerId!,
                        ),
                      ),
                    );
                  }).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: offers.map((dots) {
                  int index = offers.indexOf(dots);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                        color: _ocurrentIndex == index
                            ? Colors.blue
                            : Colors.white),
                  );
                }).toList(),
              ), */
              Text('Shop by Category',
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Container(
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  primary: true,
                  shrinkWrap: true,
                  itemCount: categories?.length,
                  itemBuilder: (context, index) {
                    return ReusableCard(
                        cardChild: CardContent(
                          image: categories![index].catimg != ''
                              ? NetworkImage(BaseUrl +
                                  SUBCAT_IMAGES +
                                  categories[index].catimg!)
                              : AssetImage('images/logos/not-available.png'),
                          text: categories[index].catName,
                        ),
                        onPress: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              'catId', categories[index].catid.toString());
                          prefs.setString(
                              "sectionId", categories[index].sectionid);
                          await context
                              .read<CategoryProvider>()
                              .getSubcategory(categories[index].catid);

                          var subcat =
                              context.read<CategoryProvider>().subcategories?.d;
                          await context
                              .read<ProductProvider>()
                              .getProductsByCategory(
                                catId: categories[index].catid,
                                searchtxt: '',
                                sectiontId: categories[index].sectionid,
                              );
                          if (subcat!.length.toString() != '0') {
                            Navigator.pushNamed(context, PageRoutes.items);
                          } else
                            showMessageDialog(context,
                                'No items in this category at this moment');
                        });
                  },
                ),
              ),
              /*  Text('Subcategories',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)), */
              /*  Container(
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  primary: true,
                  shrinkWrap: true,
                  itemCount: subcategories!.length,
                  itemBuilder: (context, index) {
                    return ReusableCard(
                        cardChild: CardContent(
                          image:
                              subcategories![index].sectionimg != ''
                                  ? NetworkImage(BaseUrl +
                                      SUBCAT_IMAGES +
                                      subcategories![index].sectionimg!)
                                  : AssetImage(
                                      'images/logos/not-available.png'),
                          text: subcategories[index].sectionName,
                        ),
                        onPress: () {
                          context
                              .read<CategoryProvider>()
                              .setSelectedIndex(index);
                          context.read<CategoryProvider>().getCategory();
                          context
                              .read<ProductProvider>()
                              .getProductsBySubCategory("");
                          Navigator.pushNamed(context, PageRoutes.items);
                        });
                  },
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }

  _buildItem(String imagePath, String title) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10.0,
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.network(
                imagePath,
                // "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
                fit: BoxFit.cover,
                width: 340,

                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Image Not Found');
                },
              ),
            ),
            /*  Container(
              alignment: Alignment.bottomLeft,
              width: constraints.biggest.width,
              height: constraints.biggest.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ), */
          ],
        );
      }),
    );
  }
}

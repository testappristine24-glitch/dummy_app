import 'dart:convert';

/* List<CartModel> cartModelFromJson(String str) =>
    List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  CartModel({
    this.productCode,
    this.productQty,
    this.productName,
    this.productWeight,
    this.productRate,
    this.productMrp,
    this.productStock,
    this.productImage,
    this.maxcount,
    this.orderid,
  });

  String? productCode;
  int? productQty;
  String? productName;
  String? productWeight;
  String? productRate;
  double? productMrp;
  int? productStock;
  dynamic productImage;
  int? maxcount;
  String? orderid;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        productCode: json["productCode"],
        productQty: json["productQty"],
        productName: json["productName"],
        productWeight: json["productWeight"],
        productRate: json["productRate"],
        productMrp: json['productMrp'],
        productStock: json["productStock"],
        productImage: json["productImage"],
        maxcount: json["maxcount"],
        orderid: json["Orderid"],
      );

  Map<String, dynamic> toJson() => {
        "productCode": productCode,
        "productQty": productQty,
        "productName": productName,
        "productWeight": productWeight,
        "productRate": productRate,
        "productMrp": productMrp,
        "productStock": productStock,
        "productImage": productImage,
        "maxcount": maxcount,
        "Orderid": orderid,
      };
}
 */
// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.d,
  });

  List<D>? d;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.productCode,
    this.productQty,
    this.productName,
    this.productWeight,
    this.productRate,
    this.productMrp,
    this.productStock,
    this.productImage,
    this.maxcount,
    this.totalamount,
    this.totWeight,
    this.cgsttax,
    this.sgsttax,
    this.orderid,
  });

  String? type;
  String? productCode;
  int? productQty;
  String? productName;
  String? productWeight;
  String? productRate;
  String? productMrp;
  int? productStock;
  String? productImage;
  int? maxcount;
  String? totalamount;
  double? totWeight;
  String? cgsttax;
  String? sgsttax;
  String? orderid;
  bool? isloading = false;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        productCode: json["productCode"],
        productQty: json["productQty"],
        productName: json["productName"],
        productWeight: json["productWeight"],
        productRate: json["productRate"],
        productMrp: json["productMrp"],
        productStock: json["productStock"],
        productImage: json["productImage"],
        maxcount: json["maxcount"],
        totalamount: json["totalamount"],
        totWeight: json["totWeight"].toDouble(),
        cgsttax: json["cgsttax"],
        sgsttax: json["sgsttax"],
        orderid: json["Orderid"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "productCode": productCode,
        "productQty": productQty,
        "productName": productName,
        "productWeight": productWeight,
        "productRate": productRate,
        "productMrp": productMrp,
        "productStock": productStock,
        "productImage": productImage,
        "maxcount": maxcount,
        "totalamount": totalamount,
        "totWeight": totWeight,
        "cgsttax": cgsttax,
        "sgsttax": sgsttax,
        "Orderid": orderid,
      };
}

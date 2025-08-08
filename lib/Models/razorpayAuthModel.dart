// To parse this JSON data, do
//
//     final razorpayAuthModel = razorpayAuthModelFromJson(jsonString);

import 'dart:convert';

RazorpayAuthModel razorpayAuthModelFromJson(String str) =>
    RazorpayAuthModel.fromJson(json.decode(str));

String razorpayAuthModelToJson(RazorpayAuthModel data) =>
    json.encode(data.toJson());

class RazorpayAuthModel {
  RazorpayAuthModel({
    required this.entity,
    required this.count,
    required this.items,
  });

  String entity;
  int count;
  List<Item> items;

  factory RazorpayAuthModel.fromJson(Map<String, dynamic> json) =>
      RazorpayAuthModel(
        entity: json["entity"],
        count: json["count"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "entity": entity,
        "count": count,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.id,
    required this.entity,
    required this.amount,
    required this.currency,
    required this.status,
    required this.orderId,
    this.invoiceId,
    required this.international,
    required this.method,
    required this.amountRefunded,
    this.refundStatus,
    required this.captured,
    required this.description,
    required this.cardId,
    required this.card,
    this.bank,
    this.wallet,
    this.vpa,
    required this.email,
    required this.contact,
    required this.notes,
    this.fee,
    this.tax,
    required this.errorCode,
    required this.errorDescription,
    required this.errorSource,
    required this.errorStep,
    required this.errorReason,
    required this.acquirerData,
    required this.createdAt,
    required this.accountId,
  });

  String id;
  String entity;
  int amount;
  String currency;
  String status;
  String orderId;
  dynamic invoiceId;
  bool international;
  String method;
  int amountRefunded;
  dynamic refundStatus;
  bool captured;
  String description;
  String cardId;
  Card card;
  dynamic bank;
  dynamic wallet;
  dynamic vpa;
  String email;
  String contact;
  List<dynamic> notes;
  dynamic fee;
  dynamic tax;
  String errorCode;
  String errorDescription;
  String errorSource;
  String errorStep;
  String errorReason;
  AcquirerData acquirerData;
  int createdAt;
  String accountId;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        entity: json["entity"] ?? "",
        amount: json["amount"] ?? "",
        currency: json["currency"] ?? "",
        status: json["status"] ?? "",
        orderId: json["order_id"] ?? "",
        invoiceId: json["invoice_id"] ?? "",
        international: json["international"] ?? false,
        method: json["method"] ?? "",
        amountRefunded: json["amount_refunded"] ?? "",
        refundStatus: json["refund_status"] ?? "",
        captured: json["captured"] ?? false,
        description: json["description"] ?? "",
        cardId: json["card_id"] ?? "",
        card: json["card"] != null
            ? Card.fromJson(json["card"])
            : Card.fromJson({}),
        bank: json["bank"] ?? "",
        wallet: json["wallet"] ?? "",
        vpa: json["vpa"] ?? "",
        email: json["email"] ?? "",
        contact: json["contact"] ?? "",
        notes: json["notes"] != null
            ? List<dynamic>.from(json["notes"].map((x) => x))
            : [],
        fee: json["fee"] ?? "",
        tax: json["tax"] ?? "",
        errorCode: json["error_code"] ?? "",
        errorDescription: json["error_description"] ?? "",
        errorSource: json["error_source"] ?? "",
        errorStep: json["error_step"] ?? "",
        errorReason: json["error_reason"] ?? "",
        acquirerData: json["acquirer_data"] != null
            ? AcquirerData.fromJson(json["acquirer_data"])
            : AcquirerData.fromJson({}),
        createdAt: json["created_at"] ?? "",
        accountId: json["account_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "currency": currency,
        "status": status,
        "order_id": orderId,
        "invoice_id": invoiceId,
        "international": international,
        "method": method,
        "amount_refunded": amountRefunded,
        "refund_status": refundStatus,
        "captured": captured,
        "description": description,
        "card_id": cardId,
        "card": card.toJson(),
        "bank": bank,
        "wallet": wallet,
        "vpa": vpa,
        "email": email,
        "contact": contact,
        "notes": List<dynamic>.from(notes.map((x) => x)),
        "fee": fee,
        "tax": tax,
        "error_code": errorCode,
        "error_description": errorDescription,
        "error_source": errorSource,
        "error_step": errorStep,
        "error_reason": errorReason,
        "acquirer_data": acquirerData.toJson(),
        "created_at": createdAt,
        "account_id": accountId,
      };
}

class AcquirerData {
  AcquirerData({
    this.authCode,
  });

  dynamic authCode;

  factory AcquirerData.fromJson(Map<String, dynamic> json) => AcquirerData(
        authCode: json["auth_code"],
      );

  Map<String, dynamic> toJson() => {
        "auth_code": authCode,
      };
}

class Card {
  Card({
    required this.id,
    required this.entity,
    required this.name,
    required this.last4,
    required this.network,
    required this.type,
    this.issuer,
    required this.international,
    required this.emi,
    required this.subType,
    this.tokenIin,
  });

  String id;
  String entity;
  String name;
  String last4;
  String network;
  String type;
  dynamic issuer;
  bool international;
  bool emi;
  String subType;
  dynamic tokenIin;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"] ?? "",
        entity: json["entity"] ?? "",
        name: json["name"] ?? "",
        last4: json["last4"] ?? "",
        network: json["network"] ?? "",
        type: json["type"] ?? "",
        issuer: json["issuer"] ?? "",
        international: json["international"] ?? false,
        emi: json["emi"] ?? false,
        subType: json["sub_type"] ?? "",
        tokenIin: json["token_iin"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "name": name,
        "last4": last4,
        "network": network,
        "type": type,
        "issuer": issuer,
        "international": international,
        "emi": emi,
        "sub_type": subType,
        "token_iin": tokenIin,
      };
}

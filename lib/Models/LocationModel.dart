class Location {
  Location({
    this.type,
    this.x,
    this.y,
  });
  String? type;
  double? x;
  double? y;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        x: json["x"] != null ? json["x"].toDouble() : null,
        y: json["y"] != null ? json["y"].toDouble() : null,
      );

  Map<String, dynamic> toJson() => {
        "type": type != null ? type : "",
        "x": x,
        "y": y,
      };
}

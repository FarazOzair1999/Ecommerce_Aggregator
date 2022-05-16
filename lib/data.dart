// ignore: camel_case_types
class data {
  String? name;
  String? price;
  Null? sellerName;
  String? sellerYears;
  Null? sellerResponseRate;
  String? image;
  String? link;

  data(
      {this.name,
      this.price,
      this.sellerName,
      this.sellerYears,
      this.sellerResponseRate,
      this.image,
      this.link});

  data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    sellerName = json['seller_name'];
    sellerYears = json['seller_years'];
    sellerResponseRate = json['seller_response_rate'];
    image = json['image'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['price'] = price;
    data['seller_name'] = sellerName;
    data['seller_years'] = sellerYears;
    data['seller_response_rate'] = sellerResponseRate;
    data['image'] = image;
    data['link'] = link;
    return data;
  }
}

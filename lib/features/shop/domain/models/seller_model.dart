import 'package:flutter_sixvalley_ecommerce/common/domain/models/image_full_url.dart';

class SellerModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Seller>? sellers;

  SellerModel({this.totalSize, this.limit, this.offset, this.sellers});

  SellerModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['sellers'] != null) {
      sellers = <Seller>[];
      json['sellers'].forEach((v) {
        sellers!.add(Seller.fromJson(v));
      });
    }
  }


}
class Seller {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? get image => (imageFullUrl?.status == 404) ? 'status: 404' : _image;
  String? _image;
  String? email;
  String? password;
  String? status;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? authToken;
  String? gst;
  String? cmFirebaseToken;
  int? posStatus;
  double? minimumOrderAmount;
  double? freeDeliveryStatus;
  double? freeDeliveryOverAmount;
  int? ordersCount;
  int? productCount;
  int? totalRating;
  int? ratingCount;
  double? averageRating;
  Shop? shop;
  ImageFullUrl? imageFullUrl;

  Seller(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        String? image,
        this.email,
        this.password,
        this.status,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.authToken,
        this.gst,
        this.cmFirebaseToken,
        this.posStatus,
        this.minimumOrderAmount,
        this.freeDeliveryStatus,
        this.freeDeliveryOverAmount,
        this.ordersCount,
        this.productCount,
        this.totalRating,
        this.ratingCount,
        double? averageRating,
        Shop? shop,
        this.imageFullUrl,
      }) : _image = image, averageRating = averageRating, shop = shop;

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    _image = json['image'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authToken = json['auth_token'];
    gst = json['gst'];
    cmFirebaseToken = json['cm_firebase_token'];
    posStatus = int.tryParse(json['pos_status']?.toString() ?? '0') ?? 0;
    minimumOrderAmount = double.tryParse(json['minimum_order_amount']?.toString() ?? '0') ?? 0.0;
    freeDeliveryStatus = double.tryParse(json['free_delivery_status']?.toString() ?? '0') ?? 0.0;
    freeDeliveryOverAmount = double.tryParse(json['free_delivery_over_amount']?.toString() ?? '0') ?? 0.0;
    ordersCount = json['orders_count'];
    productCount = json['product_count'];
    totalRating = json['total_rating'];
    ratingCount = json['rating_count'];
    if(json['average_rating'] != null){
      averageRating = double.tryParse(json['average_rating'].toString()) ?? 0.0;
    }else{
      averageRating = 0.0;
    }

    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
    // Aggregated API returns flat {id, name, image, shop_name} with no shop object
    // Synthesize a minimal Shop so SellerCard doesn't crash on null shop
    if (shop == null && (json['name'] != null || json['image'] != null || json['shop_name'] != null)) {
      shop = Shop(
        id: json['shop_id'] != null ? int.tryParse(json['shop_id'].toString()) : null,
        name: json['shop_name']?.toString() ?? json['name']?.toString(),
        image: json['image']?.toString(),
        banner: json['image']?.toString(),
        vacationStatus: false,
      );
    }
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }

}

class Shop {
  int? id;
  int? sellerId;
  String? name;
  String? address;
  String? contact;
  String? get image => (imageFullUrl?.status == 404) ? 'status: 404' : _image;
  String? _image;
  String? bottomBanner;
  String? offerBanner;
  String? vacationStartDate;
  String? vacationEndDate;
  String? vacationNote;
  bool? vacationStatus;
  bool? temporaryClose;
  String? createdAt;
  String? updatedAt;
  String? get banner => (bannerFullUrl?.status == 404) ? 'status: 404' : _banner;
  String? _banner;
  ImageFullUrl? imageFullUrl;
  ImageFullUrl? bannerFullUrl;
  ImageFullUrl? bottomBannerFullUrl;
  ImageFullUrl? offerBannerFullUrl;

  Shop(
      {this.id,
        this.sellerId,
        this.name,
        this.address,
        this.contact,
        String? image,
        this.bottomBanner,
        this.offerBanner,
        this.vacationStartDate,
        this.vacationEndDate,
        this.vacationNote,
        this.vacationStatus,
        this.updatedAt,
        this.imageFullUrl,
        this.bannerFullUrl,
        this.bottomBannerFullUrl,
        this.offerBannerFullUrl,
        String? banner,
      }) : _image = image, _banner = banner;

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = int.tryParse(json['seller_id']?.toString() ?? '0') ?? 0;
    name = json['name'];
    address = json['address'];
    contact = json['contact'];
    _image = json['image'];
    bottomBanner = json['bottom_banner'];
    offerBanner = json['offer_banner'];
    vacationStartDate = json['vacation_start_date'];
    vacationEndDate = json['vacation_end_date'];
    vacationNote = json['vacation_note'];
    if(json['vacation_status'] != null){
      try{
        vacationStatus = json['vacation_status']??false;
      }catch(e){
        vacationStatus = json['vacation_status']==1? true :false;
      }
    }
    if(json['temporary_close'] != null){
      try{
        temporaryClose = json['temporary_close']??false;
      }catch(e){
        temporaryClose = json['temporary_close']== 1?true : false;
      }
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    _banner = json['banner'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
    bannerFullUrl = json['banner_full_url'] != null ? ImageFullUrl.fromJson(json['banner_full_url']) : null;
    bottomBannerFullUrl = json['bottom_banner_full_url'] != null ? ImageFullUrl.fromJson(json['bottom_banner_full_url']) : null;
    offerBannerFullUrl = json['offer_banner_full_url'] != null ? ImageFullUrl.fromJson(json['offer_banner_full_url']) : null;
  }

}

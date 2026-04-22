import 'dart:convert';
import 'package:flutter_sixvalley_ecommerce/common/domain/models/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';

class ProductModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Product>? _products;

  ProductModel({int? totalSize, int? limit, int? offset, List<Product>? products}) {
    totalSize = totalSize;
    limit = limit;
    offset = offset;
    _products = products;
  }


  List<Product>? get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = int.tryParse(json['limit']?.toString() ?? '10') ?? 10;
    offset = int.tryParse(json['offset']?.toString() ?? '1') ?? 1;
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {_products!.add(Product.fromJson(v));
      });
    }
  }

}

class Product {
  int? _id;
  String? _addedBy;
  int? _userId;
  String? _name;
  String? _slug;
  String? _productType;
  List<CategoryIds>? _categoryIds;
  String? _unit;
  List<String>? _images;
  String? _thumbnail;
  List<ProductColors>? _colors;
  List<String>? _attributes;
  List<ChoiceOptions>? _choiceOptions;
  List<Variation>? _variation;
  double? _unitPrice;
  double? _purchasePrice;
  double? _tax;
  String? _taxModel;
  int? _minQty;
  int? _refundable;
  String? _digitalProductType;
  String? _digitalFileReady;
  String? _taxType;
  double? _discount;
  String? _discountType;
  int? _currentStock;
  String? _details;
  String? _createdAt;
  String? _updatedAt;
  List<Rating>? _rating;
  double? _shippingCost;
  int? _isMultiPly;
  int? _reviewCount;
  String? _videoUrl;
  int? _minimumOrderQty;
  int? wishList;
  Brand? brand;
  Seller? seller;
  ImageFullUrl? thumbnailFullUrl;
  List<ImageFullUrl>? imagesFullUrl;





  Product(
      {int? id,
        String? addedBy,
        int? userId,
        String? name,
        String? slug,
        String? productType,
        List<CategoryIds>? categoryIds,
        String? unit,
        int? minQty,
        int? refundable,
        String? digitalProductType,
        String? digitalFileReady,
        List<String>? images,
        String? thumbnail,
        List<ProductColors>? colors,
        String? variantProduct,
        List<String>? attributes,
        List<ChoiceOptions>? choiceOptions,
        List<Variation>? variation,
        double? unitPrice,
        double? purchasePrice,
        double? tax,
        String? taxModel,
        String? taxType,
        double? discount,
        String? discountType,
        int? currentStock,
        String? details,
        String? attachment,
        String? createdAt,
        String? updatedAt,
        int? featuredStatus,
        List<Rating>? rating,
        double? shippingCost,
        int? isMultiPly,
        int? reviewCount,
        String? videoUrl,
        int? minimumOrderQty,
        int? wishList,
        Brand? brand,
        Seller? seller,
        ImageFullUrl? thumbnailFullUrl,
        List<ImageFullUrl>? imagesFullUrl,

      }) {
    _id = id;
    _addedBy = addedBy;
    _userId = userId;
    _name = name;
    _slug = slug;
    _categoryIds = categoryIds;
    _unit = unit;
    _minQty = minQty;
    if (refundable != null) {
      _refundable = refundable;
    }
    if (digitalProductType != null) {
      _digitalProductType = digitalProductType;
    }
    if (digitalFileReady != null) {
      _digitalFileReady = digitalFileReady;
    }
    _images = images;
    _thumbnail = thumbnail;
    _colors = colors;
    _attributes = attributes;
    _choiceOptions = choiceOptions;
    _variation = variation;
    _unitPrice = unitPrice;
    _purchasePrice = purchasePrice;
    _tax = tax;
    _taxModel = taxModel;
    _taxType = taxType;
    _discount = discount;
    _discountType = discountType;
    _currentStock = currentStock;
    _details = details;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _rating = rating;
    _shippingCost = shippingCost;
    _isMultiPly = isMultiPly;
    _reviewCount = reviewCount;
    if (videoUrl != null) {
      _videoUrl = videoUrl;
    }
    _minimumOrderQty = minimumOrderQty;
    this.wishList;
    this.brand;
    this.seller = seller;
    this.thumbnailFullUrl = thumbnailFullUrl;
    this.imagesFullUrl = imagesFullUrl;
  }

  int? get id => _id;
  String? get addedBy => _addedBy;
  int? get userId => _userId;
  String? get name => _name;
  String? get slug =>_slug;
  String? get productType => _productType;
  List<CategoryIds>? get categoryIds => _categoryIds;
  String? get unit => _unit;
  int? get minQty => _minQty;
  int? get refundable => _refundable;
  String? get digitalProductType => _digitalProductType;
  String? get digitalFileReady => _digitalFileReady;
  List<String>? get images => _images;
  String? get thumbnail => _thumbnail;
  List<ProductColors>? get colors => _colors;
  List<String>? get attributes => _attributes;
  List<ChoiceOptions>? get choiceOptions => _choiceOptions;
  List<Variation>? get variation => _variation;
  double? get unitPrice => _unitPrice;
  double? get purchasePrice => _purchasePrice;
  double? get tax => _tax;
  String? get taxModel => _taxModel;
  String? get taxType => _taxType;
  double? get discount => _discount;
  String? get discountType => _discountType;
  int? get currentStock => _currentStock;
  String? get details => _details;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<Rating>? get rating => _rating;
  double? get shippingCost => _shippingCost;
  int? get isMultiPly => _isMultiPly;
  int? get reviewCount => _reviewCount;
  String? get videoUrl => _videoUrl;
  int? get minimumOrderQuantity => _minimumOrderQty;

  Product.fromJson(Map<String, dynamic> json) {
    _id = _parseIntSafe(json['id']);
    _addedBy = json['added_by'];
    _userId = _parseIntSafe(json['user_id']);
    _name = json['name'];
    _slug = json['slug'];
    _productType = json['product_type'];
    if(json['category_id'] != null){
      _categoryIds = [CategoryIds(position: 0)]; // Placeholder for legacy compatibility
    }
    if (json['category_ids'] != null) {
      _categoryIds = [];
      try{
        json['category_ids'].forEach((v) {
          _categoryIds!.add(CategoryIds.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['category_ids']).forEach((v) {
          _categoryIds!.add(CategoryIds.fromJson(v));
        });
      }
    }
    _unit = json['unit'];
    _minQty = _parseIntSafe(json['min_qty']);

    if(json['refundable']!=null){
      _refundable = _parseIntSafe(json['refundable']);
    }
    if(json['digital_product_type']!=null){
      _digitalProductType = json['digital_product_type'];
    }
    if(json['digital_file_ready']!=null){
      _digitalFileReady = json['digital_file_ready'];
    }

    if(json['images'] != null){
      try{
        _images = json['images'].cast<String>();
      }catch(e){
        _images = jsonDecode(json['images']).cast<String>();
      }
    }

    _thumbnail = json['thumbnail']?.toString();
    thumbnailFullUrl = json['thumbnail_full_url'] != null ? ImageFullUrl.fromJson(json['thumbnail_full_url']) : null;
    if (json['images_full_url'] != null) {
      imagesFullUrl = [];
      json['images_full_url'].forEach((v) {
        imagesFullUrl!.add(ImageFullUrl.fromJson(v));
      });
    }
    if (json['colors_formatted'] != null) {
      _colors = [];
      try{
        json['colors_formatted'].forEach((v) {
          _colors!.add(ProductColors.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['colors_formatted']).forEach((v) {
          _colors!.add(ProductColors.fromJson(v));
        });
      }
    }
    if(json['attributes'] != null && json['attributes'] != "null") {
      try{
        _attributes = json['attributes'].cast<String>();
      }catch(e){
        _attributes = jsonDecode(json['attributes']).cast<String>();
      }
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      try{
        json['choice_options'].forEach((v) {
          _choiceOptions!.add(ChoiceOptions.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['choice_options']).forEach((v) {
          _choiceOptions!.add(ChoiceOptions.fromJson(v));
        });
      }
    }
    if (json['variation'] != null) {
      _variation = [];
      try{
        json['variation'].forEach((v) {
          _variation!.add(Variation.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['variation']).forEach((v) {
          _variation!.add(Variation.fromJson(v));
        });
      }
    }
    _unitPrice = _parseDoubleSafe(json['unit_price']);
    _purchasePrice = _parseDoubleSafe(json['purchase_price']);
    _tax = _parseDoubleSafe(json['tax']);

    if(json['tax_model'] != null){
      _taxModel = json['tax_model'];
    }else{
      _taxModel = 'exclude';
    }

    _taxType = json['tax_type'];
    _discount = _parseDoubleSafe(json['discount']);
    _discountType = json['discount_type'];
    _currentStock = _parseIntSafe(json['current_stock']) ?? 0;
    _details = json['details'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['rating'] != null && json['rating'] is List) {
      _rating = [];
      (json['rating'] as List).forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    } else if (json['rating'] != null && json['rating'] is! List) {
      // rating came as a number (e.g. 0) from the aggregated API
      // Convert to a single Rating with that value as average
      final ratingVal = json['rating'].toString();
      if (ratingVal != '0') {
        _rating = [Rating(average: ratingVal)];
      }
    }
    _shippingCost = _parseDoubleSafe(json['shipping_cost']);
    _isMultiPly = _parseIntSafe(json['multiply_qty']);
    _reviewCount = _parseIntSafe(json['reviews_count']) ?? _parseIntSafe(json['review_count']);
    _videoUrl = json['video_url'];
    _minimumOrderQty = _parseIntSafe(json['minimum_order_qty']) ?? 1;
    wishList = _parseIntSafe(json['wish_list_count']);
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
  }


}

class CategoryIds {
  int? _position;

  CategoryIds({int? position}) {
    _position = position;
  }

  int? get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _position = json['position'];
  }

}

class ProductColors {
  String? _name;
  String? _code;

  ProductColors({String? name, String? code}) {
    _name = name;
    _code = code;
  }

  String? get name => _name;
  String? get code => _code;

  ProductColors.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _code = json['code'];
  }

}

class ChoiceOptions {
  String? _name;
  String? _title;
  List<String>? _options;

  ChoiceOptions({String? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  String? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    if(json['options'] != null){
      _options = json['options'].cast<String>();
    }

  }

}

class Variation {
  String? _type;
  double? _price;
  String? _sku;
  int? _qty;

  Variation({String? type, double? price, String? sku, int? qty}) {
    _type = type;
    _price = price;
    _sku = sku;
    _qty = qty;
  }

  String? get type => _type;
  double? get price => _price;
  String? get sku => _sku;
  int? get qty => _qty;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = double.tryParse(json['price']?.toString() ?? '0');
    _sku = json['sku'];
    _qty = int.tryParse(json['qty']?.toString() ?? '0');
  }
}

class Rating {
  String? _average;

  Rating({String? average, int? productId}) {
    _average = average;
  }

  String? get average => _average;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'].toString();
  }

}

class Brand {
  String? name;


  Brand(
      {
        this.name,
        });

  Brand.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

}
/// Safely parses any value (int, double, String, or null) to [int?].
/// Returns null for null or empty-string inputs; uses [int.tryParse] otherwise.
int? _parseIntSafe(dynamic value) {
  if (value == null || value == '') return null;
  return int.tryParse(value.toString());
}

/// Safely parses any value (int, double, String, or null) to [double?].
/// Returns null for null or empty-string inputs; uses [double.tryParse] otherwise.
double? _parseDoubleSafe(dynamic value) {
  if (value == null || value == '') return null;
  return double.tryParse(value.toString());
}

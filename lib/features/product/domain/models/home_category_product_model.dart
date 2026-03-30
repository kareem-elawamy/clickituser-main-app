import 'package:flutter_sixvalley_ecommerce/common/domain/models/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

class HomeCategoryProduct {
  int? id;
  String? name;
  String? slug;
  String? get icon => (iconFullUrl?.status == 404) ? 'status: 404' : _icon;
  String? _icon;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  List<Product>? products;
  List<dynamic>? translations;
  ImageFullUrl? iconFullUrl;

  HomeCategoryProduct(
      {this.id,
        this.name,
        this.slug,
        this.parentId,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.products,
        this.translations,
        this.iconFullUrl,
        String? icon,
      }) : _icon = icon;

  HomeCategoryProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    _icon = json['icon'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    products = [];
    if (json['products'] != null) {
      json['products'].forEach((v) { products!.add(Product.fromJson(v)); });
    }

    if (json['translations'] != null) {
      translations = [];
      translations = List<dynamic>.from(translations!.map((x) => x));
    }
    iconFullUrl = json['icon_full_url'] != null ? ImageFullUrl.fromJson(json['icon_full_url']) : null;

  }

}

class BrandModel {
  int? _id;
  String? _name;
  String? _image;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _brandProductsCount;
  bool? checked;


  BrandModel(
      {int? id,
        String? name,
        String? image,
        int? status,
        String? createdAt,
        String? updatedAt,
        int? brandProductsCount,
        bool? checked,

      }) {
    _id = id;
    _name = name;
    _image = image;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _brandProductsCount = brandProductsCount;
    checked = checked;

  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get brandProductsCount => _brandProductsCount;


  BrandModel.fromJson(Map<String, dynamic> json) {
    try { _id = json['id']; } catch(e) { print("Error in BrandModel.id: $e"); }
    try { _name = json['name']; } catch(e) { print("Error in BrandModel.name: $e"); }
    try { _image = json['image']; } catch(e) { print("Error in BrandModel.image: $e"); }
    try { _status = int.tryParse(json['status']?.toString() ?? ''); } catch(e) { print("Error in BrandModel.status: $e"); }
    try { _createdAt = json['created_at']; } catch(e) { print("Error in BrandModel.created_at: $e"); }
    try { _updatedAt = json['updated_at']; } catch(e) { print("Error in BrandModel.updated_at: $e"); }
    try { _brandProductsCount = int.tryParse(json['brand_products_count']?.toString() ?? ''); } catch(e) { print("Error in BrandModel.brand_products_count: $e"); }
    checked = false;
  }

}

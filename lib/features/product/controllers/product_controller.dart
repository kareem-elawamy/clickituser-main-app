import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/find_what_you_need.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/home_category_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/most_demanded_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/services/product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:provider/provider.dart';

class ProductController extends ChangeNotifier {
  final ProductServiceInterface? productServiceInterface;
  ProductController({required this.productServiceInterface});

  List<Product>? _latestProductList = [];
  List<Product>? _lProductList;
  List<Product>? get lProductList=> _lProductList;
  List<Product>? _featuredProductList;



  ProductType _productType = ProductType.newArrival;
  String? _title = '${getTranslated('best_selling', Get.context!)}';

  bool _filterIsLoading = false;
  bool _filterFirstLoading = true;

  bool _isLoading = false;
  bool _isFeaturedLoading = false;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool _firstFeaturedLoading = true;
  bool _firstLoading = true;
  int? _latestPageSize = 1;
  int _lOffset = 1;
  int? _lPageSize;
  int? get lPageSize=> _lPageSize;
  int? _featuredPageSize;

  ProductType get productType => _productType;
  String? get title => _title;
  int get lOffset => _lOffset;


  List<int> _offsetList = [];
  List<String> _lOffsetList = [];
  List<String> get lOffsetList=>_lOffsetList;
  List<String> _featuredOffsetList = [];

  List<Product>? get latestProductList => _latestProductList;
  List<Product>? get featuredProductList => _featuredProductList;

  Product? _recommendedProduct;
  Product? get recommendedProduct=> _recommendedProduct;

  bool get filterIsLoading => _filterIsLoading;
  bool get filterFirstLoading => _filterFirstLoading;
  bool get isLoading => _isLoading;
  bool get firstFeaturedLoading => _firstFeaturedLoading;
  bool get firstLoading => _firstLoading;
  int? get latestPageSize => _latestPageSize;
  int? get featuredPageSize => _featuredPageSize;


  bool filterApply = false;

  void isFilterApply (bool apply, {bool reload = false}){
    filterApply = apply;
    if(reload){
      notifyListeners();
    }

  }


  Future<void> getLatestProductList(int offset, {bool reload = false}) async {
    if(reload || offset == 1) {
      _offsetList = [];
      _latestProductList = [];
    }
    _lOffset = offset;
    if(!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface!.getFilteredProductList(Get.context!, offset.toString(), _productType, title);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset==1){
          _latestProductList = [];
        }
        
        try {
          final productModel = await compute(ProductModel.fromJson, apiResponse.response!.data as Map<String, dynamic>);
          if(productModel.products != null){
            _latestProductList!.addAll(productModel.products!);
            _latestPageSize = productModel.totalSize;
          }
        } catch (e, stack) {
          if (kDebugMode) {
            print("====== PARSING ERROR in getLatestProductList ======");
            print(e);
          }
        }

          _filterFirstLoading = false;
          _filterIsLoading = false;
          _filterIsLoading = false;
          removeFirstLoading();
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_filterIsLoading) {
        _filterIsLoading = false;
        notifyListeners();
      }
    }

  }

  //latest product
  Future<void> getLProductList(String offset, {bool reload = false}) async {
    if(reload) {
      _lOffsetList = [];
      _lProductList = [];
    }
    if(!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface!.getLatestProductList(offset);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _lProductList = [];
        try {
          final productModel = await compute(ProductModel.fromJson, apiResponse.response!.data as Map<String, dynamic>);
          _lProductList?.addAll(productModel.products??[]);
          _lPageSize = productModel.totalSize;
        } catch (e, stack) {
          if (kDebugMode) {
            print("====== PARSING ERROR in getLProductList ======");
            print(e);
          }
        }
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }

  }


  List<ProductTypeModel> productTypeList = [
    ProductTypeModel('new_arrival', ProductType.newArrival),
    ProductTypeModel('top_product', ProductType.topProduct),
    ProductTypeModel('best_selling', ProductType.bestSelling),
    ProductTypeModel('discounted_product', ProductType.discountedProduct),
  ];

  
int selectedProductTypeIndex = 0;
 void changeTypeOfProduct(ProductType type, String? title, {int index = 0}){
    _productType = type;
    _title = title;
    _latestProductList = null;
    _latestPageSize = 1;
    _filterFirstLoading = true;
    _filterIsLoading = true;
    selectedProductTypeIndex = index;
    getLatestProductList(1, reload: true);
    notifyListeners();
 }

  void showBottomLoader() {
    _isLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }


  TextEditingController sellerProductSearch = TextEditingController();
  void clearSearchField( String id){
    sellerProductSearch.clear();
    notifyListeners();
  }




  final List<Product> _brandOrCategoryProductList = [];
  List<SubCategory>? _subCategoryList;
  bool? _hasData;

  List<Product> get brandOrCategoryProductList => _brandOrCategoryProductList;
  List<SubCategory>? get subCategoryList => _subCategoryList;
  bool? get hasData => _hasData;

  bool _isBrandOrCategoryProductLoading = false;
  bool get isBrandOrCategoryProductLoading => _isBrandOrCategoryProductLoading;
  bool _hasMoreBrandOrCategoryProduct = true;
  bool get hasMoreBrandOrCategoryProduct => _hasMoreBrandOrCategoryProduct;

  String? _currentCategoryOrBrandId;

  void clearBrandOrCategoryProductList() {
    _brandOrCategoryProductList.clear();
    _isBrandOrCategoryProductLoading = true;
    _hasData = true;
    notifyListeners();
  }

  void initBrandOrCategoryProductList(bool isBrand, String id, BuildContext context, {String offset = '1'}) async {
    if (offset == '1') {
      _currentCategoryOrBrandId = '${isBrand}_$id';
      _brandOrCategoryProductList.clear();
      _hasData = true;
      _hasMoreBrandOrCategoryProduct = true;
    }
    _isBrandOrCategoryProductLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    
    ApiResponse apiResponse = await productServiceInterface!.getBrandOrCategoryProductList(isBrand, id, offset);

    // Prevent race conditions where an old slow pagination request appends to a newly opened category list
    if (_currentCategoryOrBrandId != null && _currentCategoryOrBrandId != '${isBrand}_$id') {
      return;
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (offset == '1') {
        _brandOrCategoryProductList.clear();
        _subCategoryList = null;
      }
      List<Product> products = [];
      if (apiResponse.response!.data is Map) {
        if (apiResponse.response!.data.containsKey('products')) {
          apiResponse.response!.data['products'].forEach((product) => products.add(Product.fromJson(product)));
        }
        if (offset == '1' && apiResponse.response!.data.containsKey('sub_categories') && apiResponse.response!.data['sub_categories'] != null) {
          _subCategoryList = [];
          apiResponse.response!.data['sub_categories'].forEach((subCategory) => _subCategoryList!.add(SubCategory.fromJson(subCategory)));
        }
      } else {
        apiResponse.response!.data.forEach((product) => products.add(Product.fromJson(product)));
      }
      
      _brandOrCategoryProductList.addAll(products);
      _hasMoreBrandOrCategoryProduct = products.length >= 10;
      _hasData = _brandOrCategoryProductList.isNotEmpty;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    _isBrandOrCategoryProductLoading = false;
    notifyListeners();
  }


  List<Product>? _relatedProductList;
  List<Product>? get relatedProductList => _relatedProductList;

  void initRelatedProductList(String id, BuildContext context) async {
    ApiResponse apiResponse = await productServiceInterface!.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response!.data.forEach((product) => _relatedProductList!.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  List<Product>? _moreProductList;
  List<Product>? get moreProductList => _moreProductList;

  void getMoreProductList(String id) async {
    ApiResponse apiResponse = await productServiceInterface!.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response!.data.forEach((product) => _relatedProductList!.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void removePrevRelatedProduct() {
    _relatedProductList = null;
  }


  int featuredIndex = 0;
  void setFeaturedIndex(int index){
    featuredIndex = index;
    notifyListeners();
  }



  Future<void> getFeaturedProductList(String offset, {bool reload = false}) async {
    if(reload) {
      _featuredOffsetList = [];
      _featuredProductList = [];
    }
    if(!_featuredOffsetList.contains(offset)) {
      _featuredOffsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface!.getFeaturedProductList(offset);
      if (apiResponse.response != null  && apiResponse.response!.statusCode == 200) {
        _featuredProductList = [];
        if(apiResponse.response!.data['products'] != null){
          _featuredProductList?.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
          _featuredPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        }

        _firstFeaturedLoading = false;
        _isFeaturedLoading = false;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_isFeaturedLoading) {
        _isFeaturedLoading = false;
        notifyListeners();
      }
    }

  }


  bool recommendedProductLoading = false;
  Future<void> getRecommendedProduct() async {
    ApiResponse apiResponse = await productServiceInterface!.getRecommendedProduct();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _recommendedProduct = Product.fromJson(apiResponse.response!.data);
      }
      notifyListeners();
  }


  final List<HomeCategoryProduct> _homeCategoryProductList = [];
  List<HomeCategoryProduct> get homeCategoryProductList => _homeCategoryProductList;

  Future<void> getHomeCategoryProductList(bool reload) async {
    // Disabled. The App now strictly uses getHomeDataAggregation() API
    // which aggregates this data instantly and without the legacy nested arrays.
    await getHomeProducts(reload);
  }

  MostDemandedProductModel? mostDemandedProductModel;
  Future<void> getMostDemandedProduct() async {
    ApiResponse apiResponse = await productServiceInterface!.getMostDemandedProduct();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(apiResponse.response?.data != null && apiResponse.response?.data.isNotEmpty && apiResponse.response?.data != '[]'){
        mostDemandedProductModel = MostDemandedProductModel.fromJson(apiResponse.response!.data);
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }



  FindWhatYouNeedModel? findWhatYouNeedModel;
  Future<void> findWhatYouNeed() async {
    ApiResponse apiResponse = await productServiceInterface!.getFindWhatYouNeed();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      findWhatYouNeedModel = FindWhatYouNeedModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  /// Extracts a List from either a bare List or a Map envelope {products:[...]}
  static List<dynamic>? _extractProductList(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) return raw;
    if (raw is Map) {
      if (raw['products'] != null && raw['products'] is List) return raw['products'] as List;
      if (raw['data'] != null && raw['data'] is List) return raw['data'] as List;
    }
    return null;
  }

  Future<void> initHomeData(Map<String, dynamic> data) async {
    if (data['home_categories'] != null) {
      _homeCategoryProductList.clear();
      try {
        final rawCats = data['home_categories'];
        final catList = (rawCats is List) ? rawCats : (rawCats is Map && rawCats['data'] != null) ? rawCats['data'] as List : [];
        for (final item in catList) {
          final category = HomeCategoryProduct.fromJson(item as Map<String, dynamic>);
          category.products ??= [];
          _homeCategoryProductList.add(category);
        }
      } catch (e) {
        if (kDebugMode) print('Parsing error for home_categories: $e');
      }
    }
    final rawLatest = data['latest_products'];
    if (rawLatest != null) {
      _lProductList = [];
      try {
        List<dynamic> productsList = [];
        if (rawLatest is Map) {
          productsList = rawLatest['products'] ?? [];
          _lPageSize = rawLatest['total_size'];
        } else if (rawLatest is List) {
          productsList = rawLatest;
        }
        
        for (final v in productsList) {
          _lProductList!.add(Product.fromJson(v as Map<String, dynamic>));
        }
      } catch (e) {
        if (kDebugMode) print('Parsing error for latest_products: $e');
      }
      _firstLoading = false;
    }
    if (data['featured_products'] != null) {
      _featuredProductList = [];
      try {
        final raw = data['featured_products'];
        if (raw is List) {
          _featuredProductList!.addAll(raw.map((v) => Product.fromJson(v)).toList());
        } else if (raw is Map && raw['products'] != null) {
          _featuredProductList!.addAll((raw['products'] as List).map((v) => Product.fromJson(v)).toList());
          _featuredPageSize = raw['total_size'];
        } else if (raw is Map) {
          final featured = ProductModel.fromJson(Map<String, dynamic>.from(raw));
          _featuredProductList?.addAll(featured.products ?? []);
          _featuredPageSize = featured.totalSize;
        }
      } catch (e) {
        if (kDebugMode) print("Parsing error for featured_products: $e");
      }
      _firstFeaturedLoading = false;
    }
    if (data['recommended_product'] != null) {
      try {
        if (data['recommended_product'] is Map) {
          _recommendedProduct = Product.fromJson(data['recommended_product']);
        }
      } catch (e) {
        if (kDebugMode) print('Parsing error for recommended_product: $e');
      }
    }
    if (data['find_what_you_need'] != null) {
      try {
        if (data['find_what_you_need'] is Map) {
          findWhatYouNeedModel = FindWhatYouNeedModel.fromJson(data['find_what_you_need']);
        }
      } catch (e) {
        if (kDebugMode) print('Parsing error for find_what_you_need: $e');
      }
    }
    if (data['just_for_you'] != null) {
      justForYouProduct = [];
      try {
        final rawJfy = data['just_for_you'];
        if (rawJfy is List) {
          rawJfy.forEach((justForYou) => justForYouProduct?.add(Product.fromJson(justForYou)));
        }
      } catch (e) {
        if (kDebugMode) print('Parsing error for just_for_you: $e');
      }
    }
    // Consistently notify only once per data population
    notifyListeners();
  }

  List<Product>? justForYouProduct;
  Future<void> getJustForYouProduct() async {
    justForYouProduct = [];
    ApiResponse apiResponse = await productServiceInterface!.getJustForYouProductList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiResponse.response?.data.forEach((justForYou)=> justForYouProduct?.add(Product.fromJson(justForYou)));
    }
    notifyListeners();
  }

  ProductModel? mostSearchingProduct;
  Future<void> getMostSearchingProduct(int offset, {bool reload = false}) async {
    ApiResponse apiResponse = await productServiceInterface!.getMostSearchingProductList(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(apiResponse.response?.data['products'] != null && apiResponse.response?.data['products'] != 'null'){
        if(offset == 1) {
          mostSearchingProduct = await compute(ProductModel.fromJson, apiResponse.response?.data as Map<String, dynamic>);
        }else {
          final pModel = await compute(ProductModel.fromJson, apiResponse.response?.data as Map<String, dynamic>);
          mostSearchingProduct!.products!.addAll(pModel.products!);
          mostSearchingProduct!.offset = pModel.offset;
          mostSearchingProduct!.totalSize = pModel.totalSize;
        }
      }


    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();


  }

  static dynamic _parseJson(String text) {
    var decoded = jsonDecode(text);
    if (decoded is List && decoded.isNotEmpty) {
      return decoded[0];
    }
    return decoded;
  }

  Map<String, dynamic> _coerceData(dynamic raw) {
    Map<String, dynamic> data = {};
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        } else if (decoded is List && decoded.isNotEmpty) {
          data = Map<String, dynamic>.from(decoded[0]);
        }
      } catch (e) {
        if (kDebugMode) print('JSON Decode Error: $e');
      }
    } else if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is List && raw.isNotEmpty) {
      data = Map<String, dynamic>.from(raw[0]);
    }
    return data;
  }

  Future<void> getHomeEssential(bool reload) async {
    try {
      ApiResponse apiResponse = await productServiceInterface!.getHomeEssentialData();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        Map<String, dynamic> data = _coerceData(apiResponse.response!.data);
        if (Get.context != null) {
          Provider.of<BannerController>(Get.context!, listen: false)
              .initBannerData(data['banners'] is List ? data['banners'] : []);
          Provider.of<CategoryController>(Get.context!, listen: false)
              .initCategoryData(data['categories'] is List ? data['categories'] : []);
          Provider.of<FlashDealController>(Get.context!, listen: false)
              .initFlashDealData(data);
          
          if (data['find_what_you_need'] != null) {
            try {
              if (data['find_what_you_need'] is Map) {
                findWhatYouNeedModel = FindWhatYouNeedModel.fromJson(data['find_what_you_need']);
              }
            } catch (e) {
              if (kDebugMode) print('Parsing error for find_what_you_need: $e');
            }
          }
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error in getHomeEssential: $e');
        print(stack);
      }
    }
    notifyListeners();
  }

  Future<void> getHomeDiscovery(bool reload) async {
    try {
      ApiResponse apiResponse = await productServiceInterface!.getHomeDiscoveryData();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        Map<String, dynamic> data = _coerceData(apiResponse.response!.data);
        if (Get.context != null) {
          Provider.of<ShopController>(Get.context!, listen: false)
              .initTopSellerData(data['top_sellers'] is List ? data['top_sellers'] : []);
          Provider.of<BrandController>(Get.context!, listen: false)
              .initBrandData(data['brands'] is List ? data['brands'] : []);
          
          List<dynamic> fDeals = _extractProductList(data['featured_deal']) ?? 
                                 _extractProductList(data['featured_deals']) ?? [];
          Provider.of<FeaturedDealController>(Get.context!, listen: false)
              .initFeaturedDealData(fDeals is List ? fDeals : []);
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error in getHomeDiscovery: $e');
        print(stack);
      }
    }
    notifyListeners();
  }

  int currentJustForYouIndex = 0;
  void setCurrentJustForYourIndex(int index) {
    currentJustForYouIndex = index;
    notifyListeners();
  }

  Future<void> getHomeProducts(bool reload) async {
    try {
      ApiResponse apiResponse = await productServiceInterface!.getHomeProductsData();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        Map<String, dynamic> data = _coerceData(apiResponse.response!.data);
        await initHomeData(data);
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error in getHomeProducts: $e');
        print(stack);
      }
    }
    notifyListeners();
  }

}


class ProductTypeModel{
  String? title;
  ProductType productType;

  ProductTypeModel(this.title, this.productType);
}
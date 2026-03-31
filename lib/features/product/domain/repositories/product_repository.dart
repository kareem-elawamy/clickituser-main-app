import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/repositories/product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository implements ProductRepositoryInterface{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProductRepository({required this.dioClient, this.sharedPreferences});

  @override
  Future<ApiResponse> getFilteredProductList(BuildContext context, String offset, ProductType productType, String? title) async {
    late String endUrl;

     if(productType == ProductType.bestSelling){
      endUrl = AppConstants.bestSellingProductUri;
      title = getTranslated('best_selling', context);
    }
    else if(productType == ProductType.newArrival){
      endUrl = AppConstants.newArrivalProductUri;
      title = getTranslated('new_arrival',context);
    }
    else if(productType == ProductType.topProduct){
      endUrl = AppConstants.topProductUri;
      title = getTranslated('top_product', context);
    }else if(productType == ProductType.discountedProduct){
       endUrl = AppConstants.discountedProductUri;
       title = getTranslated('discounted_product', context);
     }
    try {
      final response = await dioClient!.get(
        endUrl+offset);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getBrandOrCategoryProductList(bool isBrand, String id, String offset) async {
    try {
      String uri;
      if(isBrand){
        uri = '${AppConstants.brandProductUri}$id?guest_id=1&limit=10&offset=$offset';
      }else {
        uri = '${AppConstants.categoryProductUri}$id?guest_id=1&limit=10&offset=$offset';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getRelatedProductList(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.relatedProductUri}$id?guest_id=1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getFeaturedProductList(String offset) async {
    try {
      final response = await dioClient!.get(
        AppConstants.featuredProductUri+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getLatestProductList(String offset) async {
    try {
      final response = await dioClient!.get(
        AppConstants.latestProductUri+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRecommendedProduct() async {
    try {
      final response = await dioClient!.get(AppConstants.dealOfTheDay);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostDemandedProduct() async {
    try {
      final response = await dioClient!.get(AppConstants.mostDemandedProduct);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getFindWhatYouNeed() async {
    try {
      final response = await dioClient!.get(AppConstants.findWhatYouNeed);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getJustForYouProductList() async {
    try {
      final response = await dioClient!.get(AppConstants.justForYou);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostSearchingProductList(int offset) async {
    try {
      final response = await dioClient!.get("${AppConstants.mostSearching}?guest_id=1&limit=10&offset=$offset");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeCategoryProductList() async {
    try {
      final response = await dioClient!.get(AppConstants.homeCategoryProductUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeData() async {
    try {
      // Append the real guest_id from SharedPreferences (falls back to '1' if not set)
      final String guestId = sharedPreferences?.getString(AppConstants.guestId) ?? '1';
      final response = await dioClient!.get('${AppConstants.homeDataUri}?guest_id=$guestId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeEssentialData() async {
    try {
      final String guestId = sharedPreferences?.getString(AppConstants.guestId) ?? '1';
      final response = await dioClient!.get('${AppConstants.homeEssentialUri}?guest_id=$guestId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeDiscoveryData() async {
    try {
      final String guestId = sharedPreferences?.getString(AppConstants.guestId) ?? '1';
      final response = await dioClient!.get('${AppConstants.homeDiscoveryUri}?guest_id=$guestId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeProductsData() async {
    try {
      final String guestId = sharedPreferences?.getString(AppConstants.guestId) ?? '1';
      final response = await dioClient!.get('${AppConstants.homeProductsUri}?guest_id=$guestId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }



  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }


  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

}
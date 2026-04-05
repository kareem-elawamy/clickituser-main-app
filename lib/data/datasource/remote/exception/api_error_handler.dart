
import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:provider/provider.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 403:
                  if (error.response!.data is Map && error.response!.data['errors'] != null) {
                    ErrorResponse errorResponse = ErrorResponse.fromJson(error.response?.data);
                    errorDescription = errorResponse.errors?[0].message;
                  } else if (error.response!.data is Map && error.response!.data['message'] != null) {
                    errorDescription = error.response!.data['message'];
                  } else {
                    errorDescription = error.response!.data;
                  }
                  break;
                case 401:
                  if (error.response!.data is Map && error.response!.data['errors'] != null) {
                    ErrorResponse errorResponse = ErrorResponse.fromJson(error.response?.data);
                    errorDescription = errorResponse.errors?[0].message;
                  } else if (error.response!.data is Map && error.response!.data['message'] != null) {
                    errorDescription = error.response!.data['message'];
                  } else {
                    errorDescription = error.response!.data;
                  }
                  Provider.of<AuthController>(Get.context!,listen: false).clearSharedData();
                  break;
                case 404:
                case 500:
                case 503:
                case 429:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  if (error.response!.data is Map && error.response!.data['errors'] != null) {
                    ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
                    if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
                      errorDescription = errorResponse;
                    } else {
                      errorDescription = error.response!.data['message'] ?? "Failed to load data - status code: ${error.response!.statusCode}";
                    }
                  } else if (error.response!.data is Map && error.response!.data['message'] != null) {
                    errorDescription = error.response!.data['message'];
                  } else {
                    errorDescription = error.response!.data ?? "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
              break;
            case DioExceptionType.connectionError:
              // TODO: Handle this case.
              break;
            case DioExceptionType.unknown:
              errorDescription = "Request to API call limit excited ";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      } catch (e) {
        errorDescription = error.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}

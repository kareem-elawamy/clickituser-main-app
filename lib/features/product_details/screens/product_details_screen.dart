import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/bottom_cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_specification_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/product_title_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/promise_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/related_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/review_and_specification_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/shop_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/product_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/widgets/review_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_product_view_list.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final int? productId;
  final String? slug;
  final bool isFromWishList;
  const ProductDetails({super.key, required this.productId, required this.slug, this.isFromWishList = false});



  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ScrollController scrollController;

  _loadData( BuildContext context) async{
    Provider.of<ProductDetailsController>(context, listen: false).getProductDetails(context, widget.productId.toString(), widget.slug.toString());
    Provider.of<ReviewController>(context, listen: false).removePrevReview();
    Provider.of<ReviewController>(context, listen: false).getReviewList(widget.productId, widget.slug, context);
    Provider.of<ProductController>(context, listen: false).removePrevRelatedProduct();
    Provider.of<ProductController>(context, listen: false).initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsController>(context, listen: false).getCount(widget.productId.toString(), context);

  }

  @override
  void initState() {
    scrollController = ScrollController();
    _loadData(context);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('product_details', context)),

      body: RefreshIndicator(onRefresh: () async => _loadData(context),
        child: Selector<ProductDetailsController, bool>(
          selector: (_, details) => details.isDetails,
          builder: (context, isDetailsLoading, child) {
            if (isDetailsLoading) {
              return const ProductDetailsShimmer();
            }

            // Retrieve the loaded model synchronously without listening to all its changes
            final detailsController = Provider.of<ProductDetailsController>(context, listen: false);
            final productModel = detailsController.productDetailsModel;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [

                ProductImageWidget(productModel: productModel),

                Column(children: [

                  ProductTitleWidget(productModel: productModel,
                      averageRatting: productModel?.averageReview?? "0"),



                  const ReviewAndSpecificationSectionWidget(),


                  Selector<ProductDetailsController, bool>(
                    selector: (_, details) => details.isReviewSelected,
                    builder: (context, isReviewSelected, _) {
                      return isReviewSelected?
                      ReviewSection(details: detailsController):

                      Column(children: [
                        (productModel?.details != null && productModel!.details!.isNotEmpty) ?
                        Container(height: 250,
                          margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: ProductSpecificationWidget(productSpecification: productModel.details ?? ''),) : const SizedBox(),

                        productModel?.videoUrl != null?
                        YoutubeVideoWidget(url: productModel!.videoUrl!):const SizedBox(),


                        (productModel != null ) ?
                        ShopInfoWidget(sellerId: productModel.addedBy == 'seller'? productModel.userId.toString() : "0") : const SizedBox.shrink(),

                        const SizedBox(height: Dimensions.paddingSizeLarge,),

                        Container(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(color: Theme.of(context).cardColor),
                            child: const PromiseWidget()),



                        (productModel != null && productModel.addedBy == 'seller' ) ?
                        Consumer<SellerProductController>(
                          builder: (context, sellerProductController, _) {
                            return (sellerProductController.sellerProduct != null && sellerProductController.sellerProduct!.products != null &&
                                sellerProductController.sellerProduct!.products!.isNotEmpty)?
                            Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
                              child: TitleRowWidget(title: getTranslated('more_from_the_shop', context),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
                                  fromMore: true,
                                  sellerId: productModel.seller?.id,
                                  temporaryClose: productModel.seller?.shop?.temporaryClose,
                                  vacationStatus: productModel.seller?.shop?.vacationStatus??false,
                                  vacationEndDate: productModel.seller?.shop?.vacationEndDate,
                                  vacationStartDate: productModel.seller?.shop?.vacationStartDate,
                                  name: productModel.seller?.shop?.name,
                                  banner: productModel.seller?.shop?.banner,
                                  image: productModel.seller?.shop?.image,)));
                              },),):const SizedBox();
                          }
                        ):const SizedBox(),

                        (productModel?.addedBy == 'seller') ?
                        Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                            child: ShopProductViewList(
                                scrollController: scrollController, sellerId: productModel!.userId!)):const SizedBox(),

                        Consumer<ProductController>(
                          builder: (context, productController,_) {
                            return (productController.relatedProductList != null && productController.relatedProductList!.isNotEmpty)?Padding(padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall),
                              child: TitleRowWidget(title: getTranslated('related_products', context), isDetailsPage: true)): const SizedBox();
                          }
                        ),
                        const SizedBox(height: 5),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: RelatedProductWidget(),
                        ),
                      ],);
                    }
                  ),
                ],),
              ]),
            );
          },
        ),
      ),

      bottomNavigationBar: Consumer<ProductDetailsController>(
          builder: (context, details, child) {
            return !details.isDetails?
            BottomCartWidget(product: details.productDetailsModel):const SizedBox();
          }
      ),
    );
  }
}

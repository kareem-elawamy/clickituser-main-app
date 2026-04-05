import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const BrandAndCategoryProductScreen({super.key, required this.isBrand, required this.id, required this.name, this.image});

  @override
  State<BrandAndCategoryProductScreen> createState() => _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState extends State<BrandAndCategoryProductScreen> {
  final ScrollController _scrollController = ScrollController();
  int offset = 1;

  @override
  void initState() {
    Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(widget.isBrand, widget.id, context, offset: offset.toString());

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels
          && Provider.of<ProductController>(context, listen: false).brandOrCategoryProductList.isNotEmpty
          && !Provider.of<ProductController>(context, listen: false).isBrandOrCategoryProductLoading
          && Provider.of<ProductController>(context, listen: false).hasMoreBrandOrCategoryProduct) {
        offset++;
        Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(widget.isBrand, widget.id, context, offset: offset.toString());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: widget.name),
      body: Consumer<ProductController>(
        builder: (context, productController, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [



            widget.isBrand ? Container(height: 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              color: Theme.of(context).highlightColor,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CustomImageWidget(image: '${Provider.of<SplashController>(context,listen: false).baseUrls?.brandImageUrl ?? ''}/${widget.image}',
                  width: 80, height: 80, fit: BoxFit.cover,),
                const SizedBox(width: Dimensions.paddingSizeSmall),


                Expanded(child: Text(widget.name??'',maxLines: 2,overflow: TextOverflow.ellipsis, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge))),
              ]),
            ) : const SizedBox.shrink(),

            if (!widget.isBrand && productController.subCategoryList != null && productController.subCategoryList!.isNotEmpty)
              Container(
                height: 100,
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: productController.subCategoryList!.length,
                  itemBuilder: (context, index) {
                    var subCategory = productController.subCategoryList![index];
                    return InkWell(
                      onTap: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                           isBrand: false,
                           id: subCategory.id.toString(),
                           name: subCategory.name,
                         )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            Container(
                              height: 60, width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                color: Theme.of(context).primaryColor.withOpacity(0.1)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                child: CustomImageWidget(
                                  image: subCategory.icon != null && subCategory.icon!.startsWith('http') 
                                    ? subCategory.icon! 
                                    : '${Provider.of<SplashController>(context, listen: false).baseUrls!.categoryImageUrl}/${subCategory.icon}',
                                  fit: BoxFit.cover,
                                )
                              )
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            SizedBox(
                              width: 60,
                              child: Text(
                                subCategory.name ?? '',
                                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                              )
                            )
                          ]
                        )
                      )
                    );
                  }
                )
              ),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Products
            productController.brandOrCategoryProductList.isNotEmpty ?
            Expanded(
              child: MasonryGridView.count(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width> 480? 3 : 2,
                itemCount: productController.brandOrCategoryProductList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ProductWidget(productModel: productController.brandOrCategoryProductList[index]);
                },
              ),
            ) :

            Expanded(child: (productController.hasData ?? true) ?

              ProductShimmer(isHomePage: false,
                isEnabled: Provider.of<ProductController>(context).brandOrCategoryProductList.isEmpty)
                : const NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noProduct,
              message: 'no_product_found',)),

            productController.isBrandOrCategoryProductLoading && offset > 1
                ? Center(child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                  ))
                : const SizedBox.shrink(),

          ]);
        },
      ),
    );
  }
}

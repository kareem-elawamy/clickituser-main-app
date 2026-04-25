import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
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
import 'package:flutter_sixvalley_ecommerce/utill/image_url_helper.dart';
import 'package:provider/provider.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const BrandAndCategoryProductScreen(
      {super.key,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image});

  @override
  State<BrandAndCategoryProductScreen> createState() =>
      _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState
    extends State<BrandAndCategoryProductScreen> {
  final ScrollController _scrollController = ScrollController();
  int offset = 1;

  @override
  void initState() {
    Provider.of<ProductController>(context, listen: false)
        .initBrandOrCategoryProductList(widget.isBrand, widget.id, context,
            offset: offset.toString());

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels &&
          Provider.of<ProductController>(context, listen: false)
              .brandOrCategoryProductList
              .isNotEmpty &&
          !Provider.of<ProductController>(context, listen: false)
              .isBrandOrCategoryProductLoading &&
          Provider.of<ProductController>(context, listen: false)
              .hasMoreBrandOrCategoryProduct) {
        offset++;
        Provider.of<ProductController>(context, listen: false)
            .initBrandOrCategoryProductList(widget.isBrand, widget.id, context,
                offset: offset.toString());
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
          return ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                widget.isBrand
                    ? Container(
                        height: 100,
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        margin: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        color: Theme.of(context).highlightColor,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImageWidget(
                                image:
                                    getFullImageUrl(Provider.of<SplashController>(context, listen: false).baseUrls?.brandImageUrl, widget.image),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Expanded(
                                  child: Text(widget.name ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge))),
                            ]),
                      )
                    : const SizedBox.shrink(),

                if (!widget.isBrand &&
                    productController.subCategoryList != null &&
                    productController.subCategoryList!.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    itemCount: productController.subCategoryList!.length,
                    itemBuilder: (context, index) {
                      var subCategory = productController.subCategoryList![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(subCategory.name ?? '', style: textBold.copyWith(fontSize: 16)),
                            trailing: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                child: (subCategory.subSubCategories != null && subCategory.subSubCategories!.isNotEmpty)
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: subCategory.subSubCategories!.map((subSub) {
                                            return InkWell(
                                              onTap: () {
                                                Provider.of<ProductController>(context, listen: false).clearBrandOrCategoryProductList();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => BrandAndCategoryProductScreen(
                                                              isBrand: false,
                                                              id: subSub.id.toString(),
                                                              name: subSub.name,
                                                            )));
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                child: Text(subSub.name ?? '', style: textRegular.copyWith(fontSize: 13, color: Theme.of(context).primaryColor)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<ProductController>(context, listen: false).clearBrandOrCategoryProductList();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => BrandAndCategoryProductScreen(
                                                          isBrand: false,
                                                          id: subCategory.id.toString(),
                                                          name: subCategory.name,
                                                        )));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: Text(getTranslated('view_all', context) ?? 'View All', style: textRegular.copyWith(fontSize: 13, color: Theme.of(context).primaryColor)),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                // Products
                productController.brandOrCategoryProductList.isNotEmpty
                    ? MasonryGridView.count(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 480 ? 3 : 2,
                        itemCount: productController
                            .brandOrCategoryProductList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidget(
                              productModel: productController
                                  .brandOrCategoryProductList[index]);
                        },
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: (productController.hasData ?? true)
                            ? ProductShimmer(
                                isHomePage: false,
                                isEnabled:
                                    Provider.of<ProductController>(context)
                                        .brandOrCategoryProductList
                                        .isEmpty)
                            : const NoInternetOrDataScreenWidget(
                                isNoInternet: false,
                                icon: Images.noProduct,
                                message: 'no_product_found',
                              ),
                      ),

                productController.isBrandOrCategoryProductLoading && offset > 1
                    ? Center(
                        child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      ))
                    : const SizedBox.shrink(),
              ]);
        },
      ),
    );
  }
}

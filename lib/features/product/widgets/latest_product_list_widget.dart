
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product_widget.dart';

import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/latest_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:provider/provider.dart';


class LatestProductListWidget extends StatelessWidget {
  const LatestProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.lProductList;

        return productList != null? productList.isNotEmpty ?
          Column(children: [
              TitleRowWidget(title: getTranslated('latest_products', context),
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.latestProduct)))),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(height: MediaQuery.of(context).size.width * 0.65,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: LatestProductWidget(productModel: productList![index]),
                        ));
                  },
                )),
            ],
          ): 
          // Empty State
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeSmall),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor.withOpacity(0.1), Theme.of(context).primaryColor.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                   Icon(Icons.inventory_2_outlined, size: 40, color: Theme.of(context).primaryColor),
                   const SizedBox(height: Dimensions.paddingSizeSmall),
                   Text('New Products Arriving Soon!',
                    style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                   const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                   Text('Check back later for the latest additions to our store.',
                    textAlign: TextAlign.center,
                    style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ) 
          // Loading State
          : const LatestProductShimmer();
      },
    );
  }
}


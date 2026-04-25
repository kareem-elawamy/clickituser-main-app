import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {

        return categoryProvider.categoryList.isNotEmpty ?
        SizedBox( height: Provider.of<LocalizationController>(context, listen: false).isLtr? MediaQuery.of(context).size.width/3.7 : MediaQuery.of(context).size.width/3,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: categoryProvider.categoryList.length + 1,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index == categoryProvider.categoryList.length) {
                return InkWell( splashColor: Colors.transparent, highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Provider.of<LocalizationController>(context, listen: false).isLtr ? Dimensions.homePagePadding : 0,
                        right: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      Container(height: MediaQuery.of(context).size.width/6.5, width: MediaQuery.of(context).size.width/6.5, decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.125),width: .25),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          color: Theme.of(context).primaryColor.withOpacity(.125)),
                        child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          child: Icon(Icons.category_outlined, color: Theme.of(context).primaryColor))),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Center(child: SizedBox(width: MediaQuery.of(context).size.width/6.5,
                          child: Text(getTranslated('all_category', context) ?? 'All', textAlign: TextAlign.center, maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                color: ColorResources.getTextTitle(context)))))])
                  ),
                );
              }
              return InkWell( splashColor: Colors.transparent, highlightColor: Colors.transparent,
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                    isBrand: false,
                    id: categoryProvider.categoryList[index].id.toString(),
                    name: categoryProvider.categoryList[index].name)));
                },
                child: CategoryWidget(category: categoryProvider.categoryList[index],
                    index: index,length:  categoryProvider.categoryList.length));
            },
          ),
        ) : const SizedBox.shrink();

      },
    );
  }
}




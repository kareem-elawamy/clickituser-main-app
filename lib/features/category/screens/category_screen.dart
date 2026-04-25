import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/image_url_helper.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryController>(context, listen: false);
      if (categoryProvider.categoryList.isNotEmpty) {
        categoryProvider
            .getCategoryChildes(categoryProvider.categoryList[0].id.toString());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('CATEGORY', context)),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.categoryList.isNotEmpty
              ? Row(children: [
                  Container(
                      width: 100,
                      margin: const EdgeInsets.only(top: 3),
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeController>(context)
                                            .darkTheme
                                        ? 700
                                        : 200]!,
                                spreadRadius: 1,
                                blurRadius: 1)
                          ]),
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: categoryProvider.categoryList.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            CategoryModel category =
                                categoryProvider.categoryList[index];
                            return InkWell(
                                onTap: () {
                                  categoryProvider.changeSelectedIndex(index);
                                  categoryProvider.getCategoryChildes(
                                      category.id.toString());
                                },
                                child: CategoryItem(
                                    title: category.name,
                                    icon: category.icon,
                                    isSelected: categoryProvider
                                            .categorySelectedIndex ==
                                        index));
                          })),
                  Expanded(
                      child: categoryProvider.isSubCategoryLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)))
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeSmall),
                                    itemCount: (categoryProvider
                                                .subCategoryList?.length ??
                                            0) +
                                        1,
                                    itemBuilder: (context, index) {
                                      late SubCategory subCategory;
                                      if (index != 0) {
                                        subCategory = categoryProvider
                                            .subCategoryList![index - 1];
                                      }
                                      if (index == 0) {
                                        return Ink(
                                          color:
                                              Theme.of(context).highlightColor,
                                          child: ListTile(
                                            title: Text(
                                                getTranslated(
                                                    'all_products', context)!,
                                                style: textRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            trailing:
                                                const Icon(Icons.navigate_next),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BrandAndCategoryProductScreen(
                                                            isBrand: false,
                                                            id: categoryProvider
                                                                .categoryList[
                                                                    categoryProvider
                                                                        .categorySelectedIndex!]
                                                                .id
                                                                .toString(),
                                                            name: categoryProvider
                                                                .categoryList[
                                                                    categoryProvider
                                                                        .categorySelectedIndex!]
                                                                .name,
                                                          )));
                                            },
                                          ),
                                        );
                                      } else if (subCategory
                                          .subSubCategories!.isNotEmpty) {
                                        return Ink(
                                            color: Theme.of(context)
                                                .highlightColor,
                                            child: Theme(
                                                data: Provider.of<ThemeController>(context)
                                                        .darkTheme
                                                    ? ThemeData.dark()
                                                    : ThemeData.light(),
                                                child: ExpansionTile(
                                                    key: Key(
                                                        '${Provider.of<CategoryController>(context).categorySelectedIndex}$index'),
                                                    title: Text(subCategory.name!,
                                                        style: textRegular.copyWith(
                                                            color: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color,
                                                            fontSize: Dimensions
                                                                .fontSizeDefault),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis),
                                                    children: _getSubSubCategories(context, subCategory))));
                                      } else {
                                        return Ink(
                                          color:
                                              Theme.of(context).highlightColor,
                                          child: ListTile(
                                            leading: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1)),
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .paddingSizeExtraSmall),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: CustomImageWidget(
                                                  image: subCategory.icon !=
                                                              null &&
                                                          subCategory.icon!
                                                              .startsWith(
                                                                  'http')
                                                      ? subCategory.icon!
                                                      : getFullImageUrl(Provider.of<SplashController>(context, listen: false).baseUrls?.categoryImageUrl, subCategory.icon),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title: Text(subCategory.name!,
                                                style: textRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            trailing: Icon(Icons.navigate_next,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          BrandAndCategoryProductScreen(
                                                              isBrand: false,
                                                              id: subCategory.id
                                                                  .toString(),
                                                              name: subCategory
                                                                  .name)));
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                ])
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }

  List<Widget> _getSubSubCategories(
      BuildContext context, SubCategory subCategory) {
    List<Widget> subSubCategories = [];
    subSubCategories.add(Container(
      color: ColorResources.getIconBg(context),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall),
      child: ListTile(
        title: Row(children: [
          Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimary(context),
                  shape: BoxShape.circle)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Flexible(
              child: Text(getTranslated('all_products', context)!,
                  style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis))
        ]),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BrandAndCategoryProductScreen(
                        isBrand: false,
                        id: subCategory.id.toString(),
                        name: subCategory.name,
                      )));
        },
      ),
    ));
    for (int index = 0; index < subCategory.subSubCategories!.length; index++) {
      subSubCategories.add(Container(
        color: ColorResources.getIconBg(context),
        margin: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall),
        child: ListTile(
          title: Row(children: [
            Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(
                    color: ColorResources.getPrimary(context),
                    shape: BoxShape.circle)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Flexible(
                child: Text(subCategory.subSubCategories![index].name!,
                    style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeDefault),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)),
          ]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BrandAndCategoryProductScreen(
                          isBrand: false,
                          id: subCategory.subSubCategories![index].id
                              .toString(),
                          name: subCategory.subSubCategories![index].name,
                        )));
          },
        ),
      ));
    }
    return subSubCategories;
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;

  const CategoryItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? ColorResources.getPrimary(context) : null),
      child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: isSelected
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).hintColor),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                      fit: BoxFit.cover,
                      image: icon != null && icon!.startsWith('http')
                          ? icon!
                          : getFullImageUrl(Provider.of<SplashController>(context, listen: false).baseUrls?.categoryImageUrl, icon)))),
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraSmall),
              child: Text(title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: isSelected
                          ? Theme.of(context).highlightColor
                          : Theme.of(context).hintColor))),
        ]),
      ),
    );
  }
}

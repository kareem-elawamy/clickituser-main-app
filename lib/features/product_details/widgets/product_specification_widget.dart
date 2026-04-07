import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/specification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class ProductSpecificationWidget extends StatelessWidget {
  final String productSpecification;
  const ProductSpecificationWidget({super.key, required this.productSpecification});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
          child: Text(getTranslated('product_specification', context)??'',style: textMedium ),),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),


        productSpecification.isNotEmpty ?
        Expanded(child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: HtmlWidget(
            productSpecification,
            customStylesBuilder: (element) {
              if (element.localName == 'table') return {'background-color': '#f2f2f2'};
              if (element.localName == 'th') return {'background-color': '#cccccc', 'padding': '6px'};
              if (element.localName == 'td') return {'padding': '6px'};
              return null;
            },
          ),
        )) :
        const Center(child: Text('No specification')),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        Center(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
            SpecificationScreen(specification: productSpecification))),
            child: Text(getTranslated('view_full_detail', context)!,
              style: titleRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
              Colors.white : Theme.of(context).primaryColor))))

      ],
    );
  }
}

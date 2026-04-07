import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
class SpecificationScreen extends StatelessWidget {
  final String specification;
  const SpecificationScreen({super.key, required this.specification});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(children: [
        CustomAppBar(title: getTranslated('specification', context)),
        Expanded(child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: HtmlWidget(
            specification,
            customStylesBuilder: (element) {
              if (element.localName == 'table') return {'background-color': '#f2f2f2'};
              if (element.localName == 'th') return {'background-color': '#cccccc', 'padding': '6px'};
              if (element.localName == 'td') return {'padding': '6px'};
              return null;
            },
          ),
        ))),
      ]),
    );
  }
}

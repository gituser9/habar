import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/settings_ctrl.dart';
import 'package:habar/common/util.dart';
import 'package:habar/common/widgets/html_image.dart';

class HtmlText extends StatelessWidget {
  final SettingsCtrl _settingsCtrl = Get.find();

  final String htmlText;

  HtmlText({
    super.key,
    required this.htmlText,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
        data: htmlText,
        shrinkWrap: true,
        style: {
          'body': Style(fontSize: FontSize(_settingsCtrl.settings.value.postTextSize)),
          'blockquote': Style(
            fontStyle: FontStyle.italic,
            fontSize: FontSize(_settingsCtrl.settings.value.postTextSize - 2),
          ),
          'pre': Style(
            fontStyle: FontStyle.normal,
            fontSize: FontSize(14),
          ),
          'figure': Style(
            margin: Margins(top: Margin.zero(), right: Margin.zero(), bottom: Margin.zero(), left: Margin.zero()),
            padding: HtmlPaddings.all(0),
          ),
          'img': Style(
            margin: Margins(top: Margin.zero(), right: Margin.zero(), bottom: Margin.zero(), left: Margin.zero()),
            padding: HtmlPaddings.all(0),
          ),
          'a': Style(textDecoration: TextDecoration.none),
        },
        extensions: [
          TagExtension(
              tagsToExtend: {'img'},
              builder: (ctx) {
                String? fullImg = ctx.attributes['data-src'];

                if (fullImg == null || fullImg.isEmpty) {
                  fullImg = ctx.attributes['src'] ?? '';
                }

                return HtmlImage(imageUrl: fullImg);
              }),
          TagExtension(
              tagsToExtend: {'figure'},
              builder: (ctx) {
                String? link = ctx.elementChildren.firstWhereOrNull((tag) => tag.localName == 'img')?.attributes['data-src'];

                if (link != null && link.isNotEmpty) {
                  return HtmlImage(imageUrl: link);
                }

                return Container();
              }),
          TagExtension(
              tagsToExtend: {'pre'},
              builder: (ctx) {
                var code = ctx.elementChildren.first.innerHtml ?? "";
                code = code.replaceAll('&nbsp;', ' ');
                code = code.replaceAll('&lt;', '<');
                code = code.replaceAll('&gt;', '>');

                return Scrollbar(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          color: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(code),
                            //child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
        onLinkTap: (String? url, Map<String, String> attributes, element) async {
          if (url != null) {
            await Util.launchInternal(url);
          }
        });
  }
}

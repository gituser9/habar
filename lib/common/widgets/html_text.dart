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
    Key? key,
    required this.htmlText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
        data: htmlText,
        shrinkWrap: true,
        style: {
          'body': Style(fontSize: FontSize(_settingsCtrl.settings.value.postTextSize)),
          'blockquote': Style(fontStyle: FontStyle.italic, fontSize: FontSize(_settingsCtrl.settings.value.postTextSize - 2)),
          'pre': Style(
            fontStyle: FontStyle.normal,
            fontSize: FontSize(14),
          ),
          'figure': Style(
              margin: Margins(top: Margin.zero(), right: Margin.zero(), bottom: Margin.zero(), left: Margin.zero()),
              padding: const EdgeInsets.all(0)),
          'img': Style(
              margin: Margins(top: Margin.zero(), right: Margin.zero(), bottom: Margin.zero(), left: Margin.zero()),
              padding: const EdgeInsets.all(0)),
          'a': Style(textDecoration: TextDecoration.none),
        },
        customRenders: {
          imgMatcher(): CustomRender.widget(widget: (ctx, buildChildren) {
            String? fullImg = ctx.tree.element?.attributes['data-src'];

            if (fullImg == null || fullImg.isEmpty) {
              fullImg = ctx.tree.element?.attributes['src'] ?? '';
            }

            return HtmlImage(imageUrl: fullImg);
          }),
          figMatcher(): CustomRender.widget(widget: (ctx, buildChildren) {
            for (final tag in ctx.tree.children) {
              if (tag.name == 'img') {
                String imgUrl = tag.element!.attributes['data-src'] ?? '';

                return HtmlImage(imageUrl: imgUrl);
              }
            }

            return Container();
          }),
          codeMatcher(): CustomRender.widget(widget: (ctx, buildChildren) {
            var code = ctx.tree.element?.children.first.innerHtml ?? "";
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
                      color: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
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
          })
        },
        onLinkTap: (String? url, RenderContext ctx, Map<String, String> attributes, element) async {
          if (url != null) {
            await Util.launchInternal(url);
          }
        });
  }

  CustomRenderMatcher imgMatcher() => (context) => context.tree.element?.localName == 'img';

  CustomRenderMatcher figMatcher() => (context) => context.tree.element?.localName == 'figure';

  CustomRenderMatcher codeMatcher() => (context) => context.tree.element?.localName == 'pre';
}

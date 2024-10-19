import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:habar/common/controllers/hide_bottombar_ctrl.dart';
import 'package:habar/hub/hub_ctrl.dart';
import 'package:habar/model/hub_company_list.dart';

class HubCompanyListWidget extends StatelessWidget {
  final HubCtrl _ctrl = Get.find();
  final String name;
  final HideBottomBarCtrl bottomCtrl;

  HubCompanyListWidget({
    super.key,
    required this.name,
    required this.bottomCtrl,
  }) {
    _ctrl.getCompanies(name, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Obx(() => _buildBody(_ctrl.hubCompanies.value)),
    );
  }

  Widget _buildBody(HubCompanyList companies) {
    return ListView.builder(
      controller: bottomCtrl.scrollCtrl,
      shrinkWrap: true,
      itemCount: companies.companyIds.length,
      itemBuilder: (ctx, index) {
        final companyId = companies.companyIds[index];
        final company = companies.companyRefs[companyId]!;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage('https:${company.imageUrl}'),
          ),
          title: Text(
            company.titleHtml,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Html(
            data: company.descriptionHtml,
            style: {
              'body': Style(
                fontSize: FontSize(13),
                color: Colors.grey,
                padding: HtmlPaddings.all(0),
                margin: Margins.all(0),
              ),
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:habar/hub/hub_ctrl.dart';
import 'package:habar/model/hub_company_list.dart';

class HubCompanyListWidget extends StatelessWidget {
  final HubCtrl ctrl = Get.find();
  final String name;

  HubCompanyListWidget({Key? key, required this.name}) : super(key: key) {
    ctrl.getCompanies(name, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 16),
      child: Obx(() => _buildBody(ctrl.hubCompanies.value)),
    );
  }

  Widget _buildBody(HubCompanyList companies) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: companies.companyIds.length,
      itemBuilder: (ctx, index) {
        final companyId = companies.companyIds[index];
        final company = companies.companyRefs[companyId]!;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage('https:' + company.imageUrl),
          ),
          title: Text(
            company.titleHtml,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Html(
            data: company.descriptionHtml,
            style: {
              'body': Style(
                fontSize: const FontSize(13),
                color: Colors.grey,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
              ),
            },
          ),
        );
      },
    );
  }
}

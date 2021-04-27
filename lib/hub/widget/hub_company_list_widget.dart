import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:habar/home/widgets/loading_widget.dart';
import 'package:habar/model/hub_company_list.dart';

class HubCompanyListWidget extends StatelessWidget {
  final Stream<HubCompanyList> stream;

  const HubCompanyListWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HubCompanyList>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          }

          final hubCompanyList = snapshot.data!;

          return Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: hubCompanyList.companyIds.length,
              itemBuilder: (ctx, index) {
                final companyId = hubCompanyList.companyIds[index];
                final company = hubCompanyList.companyRefs[companyId]!;

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
            ),
          );
        });
  }
}

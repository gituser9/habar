import 'package:flutter/material.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/hub/hub_screen.dart';
import 'package:habar/model/hub_list.dart';

class UserHubsWidget extends StatelessWidget {
  final List<HubRef> hubs;

  const UserHubsWidget({Key? key, required this.hubs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text('Состоит в хабах', style: Constant.profileHeadersStyle),
            ],
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              children: [
                for (final hub in hubs)
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HubScreen(name: hub.alias)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        child: Text(
                          hub.titleHtml,
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habar/model/hub.dart';

class HubInfoWidget extends StatelessWidget {
  final Hub hub;

  const HubInfoWidget({super.key, required this.hub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: 'https:${hub.imageUrl}',
                  placeholder: (context, url) => const Icon(Icons.image),
                  errorWidget: (context, url, error) => const Icon(Icons.image),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hub.statistics.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Text(
                    'Рейтинг',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            hub.titleHtml,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            hub.descriptionHtml,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/home/home_ctrl.dart';
import 'package:habar/model/home.dart';

class SavedSearchWidget extends StatelessWidget {
  final HomeCtrl _ctrl = Get.find();
  final _tfCtrl = TextEditingController();
  final _filter = SavedFilter();
  final _title = ''.obs;

  SavedSearchWidget({super.key}) {
    _ctrl.loadSavedSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // title
              const Text(
                'Поиск в сохраненных',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              // search field
              const SizedBox(height: 24),
              Obx(() => buildSearchField(_title.value)),

              // hub dropdown
              const SizedBox(height: 16),
              Obx(() => _buildHubDropdownMenu(_ctrl.savedSearchHubs)),

              // tag dropdown
              const SizedBox(height: 16),
              Obx(() => _buildTagDropdownMenu(_ctrl.savedSearchTags)),

              // apply button
              Expanded(child: Container()),
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField(String title) {
    return TextField(
      controller: _tfCtrl,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            _tfCtrl.clear();
            _title.value = '';
          },
          icon: const Icon(Icons.clear),
        ),
        labelText: 'Заголовок',
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) => _title.value = value,
    );
  }

  Widget _buildHubDropdownMenu(Set<String> hubs) {
    return DropdownMenu<String>(
      width: Get.width - (16 * 2),
      menuHeight: 300,
      hintText: 'Хабы',
      onSelected: (String? value) {
        _filter.hub = value ?? '';
      },
      dropdownMenuEntries: hubs.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }

  Widget _buildTagDropdownMenu(Set<String> tags) {
    return DropdownMenu<String>(
      width: Get.width - (16 * 2),
      menuHeight: 300,
      hintText: 'Теги',
      onSelected: (String? value) {
        _filter.tag = value ?? '';
      },
      dropdownMenuEntries: tags.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }

  Widget _buildApplyButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              Get.back();

              _filter.title = _title.value;
              _ctrl.filterSaved(_filter);
            },
            icon: const Icon(Icons.done_all, color: Colors.white),
            label: const Text('Применить', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

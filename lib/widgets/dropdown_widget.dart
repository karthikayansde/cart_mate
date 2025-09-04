import 'package:cart_mate/utils/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final String selectedTable;
  final List<String> list;
  final double? width;
  final ValueChanged<String> onChanged;

  const DropdownWidget({
    super.key,
    required this.selectedTable,
    required this.list,
    required this.onChanged, this.width,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        customButton: Container(
          height: 50,
          width: widget.width??130,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.selectedTable.split("mzqxv9rklt8ph2wj")[0],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
            ],
          ),
        ),
        value: widget.selectedTable,
        items: _buildItems(),
        onChanged: (String? value) {
          if (value != null) {
            widget.onChanged(value);
          }
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200, // Ensures enough height to show search field
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value!.split('mzqxv9rklt8ph2wj')[0].toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            searchController.clear(); // Clear search when dropdown closes
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildItems() {
    return widget.list.map((item) {
      final isSelected = widget.selectedTable == item;
      return DropdownMenuItem<String>(
        value: item,
        child: Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.split("mzqxv9rklt8ph2wj")[0],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: AppColors.primary, size: 16),
              ],
            ),
            Spacer(),
            Container(width: double.maxFinite,height: 0.5,color: AppColors.black,)
          ],
        ),
      );
    }).toList();
  }
}

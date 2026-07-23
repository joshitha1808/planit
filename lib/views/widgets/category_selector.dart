import 'package:flutter/material.dart';
import 'package:planit/constants.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/views/widgets/neo_box.dart';

class CategorySelector extends StatefulWidget {
  final Function(String)? onCategorySelected;

  const CategorySelector({super.key, this.onCategorySelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? selectedCategory;
  List<String> categories = List.from(AppConstants.todoCategories);

  void _addCustomCategory() async {
    String newCategory = "";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.radius),
            side: const BorderSide(
              color: AppColors.ink,
              width: AppStyles.borderWidth,
            ),
          ),
          title: const Text(
            "Add category",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: TextField(
            autofocus: true,
            onChanged: (value) => newCategory = value,
            decoration: const InputDecoration(hintText: "e.g. Fitness"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (newCategory.trim().isNotEmpty) {
                  setState(() {
                    categories.add(newCategory.trim());
                    selectedCategory = newCategory.trim();
                  });
                  widget.onCategorySelected?.call(newCategory.trim());
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: [
        ...categories.map((category) {
          final isSelected = selectedCategory == category;
          return NeoButton(
            color: isSelected
                ? AppColors.pastelFor(category)
                : AppColors.surfaceLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shadowOffset: const Offset(3, 3),
            onTap: () {
              setState(() => selectedCategory = category);
              widget.onCategorySelected?.call(category);
            },
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          );
        }),
        NeoButton(
          color: AppColors.surfaceLight,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shadowOffset: const Offset(3, 3),
          onTap: _addCustomCategory,
          child: const Icon(Icons.add_rounded, color: AppColors.ink, size: 24),
        ),
      ],
    );
  }
}

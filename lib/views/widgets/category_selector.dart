import 'package:flutter/material.dart';
import 'package:planit/constants.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

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
          title: const Text("Add Category"),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  setState(() {
                    categories.add(newCategory);
                  });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            ...categories.map((category) {
              return ChoiceChip(
                label: Text(
                  category,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                selected: selectedCategory == category,

                // selectedColor: Colors.black,
                // backgroundColor: Theme.of(context).colorScheme.primary,
                // labelStyle: TextStyle(
                //   color: selectedCategory == category
                //       ? Colors.black
                //       : Colors.black,
                // ),
                showCheckmark: false,
                onSelected: (_) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              );
            }),

            // Add Button
            ActionChip(
              label: const Icon(Icons.add, size: 28),
              onPressed: _addCustomCategory,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

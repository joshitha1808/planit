import 'package:flutter/material.dart';
import 'package:planit/views/widgets/category_selector.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String selectedOption = "Today";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.all(22),
                  side: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded, size: 24),
              ),
              Text(
                "New Task",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(22),
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.add, size: 24),
                  ),
                  SizedBox(width: 18),

                  ChoiceChip(
                    label: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    showCheckmark: false,
                    selected: selectedOption == "Today",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedOption = "Today";
                      });
                    },
                  ),
                  SizedBox(width: 18),
                  ChoiceChip(
                    label: Text(
                      "Tomorrow",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    showCheckmark: false,
                    selected: selectedOption == "Tomorrow",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedOption = "Tomorrow";
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(22),
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.add_alarm_outlined, size: 30),
                  ),
                  SizedBox(width: 10),

                  IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(22),
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.notification_add_outlined, size: 30),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                "CATEGORIES",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
              SizedBox(height: 20),
              CategorySelector(),

              SizedBox(height: 20),
              Text(
                "TITLE",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description(optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.9, // Make it wide
                  height: 80,

                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

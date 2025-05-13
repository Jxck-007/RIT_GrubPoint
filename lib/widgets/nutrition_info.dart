import 'package:flutter/material.dart';
import 'animations.dart';

class NutritionInfo extends StatefulWidget {
  final String itemName;
  final Map<String, String> nutritionData;

  const NutritionInfo({
    super.key,
    required this.itemName,
    required this.nutritionData,
  });

  @override
  State<NutritionInfo> createState() => _NutritionInfoState();
}

class _NutritionInfoState extends State<NutritionInfo> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            _isExpanded ? 'Hide Nutrition Info' : 'Show Nutrition Info',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_isExpanded)
          FadeInWidget(
            child: ScaleInWidget(
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nutrition Information for ${widget.itemName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.nutritionData.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                entry.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
} 
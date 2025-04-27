import 'package:flutter/material.dart';
import '../providers/menu_provider.dart';
import 'package:provider/provider.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  double _rating = 0;
  bool _isVegOnly = false;
  bool _isNonVegOnly = false;

  @override
  void initState() {
    super.initState();
    // Initialize filter values from provider
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    _priceRange = RangeValues(
      menuProvider.minPriceFilter,
      menuProvider.maxPriceFilter,
    );
    _rating = menuProvider.minRatingFilter;
    _isVegOnly = menuProvider.showVegOnly;
    _isNonVegOnly = menuProvider.showNonVegOnly;
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(0, 1000);
                    _rating = 0;
                    _isVegOnly = false;
                    _isNonVegOnly = false;
                  });
                  menuProvider.resetFilters();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Price Range Slider
          const Text(
            'Price Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 10,
            labels: RangeLabels(
              '₹${_priceRange.start.round()}',
              '₹${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
            onChangeEnd: (values) {
              menuProvider.setPriceRange(values.start, values.end);
            },
          ),
          
          // Min Rating Slider
          const Text(
            'Minimum Rating',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _rating.toString(),
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  onChangeEnd: (value) {
                    menuProvider.setMinRating(value);
                  },
                ),
              ),
              Text('${_rating.toStringAsFixed(1)}⭐'),
            ],
          ),
          
          // Veg/Non-veg filters
          const Text(
            'Dietary Preferences',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          CheckboxListTile(
            title: const Text('Veg Only'),
            value: _isVegOnly,
            onChanged: (value) {
              setState(() {
                _isVegOnly = value ?? false;
                if (_isVegOnly) {
                  _isNonVegOnly = false;
                }
              });
              menuProvider.setVegFilter(_isVegOnly);
            },
          ),
          CheckboxListTile(
            title: const Text('Non-Veg Only'),
            value: _isNonVegOnly,
            onChanged: (value) {
              setState(() {
                _isNonVegOnly = value ?? false;
                if (_isNonVegOnly) {
                  _isVegOnly = false;
                }
              });
              menuProvider.setNonVegFilter(_isNonVegOnly);
            },
          ),
          
          // Apply Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
} 
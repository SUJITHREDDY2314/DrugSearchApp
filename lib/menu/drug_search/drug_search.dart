import 'package:flutter/material.dart';
import 'package:flutter_application_1/menu/drug_search/drug_detail.dart';
import 'package:flutter_application_1/menu/menu_page.dart';
import 'dart:async'; // For debounce

import 'drug_service.dart'; // Import the drug service

class DrugSearch extends StatefulWidget {
  @override
  _DrugSearchState createState() => _DrugSearchState();
}

class _DrugSearchState extends State<DrugSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _drugs = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Timer? _debounce;

  // Function to search drugs based on input text
  void _searchDrugs(String query) async {
    if (query.isEmpty) {
      setState(() {
        _drugs = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await DrugService.searchDrugsByPrefix(query);
      setState(() {
        _drugs = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load drug data. Please try again.';
        _isLoading = false;
      });
    }
  }

  // Debounce the search input to reduce the number of API calls
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchDrugs(query);
    });
  }

  // Display drug details in the card
  Widget _buildDrugCard(dynamic drug) {
    String strength = '';
    if (drug['active_ingredients'] != null &&
        drug['active_ingredients'].isNotEmpty) {
      strength = drug['active_ingredients'][0]['strength'] ?? '';
    }

    String title = drug['brand_name'] ?? 'No brand name available';
    if (strength.isNotEmpty) {
      title += ' ($strength)';
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(drug['generic_name'] ?? 'No generic name available'),
        trailing: const Icon(Icons.info_outline),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DrugDetailPage(productNDC: drug['product_ndc']),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce timer on dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drug Search')),
      drawer: const MenuPage(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field with listener for real-time updates
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,  // Calls _onSearchChanged on every change
              decoration: InputDecoration(
                labelText: 'Search for a drug',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Loading indicator or error message
            if (_isLoading) CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: TextStyle(color: Colors.red)),

            // Display the results
            Expanded(
              child: ListView.builder(
                itemCount: _drugs.length,
                itemBuilder: (context, index) {
                  return _buildDrugCard(_drugs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

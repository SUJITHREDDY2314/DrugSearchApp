import 'package:flutter/material.dart';
import 'drug_service.dart'; // Import the service

class DrugDetailPage extends StatefulWidget {
  final String productNDC;

  const DrugDetailPage({Key? key, required this.productNDC}) : super(key: key);

  @override
  State<DrugDetailPage> createState() => _DrugDetailPageState();
}

class _DrugDetailPageState extends State<DrugDetailPage> {
  Map<String, dynamic>? _drugDetails;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDrugDetails();
  }

  Future<void> _fetchDrugDetails() async {
    try {
      final drugDetails = await DrugService.fetchDrugDetails(widget.productNDC);
      setState(() {
        _drugDetails = drugDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _getValue(dynamic value) {
    if (value is List) {
      return value.map((v) => _extractAfterColon(v)).join(', ');
    } else if (value is String) {
      return _extractAfterColon(value);
    } else {
      return 'N/A';
    }
  }

  String _extractAfterColon(String value) {
    // Check if the string contains a colon and return the part after the colon
    int colonIndex = value.indexOf(':');
    if (colonIndex != -1) {
      // Return the substring after the colon, trimming any leading spaces
      return value.substring(colonIndex + 1).trim();
    }
    return value; // Return the original value if no colon is found
  }

  Widget _buildSection(String title, dynamic value, {bool expandable = false}) {
    if (value == null ||
        (value is String && value.isEmpty) ||
        (value is List && value.isEmpty)) {
      return Container();
    }

    if (expandable) {
      return ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _getValue(value),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              _getValue(value),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      _buildSection(
                        'Brand Name',
                        _drugDetails?['openfda']?['brand_name'],
                      ),
                      _buildSection(
                        'Generic Name',
                        _drugDetails?['openfda']?['generic_name'],
                      ),
                      _buildSection(
                        'Manufacturer',
                        _drugDetails?['openfda']?['manufacturer_name'],
                      ),
                      _buildSection(
                        'Active Ingredients',
                        _drugDetails?['active_ingredient'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Inactive Ingredients',
                        _drugDetails?['inactive_ingredient'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Description',
                        _drugDetails?['description'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Clinical Pharmacology',
                        _drugDetails?['clinical_pharmacology'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Indications and Usage',
                        _drugDetails?['indications_and_usage'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Contraindications',
                        _drugDetails?['contraindications'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Warnings',
                        _drugDetails?['warnings'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Precautions',
                        _drugDetails?['precautions'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Carcinogenesis, Mutagenesis, Impairment of Fertility',
                        _drugDetails?[
                            'carcinogenesis_mutagenesis_impairment_of_fertility'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Pregnancy',
                        _drugDetails?['pregnancy'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Nursing Mothers',
                        _drugDetails?['nursing_mothers'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Pediatric Use',
                        _drugDetails?['pediatric_use'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Adverse Reactions',
                        _drugDetails?['adverse_reactions'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Overdosage',
                        _drugDetails?['overdosage'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Dosage and Administration',
                        _drugDetails?['dosage_and_administration'],
                        expandable: true,
                      ),
                      _buildSection(
                        'How Supplied',
                        _drugDetails?['how_supplied'],
                        expandable: true,
                      ),
                      _buildSection(
                        'Storage and Handling',
                        _drugDetails?['storage_and_handling'],
                        expandable: true,
                      ),
                    ],
                  ),
                ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class DrugService {
  static Future<List<dynamic>> searchDrugsByPrefix(String prefix) async {
    const String baseUrl = 'https://api.fda.gov/drug/ndc.json';

    final response = await http.get(
      Uri.parse('$baseUrl?search=brand_name:$prefix*&limit=10'), // Searching for drugs with names starting with the prefix
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception('Failed to load drug data: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>?> fetchDrugDetails(String productNDC) async {
    const String baseUrl = 'https://api.fda.gov/drug/label.json';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl?search=openfda.product_ndc:$productNDC&limit=1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results']?.first;
      } else {
        throw Exception('Failed to fetch drug details.');
      }
    } catch (e) {
      throw Exception('Error fetching drug details: $e');
    }
  }
}


import 'package:flutter/material.dart';

class AirQualityHomePage extends StatefulWidget {
  const AirQualityHomePage({super.key});

  @override
  State<AirQualityHomePage> createState() => _AirQualityHomePageState();
}

class _AirQualityHomePageState extends State<AirQualityHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = '';

  void _search() {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan minimal 2 karakter kota')),
      );
      return;
    }
    setState(() {
      _selectedCity = query;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AirScope'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari Kota',
                      hintText: 'Contoh: Makassar, Jakarta',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_selectedCity.isNotEmpty)
              Text(
                'Kota dipilih: $_selectedCity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
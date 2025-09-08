import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';

import '../../service/api_deliveryservice/model/delivery_service.dart';

class DeliveryGrid extends StatelessWidget {
  final Future<DeliveryResponse> futureDelivery;
  final Function(Area) onSelect;

  const DeliveryGrid({
    Key? key,
    required this.futureDelivery,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DeliveryResponse>(
      future: futureDelivery,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.area.isEmpty) {
          return const Center(child: Text("No services available"));
        }

        final services = snapshot.data!.area;

        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(2),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // adjust for tablet/phone
            childAspectRatio: 1.5,
            crossAxisSpacing: 30,
            mainAxisSpacing: 8,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildDeliveryItem(service);
          },
        );
      },
    );
  }

  /// ========== Single Item ==========
  Widget _buildDeliveryItem(Area service) {
    return GestureDetector(
      onTap: () => onSelect(service),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: service.image.isNotEmpty
                  ? Image.network(
                "$RUE_BASE${service.image}",
                fit: BoxFit.contain,
                errorBuilder: (c, o, s) =>
                const Icon(Icons.image, size: 40),
              )
                  : const Icon(Icons.image, size: 40),
            ),
            Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                service.deliveryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

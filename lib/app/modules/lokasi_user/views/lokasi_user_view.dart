import 'package:app_rental_mobil/app/utils/constants_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../controllers/lokasi_user_controller.dart';

class LokasiUserView extends GetView<LokasiUserController> {
  const LokasiUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Realtime User'),
        centerTitle: true,
      ),
      body: Obx(
        () => FlutterMap(
          mapController: controller.mapC,
          options: MapOptions(
            initialCenter: const LatLng(-3.34871, 118.1821025),
            initialZoom: controller.zoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app_rental_mobil',
              retinaMode: true,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: controller.pointMarker.value,
                  width: 48,
                  height: 48,
                  child: Obx(
                    () => Transform.rotate(
                      angle: controller.rotationAngle.value *
                          (3.14159265359 / 180),
                      child: Image.asset(
                        ConstantsAssets.icCar,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              controller.mapC.move(
                controller.pointMarker.value,
                controller.zoom,
              );
            },
            child: const Icon(Icons.directions_car_rounded),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              controller.zoom++;
              controller.mapC
                  .move(controller.pointMarker.value, controller.zoom);
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              controller.zoom--;
              controller.mapC
                  .move(controller.pointMarker.value, controller.zoom);
            },
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}

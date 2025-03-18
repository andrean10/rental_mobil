import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LokasiUserController extends GetxController {
  late final InitController _initC;

  late final MapController mapC;
  var zoom = 15.0;
  final pointMarker = const LatLng(0.4746059, 101.3719772).obs;
  final previousPointMarker = const LatLng(0.4746059, 101.3719772).obs;
  final rotationAngle = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initController();
  }

  void _initController() {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }

    mapC = MapController();

    mapC.mapEventStream.listen((event) {
      zoom = event.camera.zoom;
    });

    final uidPesanan = Get.arguments as String?;

    if (uidPesanan != null) {
      _getRealtimeLocation(uidPesanan);
    }
  }

  void _getRealtimeLocation(String uidPesanan) {
    _initC.firestore
        .collection('pesanan')
        .where(FieldPath.documentId, isEqualTo: uidPesanan)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              PesananModel.fromFirestore(snapshot.data()!),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .limit(1)
        .snapshots()
        .listen((event) {
      final data = event.docs.first.data();
      final location = data.userOrder?.order?.location;

      if (location != null) {
        print('posisi user = ${location.latitude}, ${location.longitude}');
        print('lokasi marker dipindahkan');

        final latLng = LatLng(location.latitude, location.longitude);

        // Calculate direction
        final deltaLat = latLng.latitude - previousPointMarker.value.latitude;
        final deltaLng = latLng.longitude - previousPointMarker.value.longitude;
        rotationAngle.value = _calculateRotationAngle(deltaLat, deltaLng);

        previousPointMarker.value = latLng; // Update previous location
        mapC.move(latLng, zoom);
        pointMarker.value = latLng;
      }
    });
  }

  double _calculateRotationAngle(double deltaLat, double deltaLng) {
    return deltaLng == 0 && deltaLat == 0
        ? rotationAngle.value
        : (deltaLng == 0
            ? (deltaLat > 0 ? 0 : 180)
            : (deltaLat == 0
                ? (deltaLng > 0 ? 90 : -90)
                : (deltaLng > 0
                    ? (deltaLat > 0 ? 45 : 135)
                    : (deltaLat > 0 ? -45 : -135))));
  }
}

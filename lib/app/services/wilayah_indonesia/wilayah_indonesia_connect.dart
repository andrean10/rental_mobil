// import 'package:get/get.dart';
// import 'package:jodoh_syariah/utils/constants_connect.dart';

// class WilayahIndonesiaConnect extends GetConnect {
//   Future<Response> get getProvinsi =>
//       get('${ConstantsConnect.endPointWilayahIndonesia}provinces.json');

//   Future<Response> getKabAtauKota(int provinsiId) => get(
//       '${ConstantsConnect.endPointWilayahIndonesia}regencies/$provinsiId.json');

//   Future<Response> getKecamatan(int kabAtauKotaId) => get(
//       '${ConstantsConnect.endPointWilayahIndonesia}districts/$kabAtauKotaId.json');

//   Future<Response> getKelurahan(int kecamatanId) => get(
//       '${ConstantsConnect.endPointWilayahIndonesia}villages/$kecamatanId.json');
// }

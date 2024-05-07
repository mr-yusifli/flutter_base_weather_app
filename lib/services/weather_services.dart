import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:havadurumu/models/weather_models.dart';

class WeatherServices {
  Future<String> _getLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error("Konum servisi kapali");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error("Konum izni vermelisiniz");
      }
    }

    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    final String? city = placemark[0].administrativeArea;

    if (city == null) {
      throw Exception("Şehir bulunamadı");
    }
    return city;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await _getLocation();

    final String url =
        "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city";
    const Map<String, dynamic> headers = {
      "authorization": "apikey 3AQaSelZfjLMm5FhsHaLrO:7BeYBlYdCQRp223RHRAyOP",
      "content-type": "application/json"
    };

    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return Future.error("Bir sorun olustu");
    }

    final List list = response.data['result'];
    final List<WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();

    return weatherList;
    // print(response.data);
  }
}

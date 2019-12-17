import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String tickerDataURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class CoinData {
  // networking - returning decoded JSON data.
  Future<Map> getCoinData(String selectedCurrency) async {
    // storing prices of three cryptocurrencies into a Map.
    Map<String, String> coinPricesMap = {};

    for (String crypto in cryptoList) {
      // or '$tickerDataURL/$crypto$selectedCurrency'
      String finalURL = tickerDataURL + crypto + selectedCurrency;

      // GET request to URL (await for response).
      http.Response response = await http.get(finalURL);

      // if successful response, add crypto price to Map.
      if (response.statusCode == 200) {
        // decoding means changing String data to JSON data.
        // 2 tasks: 1)passing response.body to be decoded + 2)decoding JSON data.
        var decodedJSONData = jsonDecode(response.body);

        double lastPrice = decodedJSONData['last'].toDouble(); // getting price

        // casting 0 decimals after dot --> instead of decodedJSONData['last'].toInt().toString();
        coinPricesMap[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request'; // optional: throw an error if our request fails.
      }
    }
    return coinPricesMap;
  }
}

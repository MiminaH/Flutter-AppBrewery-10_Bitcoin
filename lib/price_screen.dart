import 'package:flutter/material.dart';
import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
// show keyword allows to incorporate only a certain class.
// hide keyword allows to incorporate all classes but hide a certain class.
// as keyword allows to renames entire package

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'AUD';

  // storing prices of three cryptocurrencies into a Map.
  Map<String, String> coinPricesMap = {};

  // boolean used to display ? while waiting for price data.
  bool isWaiting = true;

  void getData() async {
    isWaiting = true; // set to true till request for prices is initiate.

    try {
      // or (no class initialization needed): await CoinData().getCoinData(selectedCurrency);
      // can't await in a setState(), thus separate it into two steps.
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false; // when above code completes, no need to wait.

      setState(() {
        coinPricesMap = data; // storing Map data in setState.
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      // fetching constants String List.
      var newItem = DropdownMenuItem(
        child: Text(
          currency,
          style: TextStyle(fontSize: 20.0),
        ),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      // must update Value property in onChange to display to user.
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        // value is the selected DropdownItem returned by DropdownButton Widget.
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    // note: don't initialize List as null! --> List<Text> pickerItems;
    // must initialize as empty list to be able to add to it.
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      // fetching constants String List.
      var textWidget = Text(currency);
      pickerItems.add(textWidget);
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          getData();
        },
        children: pickerItems);
  }

  //  Widget getPicker() {
  //    if (Platform.isIOS) {
  //      return iOSPicker();
  //    } else if (Platform.isAndroid) {
  //      return androidDropdown();
  //    }
  //  } using Ternary Operator below instead (in Container child)

  // a method that loops through the cryptoList & generates a CryptoCard for each.
  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cyptoCurrency: crypto,
          price: isWaiting ? '?' : coinPricesMap[crypto],
          displayCurrency: selectedCurrency,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown())
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.cyptoCurrency,
    @required this.price,
    @required this.displayCurrency,
  });

  final String cyptoCurrency;
  final String price;
  final String displayCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cyptoCurrency = $price $displayCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

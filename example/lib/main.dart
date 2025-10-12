import 'package:u_credit_card/u_credit_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _cardController = CreditCardController();
  final _cvvFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Flip to back when CVV field gets focus
    _cvvFocusNode.addListener(() {
      if (_cvvFocusNode.hasFocus) {
        _cardController.flipToBack();
      } else {
        _cardController.flipToFront();
      }
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("u_credit_card")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreditCardUi(
              controller: _cardController,
              width: 300,
              cardHolderFullName: 'John Doe',
              cardNumber: '1234567812345678',
              validFrom: '01/23',
              validThru: '01/28',
              topLeftColor: Colors.blue,
              doesSupportNfc: true,
              placeNfcIconAtTheEnd: true,
              cardType: CardType.debit,
              cardProviderLogo: const FlutterLogo(),
              cardProviderLogoPosition: CardProviderLogoPosition.right,
              showBalance: true,
              balance: 128.32434343,
              autoHideBalance: true,
              enableFlipping: true,
              cvvNumber: '123',
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                focusNode: _cvvFocusNode,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: 'Enter CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _cardController.flipCard();
              },
              child: const Text('Flip Card Manually'),
            ),
          ],
        ),
      ),
    );
  }
}

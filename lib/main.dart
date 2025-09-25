import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator sederhana',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";
  bool _shouldResetOutput = false;

  // Fungsi untuk format angka: hilangkan .0 jika bilangan bulat
  String _formatNumber(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString(); // Tampilkan sebagai integer
    } else {
      return num.toString(); // Tampilkan sebagai double
    }
  }

  // Fungsi untuk mendapatkan tampilan yang user-friendly dari angka
  String _getDisplayNumber(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString();
    } else {
      return num.toString();
    }
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _expression = "";
        _num1 = 0;
        _num2 = 0;
        _operator = "";
        _shouldResetOutput = false;
      } else if (buttonText == "⌫") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else if (buttonText == "%") {
        double currentValue = double.parse(_output);
        double result = currentValue / 100;
        _output = _formatNumber(result);
      } else if (buttonText == "=") {
        if (_operator.isNotEmpty) {
          _num2 = double.parse(_output);
          
          // Gunakan format yang user-friendly untuk expression
          String displayNum1 = _getDisplayNumber(_num1);
          String displayNum2 = _getDisplayNumber(_num2);
          _expression = "$displayNum1 $_operator $displayNum2 =";
          
          double result = 0;
          bool error = false;
          
          switch (_operator) {
            case "+":
              result = _num1 + _num2;
              break;
            case "-":
              result = _num1 - _num2;
              break;
            case "×":
              result = _num1 * _num2;
              break;
            case "÷":
              if (_num2 != 0) {
                result = _num1 / _num2;
              } else {
                error = true;
                _output = "Error";
              }
              break;
          }
          
          if (!error) {
            _output = _formatNumber(result);
          }
          
          _operator = "";
          _shouldResetOutput = true;
        }
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        if (_operator.isEmpty) {
          _num1 = double.parse(_output);
          _operator = buttonText;
          
          // Gunakan format yang user-friendly untuk expression
          String displayNum1 = _getDisplayNumber(_num1);
          _expression = "$displayNum1 $_operator";
          _shouldResetOutput = true;
        }
      } else {
        if (_output == "0" || _shouldResetOutput) {
          _output = buttonText;
          _shouldResetOutput = false;
        } else {
          // Cegah multiple decimal points
          if (buttonText == "." && _output.contains(".")) {
            return;
          }
          // Cegah angka 0 di depan (kecuali untuk desimal)
          if (_output == "0" && buttonText != ".") {
            _output = buttonText;
          } else {
            _output += buttonText;
          }
        }
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color, Color textColor = Colors.white, bool isWide = false}) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(20),
            elevation: 2,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        _output,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Button area
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Row 1
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("C", color: Colors.grey, textColor: Colors.black),
                          _buildButton("⌫", color: Colors.grey, textColor: Colors.black),
                          _buildButton("%", color: Colors.grey, textColor: Colors.black),
                          _buildButton("÷", color: Colors.orange),
                        ],
                      ),
                    ),
                    
                    // Row 2
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("7"),
                          _buildButton("8"),
                          _buildButton("9"),
                          _buildButton("×", color: Colors.orange),
                        ],
                      ),
                    ),
                    
                    // Row 3
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("4"),
                          _buildButton("5"),
                          _buildButton("6"),
                          _buildButton("-", color: Colors.orange),
                        ],
                      ),
                    ),
                    
                    // Row 4
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("1"),
                          _buildButton("2"),
                          _buildButton("3"),
                          _buildButton("+", color: Colors.orange),
                        ],
                      ),
                    ),
                    
                    // Row 5
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("0", isWide: true),
                          _buildButton("."),
                          _buildButton("=", color: Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
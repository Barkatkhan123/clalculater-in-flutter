import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String input = ''; // Stores the current input by the user
  String result = '0'; // Stores the calculated result

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Display input and result with improved UI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 40, // Set height for input field
                  width: double.infinity,
                  child: Text(
                    input,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50, // Set height for result field
                  width: double.infinity,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Buttons grid with custom button styles
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildButtonRow(['C', 'DEL', '%', '/'], isTopRow: true),
                  buildButtonRow(['7', '8', '9', '*']),
                  buildButtonRow(['4', '5', '6', '-']),
                  buildButtonRow(['1', '2', '3', '+']),
                  buildButtonRow(['00', '0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to create a button row
  Widget buildButtonRow(List<String> buttonLabels, {bool isTopRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttonLabels
          .map((label) => calcButton(label, isTopRow: isTopRow))
          .toList(),
    );
  }

  // Function to create an individual button
  Widget calcButton(String label, {bool isTopRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          handleButtonPress(label);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          backgroundColor:
              isOperator(label) ? Colors.blueAccent : Colors.grey[200],
          foregroundColor: isOperator(label) ? Colors.white : Colors.black,
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isTopRow ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Check if a button is an operator
  bool isOperator(String button) {
    return ['+', '-', '*', '/', '=', '%'].contains(button);
  }

  void handleButtonPress(String button) {
    setState(() {
      if (button == 'C') {
        // Clear all input and reset result
        input = '';
        result = '0';
      } else if (button == 'DEL') {
        // Delete last character
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (button == '=') {
        // Evaluate the input and set the result
        try {
          result = evaluateExpression(input).toString();
          input = ''; // Clear input after calculating
        } catch (e) {
          result = 'Error';
        }
      } else {
        // If the result is not '0', prepend the result to input
        if (result != '0') {
          input = result;
          result = '0';
        }
        // Append button text to input
        input += button;
      }
    });
  }

  // Function to evaluate the expression
  double evaluateExpression(String expression) {
    try {
      // Replace '%' with '/100' for percentage calculations
      expression = expression.replaceAll('%', '/100');

      // Use the math_expressions package to parse and evaluate the expression
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);

      return eval;
    } catch (e) {
      throw Exception("Invalid expression");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/calculator_state.dart';

import '../../../../core/presentation/widgets/mirror_scaffold.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MirrorScaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              color:
                  Colors.black54, // Semi-transparent background for readability
              child: Watch((context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CalculatorState.history.value,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        CalculatorState.displayValue.value,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          // Keypad Area
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black45, // Semi-transparent background
              child: Column(
                children: [
                  _buildRow(['C', 'DEL', '%', '÷']),
                  _buildRow(['7', '8', '9', '×']),
                  _buildRow(['4', '5', '6', '-']),
                  _buildRow(['1', '2', '3', '+']),
                  _buildRow(['0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Expanded(
      child: Row(
        children: labels.map((label) {
          return Expanded(
            flex: label == '0' ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildButton(label),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    Color bgColor = Colors.white10;
    Color fgColor = Colors.white;

    if (['÷', '×', '-', '+', '='].contains(label)) {
      bgColor = Colors.orange;
      fgColor = Colors.white;
    } else if (['C', 'DEL', '%'].contains(label)) {
      bgColor = Colors.grey;
      fgColor = Colors.black;
    }

    return ElevatedButton(
      onPressed: () => _handlePress(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: label == '0' ? const StadiumBorder() : const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _handlePress(String label) {
    switch (label) {
      case 'C':
        CalculatorState.clear();
        break;
      case 'DEL':
        CalculatorState.delete();
        break;
      case '%':
        // Not implemented in basic version
        break;
      case '÷':
      case '×':
      case '-':
      case '+':
        CalculatorState.inputOperator(label);
        break;
      case '=':
        CalculatorState.calculate();
        break;
      case '.':
        CalculatorState.inputDecimal();
        break;
      default:
        CalculatorState.inputDigit(label);
    }
  }
}

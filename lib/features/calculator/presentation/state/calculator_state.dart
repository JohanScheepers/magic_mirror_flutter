import 'package:signals_flutter/signals_flutter.dart';

class CalculatorState {
  // State signals
  static final displayValue = signal<String>('0');
  static final history = signal<String>('');

  // Internal state
  static double? _firstOperand;
  static String? _operator;
  static bool _shouldResetDisplay = false;

  /// Input a digit (0-9)
  static void inputDigit(String digit) {
    if (_shouldResetDisplay) {
      displayValue.value = digit;
      _shouldResetDisplay = false;
    } else {
      if (displayValue.value == '0') {
        displayValue.value = digit;
      } else {
        displayValue.value += digit;
      }
    }
  }

  /// Input a decimal point
  static void inputDecimal() {
    if (_shouldResetDisplay) {
      displayValue.value = '0.';
      _shouldResetDisplay = false;
    } else if (!displayValue.value.contains('.')) {
      displayValue.value += '.';
    }
  }

  /// Input an operator (+, -, *, /)
  static void inputOperator(String op) {
    if (_firstOperand == null) {
      _firstOperand = double.tryParse(displayValue.value);
    } else if (_operator != null && !_shouldResetDisplay) {
      // Calculate intermediate result if chaining operators
      _calculate();
    }

    _operator = op;
    _shouldResetDisplay = true;
    history.value = '${_formatNumber(_firstOperand!)} $op';
  }

  /// Perform calculation
  static void calculate() {
    if (_operator == null || _firstOperand == null) return;

    _calculate();
    _operator = null;
    _firstOperand = null;
    _shouldResetDisplay = true;
    history.value = '';
  }

  static void _calculate() {
    final secondOperand = double.tryParse(displayValue.value);
    if (secondOperand == null) return;

    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
      case '*':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
      case '/':
        if (secondOperand != 0) {
          result = _firstOperand! / secondOperand;
        } else {
          displayValue.value = 'Error';
          _shouldResetDisplay = true;
          return;
        }
        break;
    }

    _firstOperand = result;
    displayValue.value = _formatNumber(result);
  }

  /// Clear all
  static void clear() {
    displayValue.value = '0';
    history.value = '';
    _firstOperand = null;
    _operator = null;
    _shouldResetDisplay = false;
  }

  /// Delete last character
  static void delete() {
    if (_shouldResetDisplay) return;

    if (displayValue.value.length > 1) {
      displayValue.value = displayValue.value.substring(
        0,
        displayValue.value.length - 1,
      );
    } else {
      displayValue.value = '0';
    }
  }

  /// Format number to remove trailing zeros
  static String _formatNumber(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString();
    }
    return num.toString();
  }
}

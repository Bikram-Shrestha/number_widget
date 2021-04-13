library number_widget;

import 'package:flutter/material.dart';

typedef OnChanged = void Function(num);

///NumberPicker provide a way to insert number with the given range
///by either pressing increment and decrement widget or by inserting the
///value in the textfield
class NumberPicker extends StatefulWidget {
  /// [value] represent the current value of the number picker
  final num value;

  /// Whether to enable or disable the textfield
  final bool enableTextField;

  /// Minimum value a user can input
  final num minimumValue;

  /// Maximum value a user can input
  final num maximumValue;

  /// Style used for textfield
  final TextStyle style;

  /// Value used to increase/decrease the existing value
  final num step;

  /// Text that is used when the user input invalid/out of range value in textfield
  final String invalidText;

  /// Widget that represent widget that can be pressed to incrase value by given [step] amount
  final Widget increase;

  /// Widget that represent widget that can be pressed to decreased value by given [step] amount
  final Widget decrease;

  /// call back to update the value
  final OnChanged onChanged;

  /// input decoration for the textformfield
  final InputDecoration inputDecoration;

  const NumberPicker({
    Key key,
    @required this.value,
    @required this.minimumValue,
    @required this.maximumValue,
    @required this.onChanged,
    this.enableTextField = true,
    this.increase = const Icon(Icons.add),
    this.decrease = const Icon(Icons.remove),
    this.invalidText = 'Out of range',
    this.inputDecoration,
    this.style = const TextStyle(color: Colors.white),
    this.step = 1,
  })  : assert(value != null),
        assert(minimumValue != null),
        assert(maximumValue != null),
        assert(onChanged != null),
        super(key: key);
  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  num _value;
  FocusNode _textFieldFocusNode;

  @override
  void initState() {
    _textEditingController = TextEditingController(
      text: widget.value.toString(),
    );
    _textFieldFocusNode = FocusNode();
    _value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
    setState(() => _textEditingController.text = _value.toString());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _updateValue() {
    widget.onChanged(_value);
  }

  void _increase() {
    _value = ((_value + widget.step) >= widget.maximumValue)
        ? widget.maximumValue
        : _value + widget.step;
    _updateValue();
  }

  void _decrease() {
    _value = ((_value - widget.step) <= widget.minimumValue)
        ? widget.minimumValue
        : _value - widget.step;
    _updateValue();
  }

  void _onTextFieldValueChange(String value) {
    if (isValidValue(value)) {
      _value = num.parse(value);
    }
    _updateValue();
  }

  bool isValidValue(String value) {
    final num parsedValue = num.tryParse(value);
    if (parsedValue != null) {
      if (parsedValue <= widget.maximumValue &&
          parsedValue >= widget.minimumValue) {
        return true;
      }
    }
    return false;
  }

  String _validate(String value) =>
      isValidValue(value) ? null : widget.invalidText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Spacer(),
        TextButton(onPressed: _decrease, child: widget.decrease),
        Flexible(
          child: TextFormField(
            style: widget.style,
            enabled: widget.enableTextField,
            focusNode: _textFieldFocusNode,
            autovalidateMode: AutovalidateMode.always,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: _textEditingController,
            onChanged: _onTextFieldValueChange,
            decoration: widget.inputDecoration ?? _defaultDecoration,
            validator: _validate,
          ),
        ),
        TextButton(onPressed: _increase, child: widget.increase),
        const Spacer(),
      ],
    );
  }
}

const InputDecoration _defaultDecoration = InputDecoration(
    fillColor: Color(0xFF00ACEF),
    filled: true,
    contentPadding: EdgeInsets.zero,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none);
